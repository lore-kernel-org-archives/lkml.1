Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbYBTU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbYBTU0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYBTU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:26:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44396 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888AbYBTU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:26:36 -0500
Date: Wed, 20 Feb 2008 20:16:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isicom: istallion prepare for lock_kernel pushdown
Message-ID: <20080220201657.09d184d3@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an ancient driver so just wrap it in lock_kernel internally and
be done.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/istallion.c linux-2.6.25-rc2-mm1/drivers/char/istallion.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/istallion.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/istallion.c	2008-02-20 11:45:50.000000000 +0000
@@ -4433,6 +4433,8 @@
 	done = 0;
 	rc = 0;
 
+	lock_kernel();
+	
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stli_getportstats(NULL, argp);
@@ -4455,7 +4457,8 @@
 		done++;
 		break;
 	}
-
+	unlock_kernel();
+	
 	if (done)
 		return rc;
 
@@ -4472,6 +4475,8 @@
 	if (brdp->state == 0)
 		return -ENODEV;
 
+	lock_kernel();
+	
 	switch (cmd) {
 	case STL_BINTR:
 		EBRDINTR(brdp);
@@ -4494,6 +4499,7 @@
 		rc = -ENOIOCTLCMD;
 		break;
 	}
+	unlock_kernel();
 	return rc;
 }
 
