Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbXD1Kcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbXD1Kcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXD1Kcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:32:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39530 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbXD1Kcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:32:52 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 06:32:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, michael@mihu.de
Subject: [PATCH] VIDEO4LINUX-2: Replace MINOR() with a call to iminor().
Message-ID: <Pine.LNX.4.64.0704280628180.571@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace the call to MINOR() with a call to the inline iminor()
routine.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

that's the last of those changes, but it's not clear who the official
maintainer is, so i took a chance and picked a likely looking victim
out of the MAINTAINERS file.  apologies if i picked wrong.


diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 1637097..8976487 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -804,7 +804,7 @@ int ivtv_v4l2_open(struct inode *inode, struct file *filp)
 	struct ivtv_open_id *item;
 	struct ivtv *itv = NULL;
 	struct ivtv_stream *s = NULL;
-	int minor = MINOR(inode->i_rdev);
+	int minor = iminor(inode);

 	/* Find which card this open was on */
 	spin_lock(&ivtv_cards_lock);
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
