Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYCVXZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYCVXZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYCVXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:25:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:34879 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbYCVXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ACBMzWsRJJ2JWt5CnDFd0B/CrNLa34BdorlcZQKyz0XKn3Ge2tbK8ryF4tUvwhB+BxQvRFpKEebyiT+ulo5gqPGcxJueX9Z8sCC67R7j84GNv0u/r3C4A0XrG4d2+rtr1U7jX7DbKw5WeRywUpak8jYl76PQM3Gnb7pTzUIz2V0=
Date: Sun, 23 Mar 2008 02:23:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nv: fix sparse noise
Message-ID: <20080322232317.GA20093@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly signedness fixes. nv10_sim_state existence in both drivers suggests
that one of them should be removed, but that's for later.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/video/nvidia/nv_hw.c    |    4 ++--
 drivers/video/nvidia/nv_setup.c |    4 ++--
 drivers/video/riva/nv_driver.c  |    2 +-
 drivers/video/riva/riva_hw.c    |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/video/nvidia/nv_hw.c
+++ b/drivers/video/nvidia/nv_hw.c
@@ -129,7 +129,7 @@ typedef struct {
 	int nvclk_khz;
 	char mem_page_miss;
 	char mem_latency;
-	int memory_type;
+	u32 memory_type;
 	int memory_width;
 	char enable_video;
 	char gr_during_vid;
@@ -719,7 +719,7 @@ static void nForceUpdateArbitrationSettings(unsigned VClk,
 	memctrl >>= 16;
 
 	if ((memctrl == 0x1A9) || (memctrl == 0x1AB) || (memctrl == 0x1ED)) {
-		int dimm[3];
+		u32 dimm[3];
 
 		dev = pci_get_bus_and_slot(0, 2);
 		pci_read_config_dword(dev, 0x40, &dimm[0]);
--- a/drivers/video/nvidia/nv_setup.c
+++ b/drivers/video/nvidia/nv_setup.c
@@ -265,12 +265,12 @@ static void nv10GetConfig(struct nvidia_par *par)
 
 	dev = pci_get_bus_and_slot(0, 1);
 	if ((par->Chipset & 0xffff) == 0x01a0) {
-		int amt = 0;
+		u32 amt;
 
 		pci_read_config_dword(dev, 0x7c, &amt);
 		par->RamAmountKBytes = (((amt >> 6) & 31) + 1) * 1024;
 	} else if ((par->Chipset & 0xffff) == 0x01f0) {
-		int amt = 0;
+		u32 amt;
 
 		pci_read_config_dword(dev, 0x84, &amt);
 		par->RamAmountKBytes = (((amt >> 4) & 127) + 1) * 1024;
--- a/drivers/video/riva/nv_driver.c
+++ b/drivers/video/riva/nv_driver.c
@@ -158,7 +158,7 @@ unsigned long riva_get_memlen(struct riva_par *par)
 	unsigned long memlen = 0;
 	unsigned int chipset = par->Chipset;
 	struct pci_dev* dev;
-	int amt;
+	u32 amt;
 
 	switch (chip->Architecture) {
 	case NV_ARCH_03:
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -231,7 +231,7 @@ typedef struct {
   int nvclk_khz;
   char mem_page_miss;
   char mem_latency;
-  int memory_type;
+  u32 memory_type;
   int memory_width;
   char enable_video;
   char gr_during_vid;
@@ -2107,7 +2107,7 @@ static void nv10GetConfig
 )
 {
     struct pci_dev* dev;
-    int amt;
+    u32 amt;
 
 #ifdef __BIG_ENDIAN
     /* turn on big endian register access */

