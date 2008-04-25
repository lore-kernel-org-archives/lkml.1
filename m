Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbYDYWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbYDYWmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYDYWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:42:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYDYWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:42:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: 2.6.26-pre build errors
Date: Sat, 26 Apr 2008 00:42:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <524f69650804251533i6919593dk3a99e2e134e338c9@mail.gmail.com>
In-Reply-To: <524f69650804251533i6919593dk3a99e2e134e338c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804260042.32391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 of April 2008, Steve French wrote:
> From today's current 2.6. kernel git tree - build included compile
> errors in joystick support.  After disabling joystick support, I still
> get at least one link error:
> 
> ERROR: "__locks_copy_lock" [fs/lockd/lockd.ko] undefined!

Please try this:

__locks_copy_lock has to be exported, because it's used in lockd,
which may be built as a module.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/locks.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c
+++ linux-2.6/fs/locks.c
@@ -237,6 +237,8 @@ void __locks_copy_lock(struct file_lock 
 	new->fl_lmops = NULL;
 }
 
+EXPORT_SYMBOL(__locks_copy_lock);
+
 void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
 	locks_release_private(new);

