Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYBQMM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYBQMM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYBQMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:12:51 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51608 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYBQMMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:12:48 -0500
Date: Sun, 17 Feb 2008 13:12:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/27] fix section mismatches
Message-ID: <20080217121255.GA10519@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch set fix all section mismatches for a
allnoconfig, allyesconfig, defconfig build of x86 - 64bit.
The builds were all done with CONFIG_DEBUG_SECTION_MISMATCH
enabled.

The fixes are spread all over the tree but none of them are
invasive in nature.
diffstat for the full patchset reports:
 33 files changed, 58 insertions(+), 58 deletions(-)

A total of 66 section mismatch warnings are fixed.

I have for each patch tried to identify the relevant persons
and added them to Cc.

Andrew - can we suck it all into -mm or do you have other
preferences? I expect over time the respective maintainers
will pick up the patches, review them and apply them.
(Call me naive).

Patches will follow and the full diff is included below for
easier review.


And before anyone ask... I started out with x86 64bit but I
plan to take a look at other architectures when these are
in mainline.  But do not wait for me - please fix the
warning yourself.

	Sam


Sam Ravnborg (27):
      serial: silence section mismatch warnings in 8250_pci
      rtc: silence section mismatch warning in rtc-test
      pcmcia: silence section mismatch warnings from class_interface variables
      pcmcia: silence section mismatch warnings from pci_driver variables
      cpu: fix section mismatch warnings in hotcpu_register
      cpu: fix section mismatch warning in unregister_cpu_notifier
      cpu: fix section mismatch warnings in *cpu_down
      cpu: fix section mismatch warning in reference to register_cpu_notifier
      x86: fix section mismatch warning in setup_64.c:nearby_node
      x86: fix section mismatch in setup_64.c:srat_detect_node
      acpi: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
      x86: fix section mismatch warning in topology.c:arch_register_cpu
      drivers/base/cpu: fix section mismatch in cpu.c:store_online
      hwmon: fix section mismatch in coretemp
      cpufreq: fix section mismatch warnings
      scsi: fix section mismatch in aic94xx
      acer-wmi: fix section mismatch warnings
      video: fix section mismatch warnings in uvesafb
      tpm: fix section mismatch warning
      [ALSA] caiaq - fix section mismatch warning
      x86: fix section mismatch in srat_64.c:reserve_hotadd
      x86: fix section mismatch in head_64.S:initial_code
      x86: annotate pci/common.s:pci_scan_bus_with_sysdata with __devinit
      pcmcia: annotate cb_alloc with __ref
      pci: fix section mismatch warning in pci_scan_child_bus
      acpi: fix section mismatch in acpi_pci_root_add
      [ALSA] hdsp - fix section mismatch warnings


 arch/x86/kernel/head_64.S              |    2 +-
 arch/x86/kernel/setup_64.c             |    4 ++--
 arch/x86/kernel/topology.c             |    2 +-
 arch/x86/mm/srat_64.c                  |    2 +-
 arch/x86/pci/common.c                  |    2 +-
 drivers/acpi/pci_root.c                |    2 +-
 drivers/acpi/processor_core.c          |    4 ++--
 drivers/base/cpu.c                     |    4 ++--
 drivers/char/tpm/tpm_nsc.c             |    2 +-
 drivers/cpufreq/cpufreq.c              |    2 +-
 drivers/cpufreq/cpufreq_stats.c        |    2 +-
 drivers/hwmon/coretemp.c               |    4 ++--
 drivers/misc/acer-wmi.c                |    6 +++---
 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/pciehp_pci.c       |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/probe.c                    |    8 ++++----
 drivers/pcmcia/cardbus.c               |    2 +-
 drivers/pcmcia/ds.c                    |    2 +-
 drivers/pcmcia/i82092.c                |    6 +++---
 drivers/pcmcia/pd6729.c                |    6 +++---
 drivers/pcmcia/rsrc_nonstatic.c        |    2 +-
 drivers/pcmcia/socket_sysfs.c          |    2 +-
 drivers/rtc/rtc-test.c                 |    8 ++++----
 drivers/scsi/aic94xx/aic94xx_init.c    |    4 ++--
 drivers/serial/8250_pci.c              |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 include/linux/cpu.h                    |    2 +-
 kernel/cpu.c                           |   10 +++++-----
 sound/pci/rme9652/hdsp.c               |    6 +++---
 sound/usb/caiaq/caiaq-device.c         |    6 +++---
 33 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 09b38d5..220daaa 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -250,7 +250,7 @@ ENTRY(secondary_startup_64)
 	lretq
 
 	/* SMP bootup changes these two */
