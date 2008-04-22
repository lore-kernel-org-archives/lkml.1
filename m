Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbYDVP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbYDVP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYDVP5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:57:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYDVP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:57:51 -0400
Message-ID: <480E0AE7.2010709@redhat.com>
Date: Tue, 22 Apr 2008 10:57:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] mark inflate functions as noinline_for_stack
References: <480E06A6.1080803@redhat.com>
In-Reply-To: <480E06A6.1080803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the self-documenting noinline_for_stack attribute
in inflate functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/lib/inflate.c
===================================================================
--- linux-2.6.25.orig/lib/inflate.c	2008-04-22 10:31:00.923406674 -0500
+++ linux-2.6.25/lib/inflate.c	2008-04-22 10:51:19.219407765 -0500
@@ -716,10 +716,7 @@ DEBG("<stor");
 }
 
 
-/*
- * We use `noinline' here to prevent gcc-3.5 from using too much stack space
- */
-STATIC int noinline INIT inflate_fixed(void)
+STATIC int noinline_for_stack INIT inflate_fixed(void)
 /* decompress an inflated type 1 (fixed Huffman codes) block.  We should
    either replace this with a custom decoder, or at least precompute the
    Huffman tables. */
@@ -780,10 +777,7 @@ DEBG("<fix");
 }
 
 
-/*
- * We use `noinline' here to prevent gcc-3.5 from using too much stack space
- */
-STATIC int noinline INIT inflate_dynamic(void)
+STATIC int noinline_for_stack INIT inflate_dynamic(void)
 /* decompress an inflated type 2 (dynamic Huffman codes) block. */
 {
   int i;                /* temporary variables */

