Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYHGRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYHGRLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYHGRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:11:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56655 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYHGRLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:11:05 -0400
Date: Thu, 7 Aug 2008 20:09:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>, bzolnier@gmail.com
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: [2.6 patch] drivers/ide/pci/: use __devexit_p()
Message-ID: <20080807170932.GC9692@cs181140183.pp.htv.fi>
References: <20080807164539.GA26947@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080807164539.GA26947@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:45:39PM +0100, Russell King wrote:
>...
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -1594,7 +1594,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
>  	return ret;
>  }
>  
> -static void __devexit hpt366_remove(struct pci_dev *dev)
> +static void hpt366_remove(struct pci_dev *dev)
>...

Thanks for your report.

The code is buggy, but:
- that's not the correct fix and
- there are far more such bugs under drivers/ide/pci/

Patch below.

> Russell King

cu
Adrian


<--  snip  -->


This patch adds missing __devexit_p's.

Reported-by: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/pci/aec62xx.c      |    2 +-
 drivers/ide/pci/cy82c693.c     |    2 +-
 drivers/ide/pci/hpt366.c       |    2 +-
 drivers/ide/pci/it821x.c       |    2 +-
 drivers/ide/pci/pdc202xx_new.c |    2 +-
 drivers/ide/pci/scc_pata.c     |    2 +-
 drivers/ide/pci/siimage.c      |    2 +-
 drivers/ide/pci/sis5513.c      |    2 +-
 drivers/ide/pci/tc86c001.c     |    2 +-
 drivers/ide/pci/via82cxxx.c    |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

2c3b97b99c1b2985e74bf60d46b105b8eacc4fba 
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 40644b6..3187215 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -307,7 +307,7 @@ static struct pci_driver driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
-	.remove		= aec62xx_remove,
+	.remove		= __devexit_p(aec62xx_remove),
 };
 
 static int __init aec62xx_ide_init(void)
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index bfae2f8..e6d8ee8 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -447,7 +447,7 @@ static struct pci_driver driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
-	.remove		= cy82c693_remove,
+	.remove		= __devexit_p(cy82c693_remove),
 };
 
 static int __init cy82c693_ide_init(void)
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 748793a..eb107ee 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1620,7 +1620,7 @@ static struct pci_driver driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
-	.remove		= hpt366_remove,
+	.remove		= __devexit_p(hpt366_remove),
 };
 
 static int __init hpt366_ide_init(void)
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index b6dc723..4a1508a 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -686,7 +686,7 @@ static struct pci_driver driver = {
 	.name		= "ITE821x IDE",
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
-	.remove		= it821x_remove,
+	.remove		= __devexit_p(it821x_remove),
 };
 
 static int __init it821x_ide_init(void)
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 0f609b7..d477da6 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -566,7 +566,7 @@ static struct pci_driver driver = {
 	.name		= "Promise_IDE",
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
-	.remove		= pdc202new_remove,
+	.remove		= __devexit_p(pdc202new_remove),
 };
 
 static int __init pdc202new_ide_init(void)
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 6cde48b..44cccd1 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -954,7 +954,7 @@ static struct pci_driver driver = {
 	.name = "SCC IDE",
 	.id_table = scc_pci_tbl,
 	.probe = scc_init_one,
-	.remove = scc_remove,
+	.remove = __devexit_p(scc_remove),
 };
 
 static int scc_ide_init(void)
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 445ce6f..db2b88a 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -832,7 +832,7 @@ static struct pci_driver driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
-	.remove		= siimage_remove,
+	.remove		= __devexit_p(siimage_remove),
 };
 
 static int __init siimage_ide_init(void)
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index e5a4b42..5efe21d 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -610,7 +610,7 @@ static struct pci_driver driver = {
 	.name		= "SIS_IDE",
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
-	.remove		= sis5513_remove,
+	.remove		= __devexit_p(sis5513_remove),
 };
 
 static int __init sis5513_ide_init(void)
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 7fc88c3..927277c 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -249,7 +249,7 @@ static struct pci_driver driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
 	.probe		= tc86c001_init_one,
-	.remove		= tc86c001_remove,
+	.remove		= __devexit_p(tc86c001_remove),
 };
 
 static int __init tc86c001_ide_init(void)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index a6b2cc8..94fb9ab 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -491,7 +491,7 @@ static struct pci_driver driver = {
 	.name 		= "VIA_IDE",
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
-	.remove		= via_remove,
+	.remove		= __devexit_p(via_remove),
 };
 
 static int __init via_ide_init(void)

