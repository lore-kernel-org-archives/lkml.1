Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZFYFR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZFYFR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZFYFOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:14:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1464 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661AbZFYFOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:14:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] drivers/parport: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:29 -0700
Message-Id: <74f87888515681d211817117bb5e1ca00c85b44a.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parport/parport_pc.c     |   98 +++++++++++++-------------------------
 drivers/parport/parport_serial.c |   93 ++++++++++++------------------------
 2 files changed, 65 insertions(+), 126 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 1032d5f..b62796d 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2993,28 +2993,19 @@ static struct parport_pc_pci {
 
 static const struct pci_device_id parport_pc_pci_tbl[] = {
 	/* Super-IO onboard chips */
-	{ 0x1106, 0x0686, PCI_ANY_ID, PCI_ANY_ID, 0, 0, sio_via_686a },
-	{ 0x1106, 0x8231, PCI_ANY_ID, PCI_ANY_ID, 0, 0, sio_via_8231 },
-	{ PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8872,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, sio_ite_8872 },
+	{ PCI_VDEVICE(VIA, 0x0686), sio_via_686a },
+	{ PCI_VDEVICE(VIA, 0x8231), sio_via_8231 },
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8872), sio_ite_8872 },
 
 	/* PCI cards */
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1P_10x,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2P_10x,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1P_20x,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2P_20x,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2p_20x },
-	{ PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_PARALLEL,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, lava_parallel },
-	{ PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_DUAL_PAR_A,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, lava_parallel_dual_a },
-	{ PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_DUAL_PAR_B,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, lava_parallel_dual_b },
-	{ PCI_VENDOR_ID_LAVA, PCI_DEVICE_ID_LAVA_BOCA_IOPPAR,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, boca_ioppar },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1P_10x), siig_1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2P_10x), siig_2p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1P_20x), siig_1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2P_20x), siig_2p_20x },
+	{ PCI_VDEVICE(LAVA, PCI_DEVICE_ID_LAVA_PARALLEL), lava_parallel },
+	{ PCI_VDEVICE(LAVA, PCI_DEVICE_ID_LAVA_DUAL_PAR_A), lava_parallel_dual_a },
+	{ PCI_VDEVICE(LAVA, PCI_DEVICE_ID_LAVA_DUAL_PAR_B), lava_parallel_dual_b },
+	{ PCI_VDEVICE(LAVA, PCI_DEVICE_ID_LAVA_BOCA_IOPPAR), boca_ioppar },
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 	  PCI_SUBVENDOR_ID_EXSYS, PCI_SUBDEVICE_ID_EXSYS_4014, 0, 0, plx_9050 },
 	/* PCI_VENDOR_ID_TIMEDIA/SUNIX has many differing cards ...*/
@@ -3041,57 +3032,36 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
 	{ 0x1409, 0x7268, 0x1409, 0x0103, 0, 0, timedia_4008a },
 	{ 0x1409, 0x7268, 0x1409, 0x0104, 0, 0, timedia_4018 },
 	{ 0x1409, 0x7268, 0x1409, 0x9018, 0, 0, timedia_9018a },
