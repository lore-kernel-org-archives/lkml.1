Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYBJXqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYBJXqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYBJXpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:45:54 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:37660 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752328AbYBJXpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:45:53 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] Silent compiler warning introduced by commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images)
Date: Mon, 11 Feb 2008 01:44:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: linux-kernel@vger.kernel.org, dedekind@linutronix.de, haver@vnet.ibm.com,
       torvalds@linux-foundation.org
References: <200802100537.47634.caglar@pardus.org.tr> <47AEB829.8060104@gmail.com>
In-Reply-To: <47AEB829.8060104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802110144.07549.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

10 Şub 2008 Paz tarihinde, Jiri Slaby şunları yazmıştı: 
> I think this is not correct. You change the err which caused the failure. You 
> change it even to 0 if it doesn't fail and the whole function will seem like 
> non-failing.

My bad, sorry for not looking carefully. Assuming a refactoring is not desired for just a compiler warning, is following acceptable (this kind of plain messages seems heavily used in vmt.c, so i'm again assuming its OK to use such style)?

commit 801c135ce73d5df1caf3eca35b66a10824ae0707 (UBI: Unsorted Block Images) introduced the warning

drivers/mtd/ubi/vmt.c: In function `ubi_create_volume':
drivers/mtd/ubi/vmt.c:379: warning: statement with no effect


 drivers/mtd/ubi/vmt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index a3ca225..46410f6 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -376,7 +376,8 @@ out_sysfs:
 	get_device(&vol->dev);
 	volume_sysfs_close(vol);
 out_gluebi:
-	ubi_destroy_gluebi(vol);
+	if(ubi_destroy_gluebi(vol))
+		ubi_err("cannot destroy device");
 out_cdev:
 	cdev_del(&vol->cdev);
 out_mapping:


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
