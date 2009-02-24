Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbZBYBNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbZBYBNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZBYBMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:12:25 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46988 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752270AbZBYBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:12:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Content-Disposition:From:Reply-To:Date:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=m2eEpKvxGX76L7ehAh+12pXki5cNw927Mz12FaCOrl7bD17Yx6Nnh+eCgJsAEZOFy+E7ve1Q/Omj/G5wnLSNo1iJnmJ1YuXoU0HgtM8KQ4CCyUzz2iAfTFiEB9fP4RcgUuPQ1jDQtivQ63hx9tac3MvnqaqEwmABvrDOmAxeP+U=  ;
X-YMail-OSG: z2bPnZMVM1lShpSwssCJ6VxsdHEZRTnta4rcm9Tr5hgo2cJWzaFdTGtPkEBjgwm.YnVzwk4Lb4fhu.ZmWcBZQv6Bgi0CRL6y0qvU7SybyFFM2rz0OYualgud4I5lE2ET0Q4UYSvSX6swRt6LXy0S1kDbYd5ZM9IqvjCml5Nm2SlVijX97tvVMzeTLOLdKcnMxg--
X-Yahoo-Newman-Property: ymail-3
To: Linux MTD <linux-mtd@lists.infradead.org>
Subject: [patch/RESEND 2.6.29-rc3] NAND: =?iso-8859-1?q?=A0fix_broken_debug_messages?= (v2)
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
Date: Tue, 24 Feb 2009 15:10:24 -0800
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200902241510.24993.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Fix incorrect debug messages (*write* not read); someone
committed some cut'n'paste bugs.  There might be more,
I only noticed these since I was looking for nand_read
usage and landed in some very wrong functions.

IMO all MTD debugging message framework is goofed, anyway.
It uses "DEBUG" in a way that's incompatible with usage
most everywhere else in the kernel, and which prevents
normal pr_dbg() and dev_dbg() calls from working right.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Fix a goofed string.

 drivers/mtd/nand/nand_base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1948,7 +1948,7 @@ static int nand_do_write_oob(struct mtd_
 	}
 
 	if (unlikely(ops->ooboffs >= len)) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_do_write_oob: "
 			"Attempt to start write outside oob\n");
 		return -EINVAL;
 	}
@@ -1958,7 +1958,7 @@ static int nand_do_write_oob(struct mtd_
 		     ops->ooboffs + ops->ooblen >
 			((mtd->size >> chip->page_shift) -
 			 (to >> chip->page_shift)) * len)) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_do_write_oob: "
 			"Attempt write beyond end of device\n");
 		return -EINVAL;
 	}
@@ -2014,8 +2014,8 @@ static int nand_write_oob(struct mtd_inf
 
 	/* Do not allow writes past end of device */
 	if (ops->datbuf && (to + ops->len) > mtd->size) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
-		      "Attempt read beyond end of device\n");
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_write_oob: "
+		      "Attempt write beyond end of device\n");
 		return -EINVAL;
 	}
 
