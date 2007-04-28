Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXD1KYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXD1KYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXD1KYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:24:37 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39291 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbXD1KYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:24:36 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 06:23:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
Message-ID: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
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


Replace the MAJOR() macro invocation with a call to the inline
imajor() routine.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6b5b642..08da15b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -710,7 +710,7 @@ static inline int is_loop_device(struct file *file)
 {
 	struct inode *i = file->f_mapping->host;

-	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
+	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
 }

 static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