-	{ PCI_VENDOR_ID_SYBA, PCI_DEVICE_ID_SYBA_2P_EPP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_2p_epp },
-	{ PCI_VENDOR_ID_SYBA, PCI_DEVICE_ID_SYBA_1P_ECP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_1p_ecp },
-	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_010L,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_010l },
+	{ PCI_VDEVICE(SYBA, PCI_DEVICE_ID_SYBA_2P_EPP), syba_2p_epp },
+	{ PCI_VDEVICE(SYBA, PCI_DEVICE_ID_SYBA_1P_ECP), syba_1p_ecp },
+	{ PCI_VDEVICE(TITAN, PCI_DEVICE_ID_TITAN_010L), titan_010l },
 	{ 0x9710, 0x9805, 0x1000, 0x0010, 0, 0, titan_1284p1 },
 	{ 0x9710, 0x9815, 0x1000, 0x0020, 0, 0, titan_1284p2 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
 	/* AFAVLAB_TK9902 */
-	{ 0x14db, 0x2120, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1p},
-	{ 0x14db, 0x2121, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_2p},
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952PP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_952 },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954PP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_954 },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_12PCI840,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_840 },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840_G,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0_G,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_G,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_U,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_GU,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_pcie_pport },
-	{ PCI_VENDOR_ID_AKS, PCI_DEVICE_ID_AKS_ALADDINCARD,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, aks_0100 },
+	{ PCI_VDEVICE(AFAVLAB, 0x2120), avlab_1p},
+	{ PCI_VDEVICE(AFAVLAB, 0x2121), avlab_2p},
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952PP), oxsemi_952 },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954PP), oxsemi_954 },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_12PCI840), oxsemi_840 },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe840_G), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_0_G), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_G), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_U), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(OXSEMI, PCI_DEVICE_ID_OXSEMI_PCIe952_1_GU), oxsemi_pcie_pport },
+	{ PCI_VDEVICE(AKS, PCI_DEVICE_ID_AKS_ALADDINCARD), aks_0100 },
 	{ 0x14f2, 0x0121, PCI_ANY_ID, PCI_ANY_ID, 0, 0, mobility_pp },
 	/* NetMos communication controllers */
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9705,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9705 },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9715,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9715 },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9755,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9755 },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9805,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9705), netmos_9705 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9715), netmos_9715 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9755), netmos_9755 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9805), netmos_9805 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9815), netmos_9815 },
 	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
-	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
+	{ PCI_VDEVICE(QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100), quatech_sppxp100 },
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, parport_pc_pci_tbl);
diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index c3bb84a..06d42ad 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -108,73 +108,42 @@ static struct parport_pc_pci cards[] __devinitdata = {
 
 static struct pci_device_id parport_serial_pci_tbl[] = {
 	/* PCI cards */
-	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_110L,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_110l },
-	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_210L,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_210l },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9735,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9745,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9845,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9xx5_combo },
+	{ PCI_VDEVICE(TITAN, PCI_DEVICE_ID_TITAN_110L), titan_110l },
+	{ PCI_VDEVICE(TITAN, PCI_DEVICE_ID_TITAN_210L), titan_210l },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9735), netmos_9xx5_combo },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9745), netmos_9xx5_combo },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9835), netmos_9xx5_combo },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9845), netmos_9xx5_combo },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
 	  0x1000, 0x0020, 0, 0, netmos_9855_2p },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
 	  0x1000, 0x0022, 0, 0, netmos_9855_2p },
-	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9855,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9855 },
+	{ PCI_VDEVICE(NETMOS, PCI_DEVICE_ID_NETMOS_9855), netmos_9855 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2110,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s1p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2111,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s1p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2112,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s1p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2140,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s2p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2141,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s2p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2142,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1s2p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2160,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_2s1p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2161,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_2s1p },
-	{ PCI_VENDOR_ID_AFAVLAB, 0x2162,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_2s1p },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_550,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_650,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_850,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_550,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_650,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_850,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_10x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_550,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2p1s_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_650,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2p1s_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_850,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2p1s_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_550,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_650,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1s1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_850,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_1s1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_550,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_650,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
-	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_850,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
+	{ PCI_VDEVICE(AFAVLAB, 0x2110), avlab_1s1p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2111), avlab_1s1p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2112), avlab_1s1p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2140), avlab_1s2p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2141), avlab_1s2p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2142), avlab_1s2p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2160), avlab_2s1p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2161), avlab_2s1p },
+	{ PCI_VDEVICE(AFAVLAB, 0x2162), avlab_2s1p },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_550), siig_1s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_650), siig_1s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_10x_850), siig_1s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_550), siig_2s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_650), siig_2s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_10x_850), siig_2s1p_10x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_550), siig_2p1s_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_650), siig_2p1s_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2P1S_20x_850), siig_2p1s_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_550), siig_2s1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_650), siig_1s1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_1S1P_20x_850), siig_1s1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_550), siig_2s1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_650), siig_2s1p_20x },
+	{ PCI_VDEVICE(SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_850), siig_2s1p_20x },
 
 	{ 0, } /* terminate list */
 };
-- 
1.6.3.1.10.g659a0.dirty

