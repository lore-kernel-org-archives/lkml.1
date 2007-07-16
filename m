Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXGPS5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXGPS5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXGPS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:57:30 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49000 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbXGPS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:57:29 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: axboe@suse.de
Subject: [PATCH] error: too few arguments to function `scsi_cmd_ioctl'
Date: Mon, 16 Jul 2007 21:56:51 +0300
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707162156.53424.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch corrects following compile error introduced by commit 
e245befce7af0a1e1347079ed62695b059594bd4

caglar@zangetsu linux-2.6 $ make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      drivers/block/built-in.o
  CC [M]  drivers/block/cciss.o
drivers/block/cciss.c: In function `cciss_ioctl':
drivers/block/cciss.c:1173: warning: passing arg 2 of `scsi_cmd_ioctl' from 
incompatible pointer type
drivers/block/cciss.c:1173: warning: passing arg 3 of `scsi_cmd_ioctl' makes 
pointer from integer without a cast
drivers/block/cciss.c:1173: warning: passing arg 4 of `scsi_cmd_ioctl' makes 
integer from pointer without a cast
drivers/block/cciss.c:1173: error: too few arguments to function 
`scsi_cmd_ioctl'
...
make[2]: *** [drivers/block/cciss.o] Hata 1
make[1]: *** [drivers/block] Hata 2
make: *** [drivers] Hata 2

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0fcad43..a2d6612 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1170,7 +1170,7 @@ static int cciss_ioctl(struct inode *inode, struct file 
*filep,
 	case SG_EMULATED_HOST:
 	case SG_IO:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return scsi_cmd_ioctl(filep, disk, cmd, argp);
+		return scsi_cmd_ioctl(filep, disk->queue, disk, cmd, argp);
 
 	/* scsi_cmd_ioctl would normally handle these, below, but */
 	/* they aren't a good fit for cciss, as CD-ROMs are */


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