-	__CPUINITDATA
+	__REFDATA
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c0d8208..e186617 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -518,7 +518,7 @@ static void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_NUMA
-static int nearby_node(int apicid)
+static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
 
@@ -791,7 +791,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-static void srat_detect_node(void)
+static void __cpuinit srat_detect_node(void)
 {
 #ifdef CONFIG_NUMA
 	unsigned node;
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index a40051b..0fcc95a 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -34,7 +34,7 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-int arch_register_cpu(int num)
+int __ref arch_register_cpu(int num)
 {
 	/*
 	 * CPU0 cannot be offlined due to several
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index ecd91ea..70eb153 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -166,7 +166,7 @@ static inline int save_add_info(void) {return 0;}
  * Both SPARSE and RESERVE need nodes_add information.
  * This code supports one contiguous hot add area per node.
  */
-static int reserve_hotadd(int node, unsigned long start, unsigned long end)
+static int __init reserve_hotadd(int node, unsigned long start, unsigned long end)
 {
 	unsigned long s_pfn = start >> PAGE_SHIFT;
 	unsigned long e_pfn = end >> PAGE_SHIFT;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index b7c67a1..7b6e3bb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -541,7 +541,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index f14ff1f..c3fed31 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -184,7 +184,7 @@ static void acpi_pci_bridge_scan(struct acpi_device *device)
 		}
 }
 
-static int acpi_pci_root_add(struct acpi_device *device)
+static int __devinit acpi_pci_root_add(struct acpi_device *device)
 {
 	int result = 0;
 	struct acpi_pci_root *root = NULL;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 75ccf5d..d3cc07f 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -881,8 +881,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
 	return 0;
 }
 
-static void
-acpi_processor_hotplug_notify(acpi_handle handle, u32 event, void *data)
+static void __ref acpi_processor_hotplug_notify(acpi_handle handle,
+						u32 event, void *data)
 {
 	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 499b003..3e417a9 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -28,7 +28,7 @@ static ssize_t show_online(struct sys_device *dev, char *buf)
 	return sprintf(buf, "%u\n", !!cpu_online(cpu->sysdev.id));
 }
 
-static ssize_t store_online(struct sys_device *dev, const char *buf,
+static ssize_t __ref store_online(struct sys_device *dev, const char *buf,
 			    size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
@@ -55,7 +55,7 @@ static ssize_t store_online(struct sys_device *dev, const char *buf,
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
-static void __devinit register_cpu_control(struct cpu *cpu)
+static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
 }
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 6313326..ab18c1e 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -264,7 +264,7 @@ static const struct tpm_vendor_specific tpm_nsc = {
 
 static struct platform_device *pdev = NULL;
 
-static void __devexit tpm_nsc_remove(struct device *dev)
+static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if ( chip ) {
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 64926aa..c45768a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1783,7 +1783,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpufreq_cpu_notifier =
+static struct notifier_block __refdata cpufreq_cpu_notifier =
 {
     .notifier_call = cpufreq_cpu_callback,
 };
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 1b8312b..070421a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -323,7 +323,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier __cpuinitdata =
+static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 3ee60d2..1439432 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -330,7 +330,7 @@ static void coretemp_device_remove(unsigned int cpu)
 	mutex_unlock(&pdev_list_mutex);
 }
 
-static int coretemp_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
 				 unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long) hcpu;
@@ -347,7 +347,7 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block coretemp_cpu_notifier = {
+static struct notifier_block coretemp_cpu_notifier __refdata = {
 	.notifier_call = coretemp_cpu_callback,
 };
 #endif				/* !CONFIG_HOTPLUG_CPU */
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d7aea93..cdc733b 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -756,7 +756,7 @@ static struct led_classdev mail_led = {
 	.brightness_set = mail_led_set,
 };
 
-static int __init acer_led_init(struct device *dev)
+static int __devinit acer_led_init(struct device *dev)
 {
 	return led_classdev_register(dev, &mail_led);
 }
@@ -789,7 +789,7 @@ static struct backlight_ops acer_bl_ops = {
 	.update_status = update_bl_status,
 };
 
-static int __init acer_backlight_init(struct device *dev)
+static int __devinit acer_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
 
@@ -808,7 +808,7 @@ static int __init acer_backlight_init(struct device *dev)
 	return 0;
 }
 
-static void __exit acer_backlight_exit(void)
+static void acer_backlight_exit(void)
 {
 	backlight_device_unregister(acer_backlight_device);
 }
diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index a590ef6..4d4a644 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -4,7 +4,7 @@
 #include "pci.h"
 
 
-unsigned int pci_do_scan_bus(struct pci_bus *bus)
+unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cf22f9e..5e50008 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1085,7 +1085,7 @@ static int acpiphp_bus_trim(acpi_handle handle)
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static int enable_device(struct acpiphp_slot *slot)
+static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 5e9be44..dddac96 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -250,7 +250,7 @@ int cpci_led_off(struct slot* slot)
  * Device configuration functions
  */
 
-int cpci_configure_slot(struct slot* slot)
+int __ref cpci_configure_slot(struct slot* slot)
 {
 	struct pci_bus *parent;
 	int fn;
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index dd50713..9372a84 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -167,7 +167,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-static int pciehp_add_bridge(struct pci_dev *dev)
+static int __ref pciehp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
 	int pass, busnr, start = parent->secondary;
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index 0a6b25e..a69a215 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -96,7 +96,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-int shpchp_configure_device(struct slot *p_slot)
+int __ref shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4d23b9f..5ffd610 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -286,7 +286,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-void pci_read_bridge_bases(struct pci_bus *child)
+void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
@@ -472,7 +472,7 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
  * them, we proceed to assigning numbers to the remaining buses in
  * order to avoid overlaps between old and new bus numbers.
  */
-int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
+int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
@@ -1008,7 +1008,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	return nr;
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus)
+unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
 	struct pci_dev *dev;
@@ -1116,7 +1116,7 @@ err_out:
 	return NULL;
 }
 
-struct pci_bus *pci_scan_bus_parented(struct device *parent,
+struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index 714baae..fb2f38d 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -209,7 +209,7 @@ static void cardbus_assign_irqs(struct pci_bus *bus, int irq)
 	}
 }
 
-int cb_alloc(struct pcmcia_socket * s)
+int __ref cb_alloc(struct pcmcia_socket * s)
 {
 	struct pci_bus *bus = s->cb_dev->subordinate;
 	struct pci_dev *dev;
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5a85871..e407754 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1520,7 +1520,7 @@ static void pcmcia_bus_remove_socket(struct device *dev,
 
 
 /* the pcmcia_bus_interface is used to handle pcmcia socket devices */
-static struct class_interface pcmcia_bus_interface = {
+static struct class_interface pcmcia_bus_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pcmcia_bus_add_socket,
 	.remove_dev = &pcmcia_bus_remove_socket,
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 7495155..1b3749e 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -53,7 +53,7 @@ static int i82092aa_socket_resume (struct pci_dev *dev)
 }
 #endif
 
-static struct pci_driver i82092aa_pci_drv = {
+static struct pci_driver i82092aa_pci_driver = {
 	.name           = "i82092aa",
 	.id_table       = i82092aa_pci_ids,
 	.probe          = i82092aa_pci_probe,
@@ -709,13 +709,13 @@ static int i82092aa_set_mem_map(struct pcmcia_socket *socket, struct pccard_mem_
 
 static int i82092aa_module_init(void)
 {
-	return pci_register_driver(&i82092aa_pci_drv);
+	return pci_register_driver(&i82092aa_pci_driver);
 }
 
 static void i82092aa_module_exit(void)
 {
 	enter("i82092aa_module_exit");
-	pci_unregister_driver(&i82092aa_pci_drv);
+	pci_unregister_driver(&i82092aa_pci_driver);
 	if (sockets[0].io_base>0)
 			 release_region(sockets[0].io_base, 2);
 	leave("i82092aa_module_exit");
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index abc10fe..8bed1da 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -778,7 +778,7 @@ static struct pci_device_id pd6729_pci_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, pd6729_pci_ids);
 
-static struct pci_driver pd6729_pci_drv = {
+static struct pci_driver pd6729_pci_driver = {
 	.name		= "pd6729",
 	.id_table	= pd6729_pci_ids,
 	.probe		= pd6729_pci_probe,
@@ -791,12 +791,12 @@ static struct pci_driver pd6729_pci_drv = {
 
 static int pd6729_module_init(void)
 {
-	return pci_register_driver(&pd6729_pci_drv);
+	return pci_register_driver(&pd6729_pci_driver);
 }
 
 static void pd6729_module_exit(void)
 {
-	pci_unregister_driver(&pd6729_pci_drv);
+	pci_unregister_driver(&pd6729_pci_driver);
 }
 
 module_init(pd6729_module_init);
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index a8d1007..0fcf763 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -1045,7 +1045,7 @@ static void __devexit pccard_sysfs_remove_rsrc(struct device *dev,
 		device_remove_file(dev, *attr);
 }
 
-static struct class_interface pccard_rsrc_interface = {
+static struct class_interface pccard_rsrc_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_rsrc,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_rsrc),
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index b440900..4677286 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -403,7 +403,7 @@ static void __devexit pccard_sysfs_remove_socket(struct device *dev,
 		device_remove_file(dev, *attr);
 }
 
-struct class_interface pccard_sysfs_interface = {
+struct class_interface pccard_sysfs_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_socket,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_socket),
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 254c9fc..bc93002 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -147,7 +147,7 @@ static int __devexit test_remove(struct platform_device *plat_dev)
 	return 0;
 }
 
-static struct platform_driver test_drv = {
+static struct platform_driver test_driver = {
 	.probe	= test_probe,
 	.remove = __devexit_p(test_remove),
 	.driver = {
@@ -160,7 +160,7 @@ static int __init test_init(void)
 {
 	int err;
 
-	if ((err = platform_driver_register(&test_drv)))
+	if ((err = platform_driver_register(&test_driver)))
 		return err;
 
 	if ((test0 = platform_device_alloc("rtc-test", 0)) == NULL) {
@@ -191,7 +191,7 @@ exit_free_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 	return err;
 }
 
@@ -199,7 +199,7 @@ static void __exit test_exit(void)
 {
 	platform_device_unregister(test0);
 	platform_device_unregister(test1);
-	platform_driver_unregister(&test_drv);
+	platform_driver_unregister(&test_driver);
 }
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 5d761eb..720812f 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -531,10 +531,10 @@ static void asd_remove_dev_attrs(struct asd_ha_struct *asd_ha)
 /* The first entry, 0, is used for dynamic ids, the rest for devices
  * we know about.
  */
-static struct asd_pcidev_struct {
+static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] = {
+} asd_pcidev_data[] __devinitconst = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index a8bec49..c4b77a5 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -775,7 +775,7 @@ pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
  * This list is ordered alphabetically by vendor then device.
  * Specific entries must come before more generic entries.
  */
-static struct pci_serial_quirk pci_serial_quirks[] = {
+static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	/*
 	* ADDI-DATA GmbH communication cards <info@addi-data.com>
 	*/
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index be27b9c..2fb5bb8 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -44,7 +44,7 @@ static struct fb_fix_screeninfo uvesafb_fix __devinitdata = {
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
-static int ypan		__devinitdata = 1; /* 0: scroll, 1: ypan, 2: ywrap */
+static int ypan		= 1;		   /* 0: scroll, 1: ypan, 2: ywrap */
 static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 0be8d65..237c19a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..329fdcb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int __ref register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
 	cpu_maps_update_begin();
@@ -149,7 +149,7 @@ int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 
 EXPORT_SYMBOL(register_cpu_notifier);
 
-void unregister_cpu_notifier(struct notifier_block *nb)
+void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
 	cpu_maps_update_begin();
 	raw_notifier_chain_unregister(&cpu_chain, nb);
@@ -180,7 +180,7 @@ struct take_cpu_down_param {
 };
 
 /* Take this CPU down. */
-static int take_cpu_down(void *_param)
+static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	int err;
@@ -199,7 +199,7 @@ static int take_cpu_down(void *_param)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
 	struct task_struct *p;
@@ -274,7 +274,7 @@ out_release:
 	return err;
 }
 
-int cpu_down(unsigned int cpu)
+int __ref cpu_down(unsigned int cpu)
 {
 	int err = 0;
 
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index c2bd438..6f07a25 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -745,7 +745,7 @@ static int hdsp_get_iobox_version (struct hdsp *hdsp)
 
 
 #ifdef HDSP_FW_LOADER
-static int __devinit hdsp_request_fw_loader(struct hdsp *hdsp);
+static int hdsp_request_fw_loader(struct hdsp *hdsp);
 #endif
 
 static int hdsp_check_for_firmware (struct hdsp *hdsp, int load_on_demand)
@@ -4688,7 +4688,7 @@ static struct snd_pcm_ops snd_hdsp_capture_ops = {
 	.copy =		snd_hdsp_capture_copy,
 };
 
-static int __devinit snd_hdsp_create_hwdep(struct snd_card *card,
+static int snd_hdsp_create_hwdep(struct snd_card *card,
 					   struct hdsp *hdsp)
 {
 	struct snd_hwdep *hw;
@@ -4857,7 +4857,7 @@ static int snd_hdsp_create_alsa_devices(struct snd_card *card, struct hdsp *hdsp
 
 #ifdef HDSP_FW_LOADER
 /* load firmware via hotplug fw loader */
-static int __devinit hdsp_request_fw_loader(struct hdsp *hdsp)
+static int hdsp_request_fw_loader(struct hdsp *hdsp)
 {
 	const char *fwfile;
 	const struct firmware *fw;
diff --git a/sound/usb/caiaq/caiaq-device.c b/sound/usb/caiaq/caiaq-device.c
index 58d25e4..7c44a2c 100644
--- a/sound/usb/caiaq/caiaq-device.c
+++ b/sound/usb/caiaq/caiaq-device.c
@@ -245,7 +245,7 @@ int snd_usb_caiaq_set_auto_msg (struct snd_usb_caiaqdev *dev,
 					  tmp, sizeof(tmp));
 }
 
-static void setup_card(struct snd_usb_caiaqdev *dev)
+static void __devinit setup_card(struct snd_usb_caiaqdev *dev)
 {
 	int ret;
 	char val[4];
@@ -359,7 +359,7 @@ static struct snd_card* create_card(struct usb_device* usb_dev)
 	return card;
 }
 
-static int init_card(struct snd_usb_caiaqdev *dev)
+static int __devinit init_card(struct snd_usb_caiaqdev *dev)
 {
 	char *c;
 	struct usb_device *usb_dev = dev->chip.dev;
@@ -428,7 +428,7 @@ static int init_card(struct snd_usb_caiaqdev *dev)
 	return 0;
 }
 
-static int snd_probe(struct usb_interface *intf, 
+static int __devinit snd_probe(struct usb_interface *intf, 
 		     const struct usb_device_id *id)
 {
 	int ret;
