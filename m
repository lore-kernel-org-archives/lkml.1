Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0BCTBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:01:04 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:56846 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab0BCTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:00:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/3] of: add 'of_' prefix to machine_is_compatible()
To: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       benh@kernel.crashing.org
Date: Wed, 03 Feb 2010 12:00:56 -0700
Message-ID: <20100203190052.26862.3219.stgit@angua>
In-Reply-To: <20100203185753.26862.6818.stgit@angua>
References: <20100203185753.26862.6818.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

machine is compatible is an OF-specific call.  It should have
the of_ prefix to protect the global namespace.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/powerpc/kernel/pci_64.c                  |    2 +
 arch/powerpc/platforms/85xx/xes_mpc85xx.c     |    4 +-
 arch/powerpc/platforms/cell/cbe_powerbutton.c |    2 +
 arch/powerpc/platforms/cell/ras.c             |    2 +
 arch/powerpc/platforms/pasemi/cpufreq.c       |    4 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c  |   14 ++++----
 arch/powerpc/platforms/powermac/cpufreq_64.c  |   14 ++++----
 arch/powerpc/platforms/powermac/feature.c     |    2 +
 arch/powerpc/platforms/powermac/smp.c         |   12 +++----
 arch/powerpc/platforms/powermac/time.c        |    8 ++---
 arch/powerpc/platforms/powermac/udbg_scc.c    |    6 ++-
 arch/powerpc/sysdev/grackle.c                 |    4 +-
 drivers/char/hvc_beat.c                       |    2 +
 drivers/gpu/drm/radeon/radeon_combios.c       |   44 +++++++++++++------------
 drivers/macintosh/adb.c                       |    4 +-
 drivers/macintosh/therm_pm72.c                |    8 ++---
 drivers/macintosh/therm_windtunnel.c          |    2 +
 drivers/macintosh/via-pmu-backlight.c         |    8 ++---
 drivers/macintosh/via-pmu.c                   |    8 ++---
 drivers/macintosh/windfarm_core.c             |    6 ++-
 drivers/macintosh/windfarm_cpufreq_clamp.c    |    6 ++-
 drivers/macintosh/windfarm_lm75_sensor.c      |    6 ++-
 drivers/macintosh/windfarm_max6690_sensor.c   |    6 ++-
 drivers/macintosh/windfarm_pm112.c            |    2 +
 drivers/macintosh/windfarm_pm121.c            |    2 +
 drivers/macintosh/windfarm_pm81.c             |    4 +-
 drivers/macintosh/windfarm_pm91.c             |    2 +
 drivers/macintosh/windfarm_smu_sensors.c      |    6 ++-
 drivers/net/mace.c                            |    2 +
 drivers/of/base.c                             |    6 ++-
 drivers/serial/pmac_zilog.c                   |    6 ++-
 drivers/video/aty/aty128fb.c                  |   14 ++++----
 drivers/video/aty/atyfb_base.c                |    8 ++---
 drivers/video/aty/radeon_backlight.c          |    6 ++-
 include/linux/of_fdt.h                        |    2 +
 sound/ppc/awacs.c                             |   24 +++++++-------
 sound/ppc/burgundy.c                          |    4 +-
 sound/ppc/pmac.c                              |   18 +++++-----
 sound/soc/fsl/efika-audio-fabric.c            |    2 +
 sound/soc/fsl/pcm030-audio-fabric.c           |    2 +
 40 files changed, 142 insertions(+), 142 deletions(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index ccf56ac..d43fc65 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -224,7 +224,7 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 	 * G5 machines... So when something asks for bus 0 io base
 	 * (bus 0 is HT root), we return the AGP one instead.
 	 */
-	if (in_bus == 0 && machine_is_compatible("MacRISC4")) {
+	if (in_bus == 0 && of_machine_is_compatible("MacRISC4")) {
 		struct device_node *agp;
 
 		agp = of_find_compatible_node(NULL, NULL, "u3-agp");
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 1b42605..0125604 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -80,8 +80,8 @@ static void xes_mpc85xx_configure_l2(void __iomem *l2_base)
 	printk(KERN_INFO "xes_mpc85xx: Enabling L2 as cache\n");
 
 	ctl = MPC85xx_L2CTL_L2E | MPC85xx_L2CTL_L2I;
-	if (machine_is_compatible("MPC8540") ||
-	    machine_is_compatible("MPC8560"))
+	if (of_machine_is_compatible("MPC8540") ||
+	    of_machine_is_compatible("MPC8560"))
 		/*
 		 * Assume L2 SRAM is used fully for cache, so set
 		 * L2BLKSZ (bits 4:5) to match L2SIZ (bits 2:3).
diff --git a/arch/powerpc/platforms/cell/cbe_powerbutton.c b/arch/powerpc/platforms/cell/cbe_powerbutton.c
index dcddaa5..f75a4da 100644
--- a/arch/powerpc/platforms/cell/cbe_powerbutton.c
+++ b/arch/powerpc/platforms/cell/cbe_powerbutton.c
@@ -48,7 +48,7 @@ static int __init cbe_powerbutton_init(void)
 	int ret = 0;
 	struct input_dev *dev;
 
-	if (!machine_is_compatible("IBM,CBPLUS-1.0")) {
+	if (!of_machine_is_compatible("IBM,CBPLUS-1.0")) {
 		printk(KERN_ERR "%s: Not a cell blade.\n", __func__);
 		ret = -ENODEV;
 		goto out;
diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index 5e0a191..608fd2b 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -255,7 +255,7 @@ static int __init cbe_sysreset_init(void)
 {
 	struct cbe_pmd_regs __iomem *regs;
 
-	sysreset_hack = machine_is_compatible("IBM,CBPLUS-1.0");
+	sysreset_hack = of_machine_is_compatible("IBM,CBPLUS-1.0");
 	if (!sysreset_hack)
 		return 0;
 
diff --git a/arch/powerpc/platforms/pasemi/cpufreq.c b/arch/powerpc/platforms/pasemi/cpufreq.c
index be2527a..d35e052 100644
--- a/arch/powerpc/platforms/pasemi/cpufreq.c
+++ b/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -304,8 +304,8 @@ static struct cpufreq_driver pas_cpufreq_driver = {
 
 static int __init pas_cpufreq_init(void)
 {
-	if (!machine_is_compatible("PA6T-1682M") &&
-	    !machine_is_compatible("pasemi,pwrficient"))
+	if (!of_machine_is_compatible("PA6T-1682M") &&
+	    !of_machine_is_compatible("pasemi,pwrficient"))
 		return -ENODEV;
 
 	return cpufreq_register_driver(&pas_cpufreq_driver);
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 08d94e4..d4f127d 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -657,31 +657,31 @@ static int __init pmac_cpufreq_setup(void)
 	cur_freq = (*value) / 1000;
 
 	/*  Check for 7447A based MacRISC3 */
-	if (machine_is_compatible("MacRISC3") &&
+	if (of_machine_is_compatible("MacRISC3") &&
 	    of_get_property(cpunode, "dynamic-power-step", NULL) &&
 	    PVR_VER(mfspr(SPRN_PVR)) == 0x8003) {
 		pmac_cpufreq_init_7447A(cpunode);
 	/* Check for other MacRISC3 machines */
-	} else if (machine_is_compatible("PowerBook3,4") ||
-		   machine_is_compatible("PowerBook3,5") ||
-		   machine_is_compatible("MacRISC3")) {
+	} else if (of_machine_is_compatible("PowerBook3,4") ||
+		   of_machine_is_compatible("PowerBook3,5") ||
+		   of_machine_is_compatible("MacRISC3")) {
 		pmac_cpufreq_init_MacRISC3(cpunode);
 	/* Else check for iBook2 500/600 */
-	} else if (machine_is_compatible("PowerBook4,1")) {
+	} else if (of_machine_is_compatible("PowerBook4,1")) {
 		hi_freq = cur_freq;
 		low_freq = 400000;
 		set_speed_proc = pmu_set_cpu_speed;
 		is_pmu_based = 1;
 	}
 	/* Else check for TiPb 550 */
-	else if (machine_is_compatible("PowerBook3,3") && cur_freq == 550000) {
+	else if (of_machine_is_compatible("PowerBook3,3") && cur_freq == 550000) {
 		hi_freq = cur_freq;
 		low_freq = 500000;
 		set_speed_proc = pmu_set_cpu_speed;
 		is_pmu_based = 1;
 	}
 	/* Else check for TiPb 400 & 500 */
-	else if (machine_is_compatible("PowerBook3,2")) {
+	else if (of_machine_is_compatible("PowerBook3,2")) {
 		/* We only know about the 400 MHz and the 500Mhz model
 		 * they both have 300 MHz as low frequency
 		 */
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/arch/powerpc/platforms/powermac/cpufreq_64.c
index 708c751..3ed288e 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -398,11 +398,11 @@ static int __init g5_neo2_cpufreq_init(struct device_node *cpus)
 	int rc = -ENODEV;
 
 	/* Check supported platforms */
-	if (machine_is_compatible("PowerMac8,1") ||
-	    machine_is_compatible("PowerMac8,2") ||
-	    machine_is_compatible("PowerMac9,1"))
+	if (of_machine_is_compatible("PowerMac8,1") ||
+	    of_machine_is_compatible("PowerMac8,2") ||
+	    of_machine_is_compatible("PowerMac9,1"))
 		use_volts_smu = 1;
-	else if (machine_is_compatible("PowerMac11,2"))
+	else if (of_machine_is_compatible("PowerMac11,2"))
 		use_volts_vdnap = 1;
 	else
 		return -ENODEV;
@@ -729,9 +729,9 @@ static int __init g5_cpufreq_init(void)
 		return -ENODEV;
 	}
 
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		rc = g5_pm72_cpufreq_init(cpus);
 #ifdef CONFIG_PMAC_SMU
 	else
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index fbc9bbd..33e815f 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2426,7 +2426,7 @@ static int __init probe_motherboard(void)
 	    }
 	}
 	for(i=0; i<ARRAY_SIZE(pmac_mb_defs); i++) {
-	    if (machine_is_compatible(pmac_mb_defs[i].model_string)) {
+	    if (of_machine_is_compatible(pmac_mb_defs[i].model_string)) {
 		pmac_mb = pmac_mb_defs[i];
 		goto found;
 	    }
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index b40c22d..6898e82 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -693,9 +693,9 @@ static void __init smp_core99_setup(int ncpus)
 #ifdef CONFIG_PPC64
 
 	/* i2c based HW sync on some G5s */
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		smp_core99_setup_i2c_hwsync(ncpus);
 
 	/* pfunc based HW sync on recent G5s */
@@ -713,7 +713,7 @@ static void __init smp_core99_setup(int ncpus)
 #else /* CONFIG_PPC64 */
 
 	/* GPIO based HW sync on ppc32 Core99 */
-	if (pmac_tb_freeze == NULL && !machine_is_compatible("MacRISC4")) {
+	if (pmac_tb_freeze == NULL && !of_machine_is_compatible("MacRISC4")) {
 		struct device_node *cpu;
 		const u32 *tbprop = NULL;
 
@@ -750,7 +750,7 @@ static void __init smp_core99_setup(int ncpus)
 #endif
 
 	/* 32 bits SMP can't NAP */
-	if (!machine_is_compatible("MacRISC4"))
+	if (!of_machine_is_compatible("MacRISC4"))
 		powersave_nap = 0;
 }
 
@@ -852,7 +852,7 @@ static void __devinit smp_core99_setup_cpu(int cpu_nr)
 		/* If we didn't start the second CPU, we must take
 		 * it off the bus
 		 */
-		if (machine_is_compatible("MacRISC4") &&
+		if (of_machine_is_compatible("MacRISC4") &&
 		    num_online_cpus() < 2)		
 			g5_phy_disable_cpu1();
 #endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 1810e42..48211ca 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -317,9 +317,9 @@ void __init pmac_calibrate_decr(void)
 	 * calibration. That's better since the VIA itself seems
 	 * to be slightly off. --BenH
 	 */
-	if (!machine_is_compatible("MacRISC2") &&
-	    !machine_is_compatible("MacRISC3") &&
-	    !machine_is_compatible("MacRISC4"))
+	if (!of_machine_is_compatible("MacRISC2") &&
+	    !of_machine_is_compatible("MacRISC3") &&
+	    !of_machine_is_compatible("MacRISC4"))
 		if (via_calibrate_decr())
 			return;
 
@@ -328,7 +328,7 @@ void __init pmac_calibrate_decr(void)
 	 * probably implement calibration based on the KL timer on these
 	 * machines anyway... -BenH
 	 */
-	if (machine_is_compatible("PowerMac3,5"))
+	if (of_machine_is_compatible("PowerMac3,5"))
 		if (via_calibrate_decr())
 			return;
 #endif
diff --git a/arch/powerpc/platforms/powermac/udbg_scc.c b/arch/powerpc/platforms/powermac/udbg_scc.c
index 9490157..d83135a 100644
--- a/arch/powerpc/platforms/powermac/udbg_scc.c
+++ b/arch/powerpc/platforms/powermac/udbg_scc.c
@@ -132,9 +132,9 @@ void udbg_scc_init(int force_scc)
 		scc_inittab[1] = in_8(sccc);
 		out_8(sccc, 12);
 		scc_inittab[3] = in_8(sccc);
-	} else if (machine_is_compatible("RackMac1,1")
-		   || machine_is_compatible("RackMac1,2")
-		   || machine_is_compatible("MacRISC4")) {
+	} else if (of_machine_is_compatible("RackMac1,1")
+		   || of_machine_is_compatible("RackMac1,2")
+		   || of_machine_is_compatible("MacRISC4")) {
 		/* Xserves and G5s default to 57600 */
 		scc_inittab[1] = 0;
 		scc_inittab[3] = 0;
diff --git a/arch/powerpc/sysdev/grackle.c b/arch/powerpc/sysdev/grackle.c
index 5da37c2..cf27df6 100644
--- a/arch/powerpc/sysdev/grackle.c
+++ b/arch/powerpc/sysdev/grackle.c
@@ -56,9 +56,9 @@ static inline void grackle_set_loop_snoop(struct pci_controller *bp, int enable)
 void __init setup_grackle(struct pci_controller *hose)
 {
 	setup_indirect_pci(hose, 0xfec00000, 0xfee00000, 0);
-	if (machine_is_compatible("PowerMac1,1"))
+	if (of_machine_is_compatible("PowerMac1,1"))
 		ppc_pci_add_flags(PPC_PCI_REASSIGN_ALL_BUS);
-	if (machine_is_compatible("AAPL,PowerBook1998"))
+	if (of_machine_is_compatible("AAPL,PowerBook1998"))
 		grackle_set_loop_snoop(hose, 1);
 #if 0	/* Disabled for now, HW problems ??? */
 	grackle_set_stg(hose, 1);
diff --git a/drivers/char/hvc_beat.c b/drivers/char/hvc_beat.c
index 0afc8b8..9b397c5 100644
--- a/drivers/char/hvc_beat.c
+++ b/drivers/char/hvc_beat.c
@@ -99,7 +99,7 @@ static int hvc_beat_config(char *p)
 
 static int __init hvc_beat_console_init(void)
 {
-	if (hvc_beat_useit && machine_is_compatible("Beat")) {
+	if (hvc_beat_useit && of_machine_is_compatible("Beat")) {
 		hvc_instantiate(0, 0, &hvc_beat_get_put_ops);
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 579c892..13826a5 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -1280,47 +1280,47 @@ bool radeon_get_legacy_connector_info_from_table(struct drm_device *dev)
 	rdev->mode_info.connector_table = radeon_connector_table;
 	if (rdev->mode_info.connector_table == CT_NONE) {
 #ifdef CONFIG_PPC_PMAC
-		if (machine_is_compatible("PowerBook3,3")) {
+		if (of_machine_is_compatible("PowerBook3,3")) {
 			/* powerbook with VGA */
 			rdev->mode_info.connector_table = CT_POWERBOOK_VGA;
-		} else if (machine_is_compatible("PowerBook3,4") ||
-			   machine_is_compatible("PowerBook3,5")) {
+		} else if (of_machine_is_compatible("PowerBook3,4") ||
+			   of_machine_is_compatible("PowerBook3,5")) {
 			/* powerbook with internal tmds */
 			rdev->mode_info.connector_table = CT_POWERBOOK_INTERNAL;
-		} else if (machine_is_compatible("PowerBook5,1") ||
-			   machine_is_compatible("PowerBook5,2") ||
-			   machine_is_compatible("PowerBook5,3") ||
-			   machine_is_compatible("PowerBook5,4") ||
-			   machine_is_compatible("PowerBook5,5")) {
+		} else if (of_machine_is_compatible("PowerBook5,1") ||
+			   of_machine_is_compatible("PowerBook5,2") ||
+			   of_machine_is_compatible("PowerBook5,3") ||
+			   of_machine_is_compatible("PowerBook5,4") ||
+			   of_machine_is_compatible("PowerBook5,5")) {
 			/* powerbook with external single link tmds (sil164) */
 			rdev->mode_info.connector_table = CT_POWERBOOK_EXTERNAL;
-		} else if (machine_is_compatible("PowerBook5,6")) {
+		} else if (of_machine_is_compatible("PowerBook5,6")) {
 			/* powerbook with external dual or single link tmds */
 			rdev->mode_info.connector_table = CT_POWERBOOK_EXTERNAL;
-		} else if (machine_is_compatible("PowerBook5,7") ||
-			   machine_is_compatible("PowerBook5,8") ||
-			   machine_is_compatible("PowerBook5,9")) {
+		} else if (of_machine_is_compatible("PowerBook5,7") ||
+			   of_machine_is_compatible("PowerBook5,8") ||
+			   of_machine_is_compatible("PowerBook5,9")) {
 			/* PowerBook6,2 ? */
 			/* powerbook with external dual link tmds (sil1178?) */
 			rdev->mode_info.connector_table = CT_POWERBOOK_EXTERNAL;
-		} else if (machine_is_compatible("PowerBook4,1") ||
-			   machine_is_compatible("PowerBook4,2") ||
-			   machine_is_compatible("PowerBook4,3") ||
-			   machine_is_compatible("PowerBook6,3") ||
-			   machine_is_compatible("PowerBook6,5") ||
-			   machine_is_compatible("PowerBook6,7")) {
+		} else if (of_machine_is_compatible("PowerBook4,1") ||
+			   of_machine_is_compatible("PowerBook4,2") ||
+			   of_machine_is_compatible("PowerBook4,3") ||
+			   of_machine_is_compatible("PowerBook6,3") ||
+			   of_machine_is_compatible("PowerBook6,5") ||
+			   of_machine_is_compatible("PowerBook6,7")) {
 			/* ibook */
 			rdev->mode_info.connector_table = CT_IBOOK;
-		} else if (machine_is_compatible("PowerMac4,4")) {
+		} else if (of_machine_is_compatible("PowerMac4,4")) {
 			/* emac */
 			rdev->mode_info.connector_table = CT_EMAC;
-		} else if (machine_is_compatible("PowerMac10,1")) {
+		} else if (of_machine_is_compatible("PowerMac10,1")) {
 			/* mini with internal tmds */
 			rdev->mode_info.connector_table = CT_MINI_INTERNAL;
-		} else if (machine_is_compatible("PowerMac10,2")) {
+		} else if (of_machine_is_compatible("PowerMac10,2")) {
 			/* mini with external tmds */
 			rdev->mode_info.connector_table = CT_MINI_EXTERNAL;
-		} else if (machine_is_compatible("PowerMac12,1")) {
+		} else if (of_machine_is_compatible("PowerMac12,1")) {
 			/* PowerMac8,1 ? */
 			/* imac g5 isight */
 			rdev->mode_info.connector_table = CT_IMAC_G5_ISIGHT;
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 23741ce..d840a10 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -322,8 +322,8 @@ static int __init adb_init(void)
 		adb_controller = NULL;
 	} else {
 #ifdef CONFIG_PPC
-		if (machine_is_compatible("AAPL,PowerBook1998") ||
-			machine_is_compatible("PowerBook1,1"))
+		if (of_machine_is_compatible("AAPL,PowerBook1998") ||
+			of_machine_is_compatible("PowerBook1,1"))
 			sleepy_trackpad = 1;
 #endif /* CONFIG_PPC */
 
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 454bc50..5738d8b 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -1899,7 +1899,7 @@ static int create_control_loops(void)
 	 */
 	if (rackmac)
 		cpu_pid_type = CPU_PID_TYPE_RACKMAC;
-	else if (machine_is_compatible("PowerMac7,3")
+	else if (of_machine_is_compatible("PowerMac7,3")
 	    && (cpu_count > 1)
 	    && fcu_fans[CPUA_PUMP_RPM_INDEX].id != FCU_FAN_ABSENT_ID
 	    && fcu_fans[CPUB_PUMP_RPM_INDEX].id != FCU_FAN_ABSENT_ID) {
@@ -2234,10 +2234,10 @@ static int __init therm_pm72_init(void)
 {
 	struct device_node *np;
 
-	rackmac = machine_is_compatible("RackMac3,1");
+	rackmac = of_machine_is_compatible("RackMac3,1");
 
-	if (!machine_is_compatible("PowerMac7,2") &&
-	    !machine_is_compatible("PowerMac7,3") &&
+	if (!of_machine_is_compatible("PowerMac7,2") &&
+	    !of_machine_is_compatible("PowerMac7,3") &&
 	    !rackmac)
 	    	return -ENODEV;
 
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index ba48fd7..7fb8b4d 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -490,7 +490,7 @@ g4fan_init( void )
 	info = of_get_property(np, "thermal-info", NULL);
 	of_node_put(np);
 
-	if( !info || !machine_is_compatible("PowerMac3,6") )
+	if( !info || !of_machine_is_compatible("PowerMac3,6") )
 		return -ENODEV;
 
 	if( info->id != 3 ) {
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..4f3c447 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -150,13 +150,13 @@ void __init pmu_backlight_init()
 
 	/* Special case for the old PowerBook since I can't test on it */
 	autosave =
-		machine_is_compatible("AAPL,3400/2400") ||
-		machine_is_compatible("AAPL,3500");
+		of_machine_is_compatible("AAPL,3400/2400") ||
+		of_machine_is_compatible("AAPL,3500");
 
 	if (!autosave &&
 	    !pmac_has_backlight_type("pmu") &&
-	    !machine_is_compatible("AAPL,PowerBook1998") &&
-	    !machine_is_compatible("PowerBook1,1"))
+	    !of_machine_is_compatible("AAPL,PowerBook1998") &&
+	    !of_machine_is_compatible("PowerBook1,1"))
 		return;
 
 	snprintf(name, sizeof(name), "pmubl");
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index db379c3..4276484 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -463,8 +463,8 @@ static int __init via_pmu_dev_init(void)
 #endif
 
 #ifdef CONFIG_PPC32
-  	if (machine_is_compatible("AAPL,3400/2400") ||
-  		machine_is_compatible("AAPL,3500")) {
+  	if (of_machine_is_compatible("AAPL,3400/2400") ||
+  		of_machine_is_compatible("AAPL,3500")) {
 		int mb = pmac_call_feature(PMAC_FTR_GET_MB_INFO,
 			NULL, PMAC_MB_INFO_MODEL, 0);
 		pmu_battery_count = 1;
@@ -472,8 +472,8 @@ static int __init via_pmu_dev_init(void)
 			pmu_batteries[0].flags |= PMU_BATT_TYPE_COMET;
 		else
 			pmu_batteries[0].flags |= PMU_BATT_TYPE_HOOPER;
-	} else if (machine_is_compatible("AAPL,PowerBook1998") ||
-		machine_is_compatible("PowerBook1,1")) {
+	} else if (of_machine_is_compatible("AAPL,PowerBook1998") ||
+		of_machine_is_compatible("PowerBook1,1")) {
 		pmu_battery_count = 2;
 		pmu_batteries[0].flags |= PMU_BATT_TYPE_SMART;
 		pmu_batteries[1].flags |= PMU_BATT_TYPE_SMART;
diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 075b4d9..437f55c 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -468,9 +468,9 @@ static int __init windfarm_core_init(void)
 	DBG("wf: core loaded\n");
 
 	/* Don't register on old machines that use therm_pm72 for now */
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		return -ENODEV;
 	platform_device_register(&wf_platform_device);
 	return 0;
diff --git a/drivers/macintosh/windfarm_cpufreq_clamp.c b/drivers/macintosh/windfarm_cpufreq_clamp.c
index 900aade..1a77a7c 100644
--- a/drivers/macintosh/windfarm_cpufreq_clamp.c
+++ b/drivers/macintosh/windfarm_cpufreq_clamp.c
@@ -76,9 +76,9 @@ static int __init wf_cpufreq_clamp_init(void)
 	struct wf_control *clamp;
 
 	/* Don't register on old machines that use therm_pm72 for now */
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		return -ENODEV;
 
 	clamp = kmalloc(sizeof(struct wf_control), GFP_KERNEL);
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index ed6426a..d8257d3 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -239,9 +239,9 @@ static struct i2c_driver wf_lm75_driver = {
 static int __init wf_lm75_sensor_init(void)
 {
 	/* Don't register on old machines that use therm_pm72 for now */
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		return -ENODEV;
 	return i2c_add_driver(&wf_lm75_driver);
 }
diff --git a/drivers/macintosh/windfarm_max6690_sensor.c b/drivers/macintosh/windfarm_max6690_sensor.c
index a67b349..b486eb9 100644
--- a/drivers/macintosh/windfarm_max6690_sensor.c
+++ b/drivers/macintosh/windfarm_max6690_sensor.c
@@ -188,9 +188,9 @@ static struct i2c_driver wf_max6690_driver = {
 static int __init wf_max6690_sensor_init(void)
 {
 	/* Don't register on old machines that use therm_pm72 for now */
-	if (machine_is_compatible("PowerMac7,2") ||
-	    machine_is_compatible("PowerMac7,3") ||
-	    machine_is_compatible("RackMac3,1"))
+	if (of_machine_is_compatible("PowerMac7,2") ||
+	    of_machine_is_compatible("PowerMac7,3") ||
+	    of_machine_is_compatible("RackMac3,1"))
 		return -ENODEV;
 	return i2c_add_driver(&wf_max6690_driver);
 }
diff --git a/drivers/macintosh/windfarm_pm112.c b/drivers/macintosh/windfarm_pm112.c
index 73d695d..e0ee807 100644
--- a/drivers/macintosh/windfarm_pm112.c
+++ b/drivers/macintosh/windfarm_pm112.c
@@ -676,7 +676,7 @@ static int __init wf_pm112_init(void)
 {
 	struct device_node *cpu;
 
-	if (!machine_is_compatible("PowerMac11,2"))
+	if (!of_machine_is_compatible("PowerMac11,2"))
 		return -ENODEV;
 
 	/* Count the number of CPU cores */
diff --git a/drivers/macintosh/windfarm_pm121.c b/drivers/macintosh/windfarm_pm121.c
index 66ec4fb..947d4af 100644
--- a/drivers/macintosh/windfarm_pm121.c
+++ b/drivers/macintosh/windfarm_pm121.c
@@ -1008,7 +1008,7 @@ static int __init pm121_init(void)
 {
 	int rc = -ENODEV;
 
-	if (machine_is_compatible("PowerMac12,1"))
+	if (of_machine_is_compatible("PowerMac12,1"))
 		rc = pm121_init_pm();
 
 	if (rc == 0) {
diff --git a/drivers/macintosh/windfarm_pm81.c b/drivers/macintosh/windfarm_pm81.c
index abbe206..565d5b2 100644
--- a/drivers/macintosh/windfarm_pm81.c
+++ b/drivers/macintosh/windfarm_pm81.c
@@ -779,8 +779,8 @@ static int __init wf_smu_init(void)
 {
 	int rc = -ENODEV;
 
-	if (machine_is_compatible("PowerMac8,1") ||
-	    machine_is_compatible("PowerMac8,2"))
+	if (of_machine_is_compatible("PowerMac8,1") ||
+	    of_machine_is_compatible("PowerMac8,2"))
 		rc = wf_init_pm();
 
 	if (rc == 0) {
diff --git a/drivers/macintosh/windfarm_pm91.c b/drivers/macintosh/windfarm_pm91.c
index 764c525..bea9916 100644
--- a/drivers/macintosh/windfarm_pm91.c
+++ b/drivers/macintosh/windfarm_pm91.c
@@ -711,7 +711,7 @@ static int __init wf_smu_init(void)
 {
 	int rc = -ENODEV;
 
-	if (machine_is_compatible("PowerMac9,1"))
+	if (of_machine_is_compatible("PowerMac9,1"))
 		rc = wf_init_pm();
 
 	if (rc == 0) {
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index 9c567b9..3c19350 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -363,9 +363,9 @@ smu_cpu_power_create(struct wf_sensor *volts, struct wf_sensor *amps)
 	 * I yet have to figure out what's up with 8,2 and will have to
 	 * adjust for later, unless we can 100% trust the SDB partition...
 	 */
-	if ((machine_is_compatible("PowerMac8,1") ||
-	     machine_is_compatible("PowerMac8,2") ||
-	     machine_is_compatible("PowerMac9,1")) &&
+	if ((of_machine_is_compatible("PowerMac8,1") ||
+	     of_machine_is_compatible("PowerMac8,2") ||
+	     of_machine_is_compatible("PowerMac9,1")) &&
 	    cpuvcp_version >= 2) {
 		pow->quadratic = 1;
 		DBG("windfarm: CPU Power using quadratic transform\n");
diff --git a/drivers/net/mace.c b/drivers/net/mace.c
index d9fbad3..43aea91 100644
--- a/drivers/net/mace.c
+++ b/drivers/net/mace.c
@@ -206,7 +206,7 @@ static int __devinit mace_probe(struct macio_dev *mdev, const struct of_device_i
 		mp->port_aaui = port_aaui;
 	else {
 		/* Apple Network Server uses the AAUI port */
-		if (machine_is_compatible("AAPL,ShinerESB"))
+		if (of_machine_is_compatible("AAPL,ShinerESB"))
 			mp->port_aaui = 1;
 		else {
 #ifdef CONFIG_MACE_AAUI_PORT
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 785e9cc..6bc8740 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -219,13 +219,13 @@ int of_device_is_compatible(const struct device_node *device,
 EXPORT_SYMBOL(of_device_is_compatible);
 
 /**
- * machine_is_compatible - Test root of device tree for a given compatible value
+ * of_machine_is_compatible - Test root of device tree for a given compatible value
  * @compat: compatible string to look for in root node's compatible property.
  *
  * Returns true if the root node has the given value in its
  * compatible property.
  */
-int machine_is_compatible(const char *compat)
+int of_machine_is_compatible(const char *compat)
 {
 	struct device_node *root;
 	int rc = 0;
@@ -237,7 +237,7 @@ int machine_is_compatible(const char *compat)
 	}
 	return rc;
 }
-EXPORT_SYMBOL(machine_is_compatible);
+EXPORT_SYMBOL(of_machine_is_compatible);
 
 /**
  *  of_device_is_available - check if a device is available for use
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 683e66f..3e2ae48 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -2031,9 +2031,9 @@ static int __init pmz_console_setup(struct console *co, char *options)
 	/*
 	 * XServe's default to 57600 bps
 	 */
-	if (machine_is_compatible("RackMac1,1")
-	    || machine_is_compatible("RackMac1,2")
-	    || machine_is_compatible("MacRISC4"))
+	if (of_machine_is_compatible("RackMac1,1")
+	    || of_machine_is_compatible("RackMac1,2")
+	    || of_machine_is_compatible("MacRISC4"))
 	 	baud = 57600;
 
 	/*
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e4e4d43..9ee67d6 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1931,22 +1931,22 @@ static int __devinit aty128_init(struct pci_dev *pdev, const struct pci_device_i
 			 * PowerMac2,2 summer 2000 iMacs
 			 * PowerMac4,1 january 2001 iMacs "flower power"
 			 */
-			if (machine_is_compatible("PowerMac2,1") ||
-			    machine_is_compatible("PowerMac2,2") ||
-			    machine_is_compatible("PowerMac4,1"))
+			if (of_machine_is_compatible("PowerMac2,1") ||
+			    of_machine_is_compatible("PowerMac2,2") ||
+			    of_machine_is_compatible("PowerMac4,1"))
 				default_vmode = VMODE_1024_768_75;
 
 			/* iBook SE */
-			if (machine_is_compatible("PowerBook2,2"))
+			if (of_machine_is_compatible("PowerBook2,2"))
 				default_vmode = VMODE_800_600_60;
 
 			/* PowerBook Firewire (Pismo), iBook Dual USB */
-			if (machine_is_compatible("PowerBook3,1") ||
-			    machine_is_compatible("PowerBook4,1"))
+			if (of_machine_is_compatible("PowerBook3,1") ||
+			    of_machine_is_compatible("PowerBook4,1"))
 				default_vmode = VMODE_1024_768_60;
 
 			/* PowerBook Titanium */
-			if (machine_is_compatible("PowerBook3,2"))
+			if (of_machine_is_compatible("PowerBook3,2"))
 				default_vmode = VMODE_1152_768_60;
 	
 			if (default_cmode > 16) 
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 5f1b580..e45ab8d 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2439,7 +2439,7 @@ static int __devinit aty_init(struct fb_info *info)
 	 * The Apple iBook1 uses non-standard memory frequencies.
 	 * We detect it and set the frequency manually.
 	 */
-	if (machine_is_compatible("PowerBook2,1")) {
+	if (of_machine_is_compatible("PowerBook2,1")) {
 		par->pll_limits.mclk = 70;
 		par->pll_limits.xclk = 53;
 	}
@@ -2659,7 +2659,7 @@ static int __devinit aty_init(struct fb_info *info)
 		      FBINFO_HWACCEL_YPAN;
 
 #ifdef CONFIG_PMAC_BACKLIGHT
-	if (M64_HAS(G3_PB_1_1) && machine_is_compatible("PowerBook1,1")) {
+	if (M64_HAS(G3_PB_1_1) && of_machine_is_compatible("PowerBook1,1")) {
 		/*
 		 * these bits let the 101 powerbook
 		 * wake up from sleep -- paulus
@@ -2690,9 +2690,9 @@ static int __devinit aty_init(struct fb_info *info)
 				if (M64_HAS(G3_PB_1024x768))
 					/* G3 PowerBook with 1024x768 LCD */
 					default_vmode = VMODE_1024_768_60;
-				else if (machine_is_compatible("iMac"))
+				else if (of_machine_is_compatible("iMac"))
 					default_vmode = VMODE_1024_768_75;
-				else if (machine_is_compatible("PowerBook2,1"))
+				else if (of_machine_is_compatible("PowerBook2,1"))
 					/* iBook with 800x600 LCD */
 					default_vmode = VMODE_800_600_60;
 				else
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 1a056ad..fa1198c 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -175,9 +175,9 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	pdata->negative = pdata->negative ||
-		machine_is_compatible("PowerBook4,3") ||
-		machine_is_compatible("PowerBook6,3") ||
-		machine_is_compatible("PowerBook6,5");
+		of_machine_is_compatible("PowerBook4,3") ||
+		of_machine_is_compatible("PowerBook6,3") ||
+		of_machine_is_compatible("PowerBook6,5");
 #endif
 
 	rinfo->info->bl_dev = bd;
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 8118d45..fbf2961 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -85,7 +85,7 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 extern void finish_device_tree(void);
 extern void unflatten_device_tree(void);
 extern void early_init_devtree(void *);
-extern int machine_is_compatible(const char *compat);
+extern int of_machine_is_compatible(const char *compat);
 extern void print_properties(struct device_node *node);
 extern int prom_n_intr_cells(struct device_node* np);
 extern void prom_get_irq_senses(unsigned char *senses, int off, int max);
diff --git a/sound/ppc/awacs.c b/sound/ppc/awacs.c
index 2e15646..b366793 100644
--- a/sound/ppc/awacs.c
+++ b/sound/ppc/awacs.c
@@ -751,8 +751,8 @@ static void snd_pmac_awacs_suspend(struct snd_pmac *chip)
 
 static void snd_pmac_awacs_resume(struct snd_pmac *chip)
 {
-	if (machine_is_compatible("PowerBook3,1")
-	    || machine_is_compatible("PowerBook3,2")) {
+	if (of_machine_is_compatible("PowerBook3,1")
+	    || of_machine_is_compatible("PowerBook3,2")) {
 		msleep(100);
 		snd_pmac_awacs_write_reg(chip, 1,
 			chip->awacs_reg[1] & ~MASK_PAROUT);
@@ -780,16 +780,16 @@ static void snd_pmac_awacs_resume(struct snd_pmac *chip)
 }
 #endif /* CONFIG_PM */
 
-#define IS_PM7500 (machine_is_compatible("AAPL,7500") \
-		|| machine_is_compatible("AAPL,8500") \
-		|| machine_is_compatible("AAPL,9500"))
-#define IS_PM5500 (machine_is_compatible("AAPL,e411"))
-#define IS_BEIGE (machine_is_compatible("AAPL,Gossamer"))
-#define IS_IMAC1 (machine_is_compatible("PowerMac2,1"))
-#define IS_IMAC2 (machine_is_compatible("PowerMac2,2") \
-		|| machine_is_compatible("PowerMac4,1"))
-#define IS_G4AGP (machine_is_compatible("PowerMac3,1"))
-#define IS_LOMBARD (machine_is_compatible("PowerBook1,1"))
+#define IS_PM7500 (of_machine_is_compatible("AAPL,7500") \
+		|| of_machine_is_compatible("AAPL,8500") \
+		|| of_machine_is_compatible("AAPL,9500"))
+#define IS_PM5500 (of_machine_is_compatible("AAPL,e411"))
+#define IS_BEIGE (of_machine_is_compatible("AAPL,Gossamer"))
+#define IS_IMAC1 (of_machine_is_compatible("PowerMac2,1"))
+#define IS_IMAC2 (of_machine_is_compatible("PowerMac2,2") \
+		|| of_machine_is_compatible("PowerMac4,1"))
+#define IS_G4AGP (of_machine_is_compatible("PowerMac3,1"))
+#define IS_LOMBARD (of_machine_is_compatible("PowerBook1,1"))
 
 static int imac1, imac2;
 
diff --git a/sound/ppc/burgundy.c b/sound/ppc/burgundy.c
index 0accfe4..1f72e1c 100644
--- a/sound/ppc/burgundy.c
+++ b/sound/ppc/burgundy.c
@@ -582,7 +582,7 @@ static int snd_pmac_burgundy_detect_headphone(struct snd_pmac *chip)
 static void snd_pmac_burgundy_update_automute(struct snd_pmac *chip, int do_notify)
 {
 	if (chip->auto_mute) {
-		int imac = machine_is_compatible("iMac");
+		int imac = of_machine_is_compatible("iMac");
 		int reg, oreg;
 		reg = oreg = snd_pmac_burgundy_rcb(chip,
 				MASK_ADDR_BURGUNDY_MORE_OUTPUTENABLES);
@@ -620,7 +620,7 @@ static void snd_pmac_burgundy_update_automute(struct snd_pmac *chip, int do_noti
  */
 int __devinit snd_pmac_burgundy_init(struct snd_pmac *chip)
 {
-	int imac = machine_is_compatible("iMac");
+	int imac = of_machine_is_compatible("iMac");
 	int i, err;
 
 	/* Checks to see the chip is alive and kicking */
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 7bc492e..8508117 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -922,11 +922,11 @@ static void __devinit detect_byte_swap(struct snd_pmac *chip)
 	}
 
 	/* it seems the Pismo & iBook can't byte-swap in hardware. */
-	if (machine_is_compatible("PowerBook3,1") ||
-	    machine_is_compatible("PowerBook2,1"))
+	if (of_machine_is_compatible("PowerBook3,1") ||
+	    of_machine_is_compatible("PowerBook2,1"))
 		chip->can_byte_swap = 0 ;
 
-	if (machine_is_compatible("PowerBook2,1"))
+	if (of_machine_is_compatible("PowerBook2,1"))
 		chip->can_duplex = 0;
 }
 
@@ -959,11 +959,11 @@ static int __devinit snd_pmac_detect(struct snd_pmac *chip)
 	chip->control_mask = MASK_IEPC | MASK_IEE | 0x11; /* default */
 
 	/* check machine type */
-	if (machine_is_compatible("AAPL,3400/2400")
-	    || machine_is_compatible("AAPL,3500"))
+	if (of_machine_is_compatible("AAPL,3400/2400")
+	    || of_machine_is_compatible("AAPL,3500"))
 		chip->is_pbook_3400 = 1;
-	else if (machine_is_compatible("PowerBook1,1")
-		 || machine_is_compatible("AAPL,PowerBook1998"))
+	else if (of_machine_is_compatible("PowerBook1,1")
+		 || of_machine_is_compatible("AAPL,PowerBook1998"))
 		chip->is_pbook_G3 = 1;
 	chip->node = of_find_node_by_name(NULL, "awacs");
 	sound = of_node_get(chip->node);
@@ -1033,8 +1033,8 @@ static int __devinit snd_pmac_detect(struct snd_pmac *chip)
 	}
 	if (of_device_is_compatible(sound, "tumbler")) {
 		chip->model = PMAC_TUMBLER;
-		chip->can_capture = machine_is_compatible("PowerMac4,2")
-				|| machine_is_compatible("PowerBook4,1");
+		chip->can_capture = of_machine_is_compatible("PowerMac4,2")
+				|| of_machine_is_compatible("PowerBook4,1");
 		chip->can_duplex = 0;
 		// chip->can_byte_swap = 0; /* FIXME: check this */
 		chip->num_freqs = ARRAY_SIZE(tumbler_freqs);
diff --git a/sound/soc/fsl/efika-audio-fabric.c b/sound/soc/fsl/efika-audio-fabric.c
index 3326e2a..1a5b8e0 100644
--- a/sound/soc/fsl/efika-audio-fabric.c
+++ b/sound/soc/fsl/efika-audio-fabric.c
@@ -55,7 +55,7 @@ static __init int efika_fabric_init(void)
 	struct platform_device *pdev;
 	int rc;
 
-	if (!machine_is_compatible("bplan,efika"))
+	if (!of_machine_is_compatible("bplan,efika"))
 		return -ENODEV;
 
 	card.platform = &mpc5200_audio_dma_platform;
diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index b928ef7..6644cba 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -55,7 +55,7 @@ static __init int pcm030_fabric_init(void)
 	struct platform_device *pdev;
 	int rc;
 
-	if (!machine_is_compatible("phytec,pcm030"))
+	if (!of_machine_is_compatible("phytec,pcm030"))
 		return -ENODEV;
 
 	card.platform = &mpc5200_audio_dma_platform;

