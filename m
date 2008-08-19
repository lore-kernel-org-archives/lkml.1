Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYHSNtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYHSNtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbYHSNrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:49 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53290 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756190AbYHSNrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:48 -0400
Date: Tue, 19 Aug 2008 15:47:46 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] identify_ramdisk_image(): correct typo about return value
 in comment
Message-ID: <Pine.LNX.4.64.0808191546060.19016@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1936101027-1219153666=:19016"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1936101027-1219153666=:19016
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

identify_ramdisk_image() returns 0 (not -1) if a gzipped ramdisk is found:

	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
		printk(KERN_NOTICE
		       "RAMDISK: Compressed image found at block %d\n",
		       start_block);
		nblocks = 0;
		^^^^^^^^^^^
		goto done;
	}

	...

done:
	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
	kfree(buf);
	return nblocks;
	^^^^^^^^^^^^^^

Hence correct the typo in the comment, which has existed since the addition of
compressed ramdisk support in 1.3.48.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index fedef93..a7c748f 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -71,7 +71,7 @@ identify_ramdisk_image(int fd, int start_block)
 	sys_read(fd, buf, size);
 
 	/*
-	 * If it matches the gzip magic numbers, return -1
+	 * If it matches the gzip magic numbers, return 0
 	 */
 	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
 		printk(KERN_NOTICE

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1936101027-1219153666=:19016--
