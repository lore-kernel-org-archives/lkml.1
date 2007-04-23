Return-Path: <linux-kernel-owner+w=401wt.eu-S1161235AbXDWGUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161235AbXDWGUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161223AbXDWGUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:20:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161216AbXDWGUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:20:02 -0400
Date: Sun, 22 Apr 2007 23:20:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: slab allocators: Remove SLAB_DEBUG_INITIAL flag
In-Reply-To: <20070422230841.7d99ebb1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704222318010.2338@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704201832030.13607@schroedinger.engr.sgi.com>
 <20070422230841.7d99ebb1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Andrew Morton wrote:

> This patch causes a use-uninitialised crash in the locks code.

Sigh. The only case in which the check is inverted in a constructor.

Invert the check.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/fs/locks.c
===================================================================
--- linux-2.6.21-rc6.orig/fs/locks.c	2007-04-22 23:17:29.000000000 -0700
+++ linux-2.6.21-rc6/fs/locks.c	2007-04-22 23:17:45.000000000 -0700
@@ -203,7 +203,7 @@ static void init_once(void *foo, struct 
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
+	if (!(flags & SLAB_CTOR_CONSTRUCTOR))
 		return;
 
 	locks_init_lock(lock);
