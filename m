Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZA2J2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZA2J2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2J23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:28:29 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:44289 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZA2J21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:28:27 -0500
Message-ID: <498176B6.1040404@in.ibm.com>
Date: Thu, 29 Jan 2009 14:58:22 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: [BUILD_FAILURE]  2.6.29-rc3 : drivers/ata/sata_sil.c
References: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901281120460.3123@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050908090809070809000304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050908090809070809000304
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

2.6.29-rc3 with allmodconfig breaks with following message


 CALL    arch/powerpc/kernel/systbl_chk.sh
 CALL    arch/powerpc/kernel/prom_init_check.sh
 LD [M]  drivers/ata/libata.o
 CC [M]  drivers/ata/sata_sil.o
drivers/ata/sata_sil.c: In function sil_broken_system_poweroff:
drivers/ata/sata_sil.c:713: error: implicit declaration of function dmi_first_match
drivers/ata/sata_sil.c:713: warning: initialization makes pointer from integer without a cast
make[2]: *** [drivers/ata/sata_sil.o] Error 1
make[1]: *** [drivers/ata] Error 2
make: *** [drivers] Error 2

Probably needs to include <linux/dmi.h>. The following patch fixes it.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>

---


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------050908090809070809000304
Content-Type: text/x-patch;
 name="fix-ata-build-break.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-ata-build-break.patch"

* Fix ata build break (undefined dmi_first_match symbol)

Signed-off-by : Sachin Sant<sachinp@in.ibm.com>
---

diff -Naurp a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
--- a/drivers/ata/sata_sil.c	2009-01-29 00:19:30.000000000 +0530
+++ b/drivers/ata/sata_sil.c	2009-01-29 17:15:03.000000000 +0530
@@ -44,6 +44,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME	"sata_sil"
 #define DRV_VERSION	"2.4"

--------------050908090809070809000304--
