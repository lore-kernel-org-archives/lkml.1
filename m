Return-Path: <linux-kernel-owner+w=401wt.eu-S1161251AbXBABuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161251AbXBABuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 20:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161252AbXBABug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 20:50:36 -0500
Received: from patroclus.tjworld.net ([84.12.34.246]:50272 "EHLO phwoarrr.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161251AbXBABug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 20:50:36 -0500
Subject: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe
	of partitions
From: TJ <linux@tjworld.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: TJworld
Date: Thu, 01 Feb 2007 01:50:33 +0000
Message-Id: <1170294633.7511.4.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: TJ <linux@tjworld.net>

Applies to: up-to and including 2.6.20-rc7 

Update to previous patch.

Fixed logical error in if() statements for conditional printk(). Replaced bit-wise OR with AND.

Signed-off-by: TJ <linux@tjworld.net>

--- fs/partitions/msdos.tj.c	2007-02-01 00:41:57.000000000 +0000
+++ fs/partitions/msdos.tj.1.c	2007-02-01 01:07:31.000000000 +0000
@@ -459,13 +459,13 @@ int check_sane_values(struct partition *
 		if (insane) { /* insanity found; report it */
 			ret = -1; /* error code */
 			printk("\n"); /* start error report on a fresh line */
-			if (insane | 1)
+			if (insane & 1)
 				printk(" partition %d: start (sector %d) beyond end of disk (sector %d)\n",
 				 slot, START_SECT(p), (unsigned int) bdev->bd_disk->capacity-1);
-			if (insane | 2)
+			if (insane & 2)
 				printk(" partition %d: end (sector %d) beyond end of disk (sector %d)\n",
 				 slot, START_SECT(p)+NR_SECTS(p)-1, (unsigned int) bdev->bd_disk->capacity-1);
-			if (insane | 4)
+			if (insane & 4)
 				printk(" partition %d: insane extended contents\n", slot);
 		}
 	}




