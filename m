Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbXEGPKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbXEGPKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934132AbXEGPKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:10:04 -0400
Received: from mail.pxnet.com ([195.227.45.3]:45260 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934084AbXEGPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:10:03 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 11:10:03 EDT
Date: Mon, 7 May 2007 17:03:12 +0200
Message-Id: <200705071503.l47F3C1q015269@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Hansjoerg Lipp <hjlipp@web.de>
Subject: [PATCH] usb_gigaset: don't kmalloc(0)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>

Zero-sized allocations are pointless anyway, and the SLUB allocator
complains about them, so stop doing that.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Hansjoerg Lipp <hjlipp@web.de>

---

--- a/drivers/isdn/gigaset/usb-gigaset.c	2007-05-07 10:08:41.000000000 +0200
+++ b/drivers/isdn/gigaset/usb-gigaset.c	2007-05-07 12:01:48.000000000 +0200
@@ -138,8 +138,6 @@ struct usb_cardstate {
 	char			bchars[6];		/* for request 0x19 */
 };
 
-struct usb_bc_state {};
-
 static inline unsigned tiocm_to_gigaset(unsigned state)
 {
 	return ((state & TIOCM_DTR) ? 1 : 0) | ((state & TIOCM_RTS) ? 2 : 0);
@@ -579,25 +577,21 @@ static int gigaset_brkchars(struct cards
 
 static int gigaset_freebcshw(struct bc_state *bcs)
 {
-	if (!bcs->hw.usb)
-		return 0;
-	//FIXME
-	kfree(bcs->hw.usb);
+	/* unused */
 	return 1;
 }
 
 /* Initialize the b-channel structure */
 static int gigaset_initbcshw(struct bc_state *bcs)
 {
-	bcs->hw.usb = kmalloc(sizeof(struct usb_bc_state), GFP_KERNEL);
-	if (!bcs->hw.usb)
-		return 0;
-
+	/* unused */
+	bcs->hw.usb = NULL;
 	return 1;
 }
 
 static void gigaset_reinitbcshw(struct bc_state *bcs)
 {
+	/* nothing to do for M10x */
 }
 
 static void gigaset_freecshw(struct cardstate *cs)

-- 
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -
