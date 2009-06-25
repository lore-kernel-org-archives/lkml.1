Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbZFYFTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbZFYFTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758938AbZFYFOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:14:34 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1486 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbZFYFOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:14:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org
Subject: [PATCH 19/19] sound: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:35 -0700
Message-Id: <e27f875baa15d3d3e34c2a005cea9d702e822c57.1245906153.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/oss/kahlua.c          |    2 +-
 sound/pci/atiixp.c          |    8 +++---
 sound/pci/atiixp_modem.c    |    4 +-
 sound/pci/au88x0/au8810.c   |    3 +-
 sound/pci/au88x0/au8820.c   |    3 +-
 sound/pci/au88x0/au8830.c   |    3 +-
 sound/pci/cmipci.c          |   10 ++++----
 sound/pci/cs4281.c          |    2 +-
 sound/pci/cs46xx/cs46xx.c   |    6 ++--
 sound/pci/ens1370.c         |    6 ++--
 sound/pci/es1938.c          |    2 +-
 sound/pci/ice1712/ice1712.c |    2 +-
 sound/pci/ice1712/ice1724.c |    2 +-
 sound/pci/intel8x0.c        |   46 +++++++++++++++++++++---------------------
 sound/pci/intel8x0m.c       |   34 +++++++++++++++---------------
 sound/pci/mixart/mixart.c   |    2 +-
 sound/pci/nm256/nm256.c     |    6 ++--
 sound/pci/rme32.c           |    9 ++-----
 sound/pci/rme96.c           |   12 +++-------
 sound/pci/sonicvibes.c      |    2 +-
 sound/pci/via82xx.c         |    4 +-
 sound/pci/via82xx_modem.c   |    2 +-
 sound/pci/ymfpci/ymfpci.c   |   12 +++++-----
 23 files changed, 86 insertions(+), 96 deletions(-)

diff --git a/sound/oss/kahlua.c b/sound/oss/kahlua.c
index c180598..89466b0 100644
--- a/sound/oss/kahlua.c
+++ b/sound/oss/kahlua.c
@@ -199,7 +199,7 @@ MODULE_LICENSE("GPL");
  */
 
 static struct pci_device_id id_tbl[] = {
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_AUDIO, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_AUDIO), 0 },
 	{ }
 };
 
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 71515dd..d6752df 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -287,10 +287,10 @@ struct atiixp {
 /*
  */
 static struct pci_device_id snd_atiixp_ids[] = {
-	{ 0x1002, 0x4341, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB200 */
-	{ 0x1002, 0x4361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB300 */
-	{ 0x1002, 0x4370, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB400 */
-	{ 0x1002, 0x4382, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB600 */
+	{ PCI_VDEVICE(ATI, 0x4341), 0 }, /* SB200 */
+	{ PCI_VDEVICE(ATI, 0x4361), 0 }, /* SB300 */
+	{ PCI_VDEVICE(ATI, 0x4370), 0 }, /* SB400 */
+	{ PCI_VDEVICE(ATI, 0x4382), 0 }, /* SB600 */
 	{ 0, }
 };
 
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index c3136cc..e7e147b 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -262,8 +262,8 @@ struct atiixp_modem {
 /*
  */
 static struct pci_device_id snd_atiixp_ids[] = {
-	{ 0x1002, 0x434d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB200 */
-	{ 0x1002, 0x4378, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, /* SB400 */
+	{ PCI_VDEVICE(ATI, 0x434d), 0 }, /* SB200 */
+	{ PCI_VDEVICE(ATI, 0x4378), 0 }, /* SB400 */
 	{ 0, }
 };
 
diff --git a/sound/pci/au88x0/au8810.c b/sound/pci/au88x0/au8810.c
index fce22c7..c0e8c6b 100644
--- a/sound/pci/au88x0/au8810.c
+++ b/sound/pci/au88x0/au8810.c
@@ -1,8 +1,7 @@
 #include "au8810.h"
 #include "au88x0.h"
 static struct pci_device_id snd_vortex_ids[] = {
-	{PCI_VENDOR_ID_AUREAL, PCI_DEVICE_ID_AUREAL_ADVANTAGE,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1,},
+	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_ADVANTAGE), 1,},
 	{0,}
 };
 
diff --git a/sound/pci/au88x0/au8820.c b/sound/pci/au88x0/au8820.c
index d1fbcce..a652733 100644
--- a/sound/pci/au88x0/au8820.c
+++ b/sound/pci/au88x0/au8820.c
@@ -1,8 +1,7 @@
 #include "au8820.h"
 #include "au88x0.h"
 static struct pci_device_id snd_vortex_ids[] = {
-	{PCI_VENDOR_ID_AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_1,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_1), 0,},
 	{0,}
 };
 
diff --git a/sound/pci/au88x0/au8830.c b/sound/pci/au88x0/au8830.c
index d4f2717..6c702ad 100644
--- a/sound/pci/au88x0/au8830.c
+++ b/sound/pci/au88x0/au8830.c
@@ -1,8 +1,7 @@
 #include "au8830.h"
 #include "au88x0.h"
 static struct pci_device_id snd_vortex_ids[] = {
-	{PCI_VENDOR_ID_AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_2,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_2), 0,},
 	{0,}
 };
 
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 449fe02..ddcd4a9 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2797,11 +2797,11 @@ static inline void snd_cmipci_proc_init(struct cmipci *cm) {}
 
 
 static struct pci_device_id snd_cmipci_ids[] = {
-	{PCI_VENDOR_ID_CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8738, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8738B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_AL, PCI_DEVICE_ID_CMEDIA_CM8738, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338A), 0},
+	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338B), 0},
+	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8738), 0},
+	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8738B), 0},
+	{PCI_VDEVICE(AL, PCI_DEVICE_ID_CMEDIA_CM8738), 0},
 	{0,},
 };
 
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index f6286f8..e2e0359 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -495,7 +495,7 @@ struct cs4281 {
 static irqreturn_t snd_cs4281_interrupt(int irq, void *dev_id);
 
 static struct pci_device_id snd_cs4281_ids[] = {
-	{ 0x1013, 0x6005, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* CS4281 */
+	{ PCI_VDEVICE(CIRRUS, 0x6005), 0, },	/* CS4281 */
 	{ 0, }
 };
 
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index c9b3e3d..004a59a 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -65,9 +65,9 @@ module_param_array(mmap_valid, bool, NULL, 0444);
 MODULE_PARM_DESC(mmap_valid, "Support OSS mmap.");
 
 static struct pci_device_id snd_cs46xx_ids[] = {
-        { 0x1013, 0x6001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* CS4280 */
-        { 0x1013, 0x6003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* CS4612 */
-        { 0x1013, 0x6004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* CS4615 */
+        { PCI_VDEVICE(CIRRUS, 0x6001), 0, },   /* CS4280 */
+        { PCI_VDEVICE(CIRRUS, 0x6003), 0, },   /* CS4612 */
+        { PCI_VDEVICE(CIRRUS, 0x6004), 0, },   /* CS4615 */
 	{ 0, }
 };
 
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 18f4d1e..d589bbc 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -445,11 +445,11 @@ static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id);
 
 static struct pci_device_id snd_audiopci_ids[] = {
 #ifdef CHIP1370
-	{ 0x1274, 0x5000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1370 */
+	{ PCI_VDEVICE(ENSONIQ, 0x5000), 0, },	/* ES1370 */
 #endif
 #ifdef CHIP1371
-	{ 0x1274, 0x1371, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1371 */
-	{ 0x1274, 0x5880, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* ES1373 - CT5880 */
+	{ PCI_VDEVICE(ENSONIQ, 0x1371), 0, },	/* ES1371 */
+	{ PCI_VDEVICE(ENSONIQ, 0x5880), 0, },	/* ES1373 - CT5880 */
 	{ 0x1102, 0x8938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* Ectiva EV1938 */
 #endif
 	{ 0, }
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index fbd2ac0..b47232c 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -244,7 +244,7 @@ struct es1938 {
 static irqreturn_t snd_es1938_interrupt(int irq, void *dev_id);
 
 static struct pci_device_id snd_es1938_ids[] = {
-        { 0x125d, 0x1969, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* Solo-1 */
+        { PCI_VDEVICE(ESS, 0x1969), 0, },   /* Solo-1 */
 	{ 0, }
 };
 
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 0d0cdbd..cecf1ff 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -107,7 +107,7 @@ MODULE_PARM_DESC(dxr_enable, "Enable DXR support for Terratec DMX6FIRE.");
 
 
 static const struct pci_device_id snd_ice1712_ids[] = {
-	{ PCI_VENDOR_ID_ICE, PCI_DEVICE_ID_ICE_1712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },   /* ICE1712 */
+	{ PCI_VDEVICE(ICE, PCI_DEVICE_ID_ICE_1712), 0 },   /* ICE1712 */
 	{ 0, }
 };
 
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 36ade77..cc84a83 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -93,7 +93,7 @@ MODULE_PARM_DESC(model, "Use the given board model.");
 
 /* Both VT1720 and VT1724 have the same PCI IDs */
 static const struct pci_device_id snd_vt1724_ids[] = {
-	{ PCI_VENDOR_ID_ICE, PCI_DEVICE_ID_VT1724, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(ICE, PCI_DEVICE_ID_VT1724), 0 },
 	{ 0, }
 };
 
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 8aa5687..171ada5 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -421,29 +421,29 @@ struct intel8x0 {
 };
 
 static struct pci_device_id snd_intel8x0_ids[] = {
-	{ 0x8086, 0x2415, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82801AA */
-	{ 0x8086, 0x2425, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82901AB */
-	{ 0x8086, 0x2445, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82801BA */
-	{ 0x8086, 0x2485, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* ICH3 */
-	{ 0x8086, 0x24c5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ICH4 */
-	{ 0x8086, 0x24d5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ICH5 */
-	{ 0x8086, 0x25a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ESB */
-	{ 0x8086, 0x266e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ICH6 */
-	{ 0x8086, 0x27de, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ICH7 */
-	{ 0x8086, 0x2698, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL_ICH4 }, /* ESB2 */
-	{ 0x8086, 0x7195, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 440MX */
-	{ 0x1039, 0x7012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_SIS },	/* SI7012 */
-	{ 0x10de, 0x01b1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* NFORCE */
-	{ 0x10de, 0x003a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* MCP04 */
-	{ 0x10de, 0x006a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* NFORCE2 */
-	{ 0x10de, 0x0059, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* CK804 */
-	{ 0x10de, 0x008a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* CK8 */
-	{ 0x10de, 0x00da, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* NFORCE3 */
-	{ 0x10de, 0x00ea, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* CK8S */
-	{ 0x10de, 0x026b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE },	/* MCP51 */
-	{ 0x1022, 0x746d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* AMD8111 */
-	{ 0x1022, 0x7445, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* AMD768 */
-	{ 0x10b9, 0x5455, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_ALI },   /* Ali5455 */
+	{ PCI_VDEVICE(INTEL, 0x2415), DEVICE_INTEL },	/* 82801AA */
+	{ PCI_VDEVICE(INTEL, 0x2425), DEVICE_INTEL },	/* 82901AB */
+	{ PCI_VDEVICE(INTEL, 0x2445), DEVICE_INTEL },	/* 82801BA */
+	{ PCI_VDEVICE(INTEL, 0x2485), DEVICE_INTEL },	/* ICH3 */
+	{ PCI_VDEVICE(INTEL, 0x24c5), DEVICE_INTEL_ICH4 }, /* ICH4 */
+	{ PCI_VDEVICE(INTEL, 0x24d5), DEVICE_INTEL_ICH4 }, /* ICH5 */
+	{ PCI_VDEVICE(INTEL, 0x25a6), DEVICE_INTEL_ICH4 }, /* ESB */
+	{ PCI_VDEVICE(INTEL, 0x266e), DEVICE_INTEL_ICH4 }, /* ICH6 */
+	{ PCI_VDEVICE(INTEL, 0x27de), DEVICE_INTEL_ICH4 }, /* ICH7 */
+	{ PCI_VDEVICE(INTEL, 0x2698), DEVICE_INTEL_ICH4 }, /* ESB2 */
+	{ PCI_VDEVICE(INTEL, 0x7195), DEVICE_INTEL },	/* 440MX */
+	{ PCI_VDEVICE(SI, 0x7012), DEVICE_SIS },	/* SI7012 */
+	{ PCI_VDEVICE(NVIDIA, 0x01b1), DEVICE_NFORCE },	/* NFORCE */
+	{ PCI_VDEVICE(NVIDIA, 0x003a), DEVICE_NFORCE },	/* MCP04 */
+	{ PCI_VDEVICE(NVIDIA, 0x006a), DEVICE_NFORCE },	/* NFORCE2 */
+	{ PCI_VDEVICE(NVIDIA, 0x0059), DEVICE_NFORCE },	/* CK804 */
+	{ PCI_VDEVICE(NVIDIA, 0x008a), DEVICE_NFORCE },	/* CK8 */
+	{ PCI_VDEVICE(NVIDIA, 0x00da), DEVICE_NFORCE },	/* NFORCE3 */
+	{ PCI_VDEVICE(NVIDIA, 0x00ea), DEVICE_NFORCE },	/* CK8S */
+	{ PCI_VDEVICE(NVIDIA, 0x026b), DEVICE_NFORCE },	/* MCP51 */
+	{ PCI_VDEVICE(AMD, 0x746d), DEVICE_INTEL },	/* AMD8111 */
+	{ PCI_VDEVICE(AMD, 0x7445), DEVICE_INTEL },	/* AMD768 */
+	{ PCI_VDEVICE(AL, 0x5455), DEVICE_ALI },   /* Ali5455 */
 	{ 0, }
 };
 
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 6ec0fc5..9e7d12e 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -220,24 +220,24 @@ struct intel8x0m {
 };
 
 static struct pci_device_id snd_intel8x0m_ids[] = {
-	{ 0x8086, 0x2416, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82801AA */
-	{ 0x8086, 0x2426, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82901AB */
-	{ 0x8086, 0x2446, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 82801BA */
-	{ 0x8086, 0x2486, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* ICH3 */
-	{ 0x8086, 0x24c6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL }, /* ICH4 */
-	{ 0x8086, 0x24d6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL }, /* ICH5 */
-	{ 0x8086, 0x266d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* ICH6 */
-	{ 0x8086, 0x27dd, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* ICH7 */
-	{ 0x8086, 0x7196, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* 440MX */
-	{ 0x1022, 0x7446, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* AMD768 */
-	{ 0x1039, 0x7013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_SIS },	/* SI7013 */
-	{ 0x10de, 0x01c1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE }, /* NFORCE */
-	{ 0x10de, 0x0069, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE }, /* NFORCE2 */
-	{ 0x10de, 0x0089, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE }, /* NFORCE2s */
-	{ 0x10de, 0x00d9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_NFORCE }, /* NFORCE3 */
+	{ PCI_VDEVICE(INTEL, 0x2416), DEVICE_INTEL },	/* 82801AA */
+	{ PCI_VDEVICE(INTEL, 0x2426), DEVICE_INTEL },	/* 82901AB */
+	{ PCI_VDEVICE(INTEL, 0x2446), DEVICE_INTEL },	/* 82801BA */
+	{ PCI_VDEVICE(INTEL, 0x2486), DEVICE_INTEL },	/* ICH3 */
+	{ PCI_VDEVICE(INTEL, 0x24c6), DEVICE_INTEL }, /* ICH4 */
+	{ PCI_VDEVICE(INTEL, 0x24d6), DEVICE_INTEL }, /* ICH5 */
+	{ PCI_VDEVICE(INTEL, 0x266d), DEVICE_INTEL },	/* ICH6 */
+	{ PCI_VDEVICE(INTEL, 0x27dd), DEVICE_INTEL },	/* ICH7 */
+	{ PCI_VDEVICE(INTEL, 0x7196), DEVICE_INTEL },	/* 440MX */
+	{ PCI_VDEVICE(AMD, 0x7446), DEVICE_INTEL },	/* AMD768 */
+	{ PCI_VDEVICE(SI, 0x7013), DEVICE_SIS },	/* SI7013 */
+	{ PCI_VDEVICE(NVIDIA, 0x01c1), DEVICE_NFORCE }, /* NFORCE */
+	{ PCI_VDEVICE(NVIDIA, 0x0069), DEVICE_NFORCE }, /* NFORCE2 */
+	{ PCI_VDEVICE(NVIDIA, 0x0089), DEVICE_NFORCE }, /* NFORCE2s */
+	{ PCI_VDEVICE(NVIDIA, 0x00d9), DEVICE_NFORCE }, /* NFORCE3 */
 #if 0
-	{ 0x1022, 0x746d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_INTEL },	/* AMD8111 */
-	{ 0x10b9, 0x5455, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_ALI },   /* Ali5455 */
+	{ PCI_VDEVICE(AMD, 0x746d), DEVICE_INTEL },	/* AMD8111 */
+	{ PCI_VDEVICE(AL, 0x5455), DEVICE_ALI },   /* Ali5455 */
 #endif
 	{ 0, }
 };
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 82bc5b9..a83d196 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(enable, "Enable Digigram " CARD_NAME " soundcard.");
  */
 
 static struct pci_device_id snd_mixart_ids[] = {
-	{ 0x1057, 0x0003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* MC8240 */
+	{ PCI_VDEVICE(MOTOROLA, 0x0003), 0, }, /* MC8240 */
 	{ 0, }
 };
 
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 522a040..97a0731 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -263,9 +263,9 @@ struct nm256 {
  * PCI ids
  */
 static struct pci_device_id snd_nm256_ids[] = {
-	{PCI_VENDOR_ID_NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256AV_AUDIO, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256ZX_AUDIO, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256XL_PLUS_AUDIO, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256AV_AUDIO), 0},
+	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256ZX_AUDIO), 0},
+	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256XL_PLUS_AUDIO), 0},
 	{0,},
 };
 
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index d7b966e..f977dba 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -227,12 +227,9 @@ struct rme32 {
 };
 
 static struct pci_device_id snd_rme32_ids[] = {
-	{PCI_VENDOR_ID_XILINX_RME, PCI_DEVICE_ID_RME_DIGI32,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
-	{PCI_VENDOR_ID_XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_8,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
-	{PCI_VENDOR_ID_XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_PRO,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32), 0,},
+	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_8), 0,},
+	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_PRO), 0,},
 	{0,}
 };
 
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 55fb1c1..c01296c 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -232,14 +232,10 @@ struct rme96 {
 };
 
 static struct pci_device_id snd_rme96_ids[] = {
-	{ PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_RME_DIGI96,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
-	{ PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_RME_DIGI96_8,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
-	{ PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_RME_DIGI96_8_PRO,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
-	{ PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_RME_DIGI96_8_PAD_OR_PST,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, 
+	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96), 0, },
+	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96_8), 0, },
+	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96_8_PRO), 0, },
+	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96_8_PAD_OR_PST), 0, }, 
 	{ 0, }
 };
 
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 7dc60ad..1f6406c 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -243,7 +243,7 @@ struct sonicvibes {
 };
 
 static struct pci_device_id snd_sonic_ids[] = {
-	{ 0x5333, 0xca00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
+	{ PCI_VDEVICE(S3, 0xca00), 0, },
         { 0, }
 };
 
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 949fcaf..acfa476 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -402,9 +402,9 @@ struct via82xx {
 
 static struct pci_device_id snd_via82xx_ids[] = {
 	/* 0x1106, 0x3058 */
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686_5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPE_CARD_VIA686, },	/* 686A */
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C686_5), TYPE_CARD_VIA686, },	/* 686A */
 	/* 0x1106, 0x3059 */
-	{ PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8233_5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPE_CARD_VIA8233, },	/* VT8233 */
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_8233_5), TYPE_CARD_VIA8233, },	/* VT8233 */
 	{ 0, }
 };
 
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 0d54e35..47eb615 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -261,7 +261,7 @@ struct via82xx_modem {
 };
 
 static struct pci_device_id snd_via82xx_modem_ids[] = {
-	{ 0x1106, 0x3068, PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPE_CARD_VIA82XX_MODEM, },
+	{ PCI_VDEVICE(VIA, 0x3068), TYPE_CARD_VIA82XX_MODEM, },
 	{ 0, }
 };
 
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 4af6666..822b60c 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -67,12 +67,12 @@ module_param_array(rear_switch, bool, NULL, 0444);
 MODULE_PARM_DESC(rear_switch, "Enable shared rear/line-in switch");
 
 static struct pci_device_id snd_ymfpci_ids[] = {
-        { 0x1073, 0x0004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF724 */
-        { 0x1073, 0x000d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF724F */
-        { 0x1073, 0x000a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF740 */
-        { 0x1073, 0x000c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF740C */
-        { 0x1073, 0x0010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF744 */
-        { 0x1073, 0x0012, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* YMF754 */
+        { PCI_VDEVICE(YAMAHA, 0x0004), 0, },   /* YMF724 */
+        { PCI_VDEVICE(YAMAHA, 0x000d), 0, },   /* YMF724F */
+        { PCI_VDEVICE(YAMAHA, 0x000a), 0, },   /* YMF740 */
+        { PCI_VDEVICE(YAMAHA, 0x000c), 0, },   /* YMF740C */
+        { PCI_VDEVICE(YAMAHA, 0x0010), 0, },   /* YMF744 */
+        { PCI_VDEVICE(YAMAHA, 0x0012), 0, },   /* YMF754 */
 	{ 0, }
 };
 
-- 
1.6.3.1.10.g659a0.dirty

