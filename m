Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYAKIjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYAKIjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYAKIjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:39:15 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30440
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbYAKIjO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:39:14 -0500
Message-Id: <47873953.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:39:31 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, <tony.luck@intel.com>, <axboe@kernel.dk>,
       <gregkh@suse.de>, <dougthompson@xmission.com>
Subject: [PATCH 2/3] constify struct kobj_type's default_attrs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the EDAC code, I took the opportunity to replace the explicit cast
initializer with a safer, cast-less mechanism (as used elsewhere),
which makes this patch somewhat larger than it would have been
otherwise.

Again, the patch doesn't change all instances where 'const' could have
been added as a result of the base structure changes, only where the
change has a real effect (the module loader doesn't enforce read-only
section attributes at present, so only built-in files matter).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kobject.txt               |    2 -
 arch/ia64/kernel/topology.c             |    2 -
 arch/x86/kernel/cpu/intel_cacheinfo.c   |    2 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    2 -
 block/genhd.c                           |    2 -
 block/ll_rw_blk.c                       |    2 -
 drivers/block/pktcdvd.c                 |    4 +-
 drivers/cpufreq/cpufreq.c               |    2 -
 drivers/cpuidle/sysfs.c                 |    2 -
 drivers/edac/edac_device_sysfs.c        |   28 ++++++++---------
 drivers/edac/edac_mc_sysfs.c            |   50 ++++++++++++++++----------------
 drivers/edac/edac_pci_sysfs.c           |   24 +++++++--------
 drivers/firmware/edd.c                  |    2 -
 drivers/firmware/efivars.c              |    2 -
 fs/partitions/check.c                   |    2 -
 include/linux/kobject.h                 |    2 -
 16 files changed, 65 insertions(+), 65 deletions(-)

--- 2.6.24-rc7-const.orig/Documentation/kobject.txt
+++ 2.6.24-rc7-const/Documentation/kobject.txt
@@ -263,7 +263,7 @@ embedded in a subsystem itself. 
 struct kobj_type {
 	void (*release)(struct kobject *);
 	struct sysfs_ops	* sysfs_ops;
-	struct attribute	** default_attrs;
+	struct attribute	*const *default_attrs;
 };
 
 
--- 2.6.24-rc7-const.orig/arch/ia64/kernel/topology.c
+++ 2.6.24-rc7-const/arch/ia64/kernel/topology.c
@@ -242,7 +242,7 @@ define_one_ro(number_of_sets);
 define_one_ro(shared_cpu_map);
 define_one_ro(attributes);
 
-static struct attribute * cache_default_attrs[] = {
+static struct attribute *const cache_default_attrs[] = {
 	&type.attr,
 	&level.attr,
 	&coherency_line_size.attr,
--- 2.6.24-rc7-const.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 2.6.24-rc7-const/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -634,7 +634,7 @@ define_one_ro(number_of_sets);
 define_one_ro(size);
 define_one_ro(shared_cpu_map);
 
-static struct attribute * default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&type.attr,
 	&level.attr,
 	&coherency_line_size.attr,
--- 2.6.24-rc7-const.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ 2.6.24-rc7-const/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -348,7 +348,7 @@ RW_ATTR(interrupt_enable);
 RW_ATTR(threshold_limit);
 RW_ATTR(error_count);
 
-static struct attribute *default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&interrupt_enable.attr,
 	&threshold_limit.attr,
 	&error_count.attr,
--- 2.6.24-rc7-const.orig/block/genhd.c
+++ 2.6.24-rc7-const/block/genhd.c
@@ -502,7 +502,7 @@ static struct disk_attribute disk_attr_f
 
 #endif
 
-static struct attribute * default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&disk_attr_uevent.attr,
 	&disk_attr_dev.attr,
 	&disk_attr_range.attr,
--- 2.6.24-rc7-const.orig/block/ll_rw_blk.c
+++ 2.6.24-rc7-const/block/ll_rw_blk.c
@@ -4110,7 +4110,7 @@ static struct queue_sysfs_entry queue_io
 	.store = elv_iosched_store,
 };
 
-static struct attribute *default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
--- 2.6.24-rc7-const.orig/drivers/block/pktcdvd.c
+++ 2.6.24-rc7-const/drivers/block/pktcdvd.c
@@ -170,7 +170,7 @@ DEF_ATTR(kobj_pkt_attr_st4, "kb_written"
 DEF_ATTR(kobj_pkt_attr_st5, "kb_read", 0444);
 DEF_ATTR(kobj_pkt_attr_st6, "kb_read_gather", 0444);
 
-static struct attribute *kobj_pkt_attrs_stat[] = {
+static struct attribute *const kobj_pkt_attrs_stat[] = {
 	&kobj_pkt_attr_st1,
 	&kobj_pkt_attr_st2,
 	&kobj_pkt_attr_st3,
@@ -184,7 +184,7 @@ DEF_ATTR(kobj_pkt_attr_wq1, "size", 0444
 DEF_ATTR(kobj_pkt_attr_wq2, "congestion_off", 0644);
 DEF_ATTR(kobj_pkt_attr_wq3, "congestion_on",  0644);
 
-static struct attribute *kobj_pkt_attrs_wqueue[] = {
+static struct attribute *const kobj_pkt_attrs_wqueue[] = {
 	&kobj_pkt_attr_wq1,
 	&kobj_pkt_attr_wq2,
 	&kobj_pkt_attr_wq3,
--- 2.6.24-rc7-const.orig/drivers/cpufreq/cpufreq.c
+++ 2.6.24-rc7-const/drivers/cpufreq/cpufreq.c
@@ -625,7 +625,7 @@ define_one_rw(scaling_min_freq);
 define_one_rw(scaling_max_freq);
 define_one_rw(scaling_governor);
 
-static struct attribute * default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&cpuinfo_min_freq.attr,
 	&cpuinfo_max_freq.attr,
 	&scaling_min_freq.attr,
--- 2.6.24-rc7-const.orig/drivers/cpuidle/sysfs.c
+++ 2.6.24-rc7-const/drivers/cpuidle/sysfs.c
@@ -233,7 +233,7 @@ define_one_state_ro(power, show_state_po
 define_one_state_ro(usage, show_state_usage);
 define_one_state_ro(time, show_state_time);
 
-static struct attribute *cpuidle_state_default_attrs[] = {
+static struct attribute *const cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
 	&attr_latency.attr,
 	&attr_power.attr,
--- 2.6.24-rc7-const.orig/drivers/edac/edac_device_sysfs.c
+++ 2.6.24-rc7-const/drivers/edac/edac_device_sysfs.c
@@ -161,11 +161,11 @@ CTL_INFO_ATTR(poll_msec, S_IRUGO | S_IWU
 	edac_device_ctl_poll_msec_show, edac_device_ctl_poll_msec_store);
 
 /* Base Attributes of the EDAC_DEVICE ECC object */
-static struct ctl_info_attribute *device_ctrl_attr[] = {
-	&attr_ctl_info_panic_on_ue,
-	&attr_ctl_info_log_ue,
-	&attr_ctl_info_log_ce,
-	&attr_ctl_info_poll_msec,
+static struct attribute *const device_ctrl_attr[] = {
+	&attr_ctl_info_panic_on_ue.attr,
+	&attr_ctl_info_log_ue.attr,
+	&attr_ctl_info_log_ce.attr,
+	&attr_ctl_info_poll_msec.attr,
 	NULL,
 };
 
@@ -215,7 +215,7 @@ static void edac_device_ctrl_master_rele
 static struct kobj_type ktype_device_ctrl = {
 	.release = edac_device_ctrl_master_release,
 	.sysfs_ops = &device_ctl_info_ops,
-	.default_attrs = (struct attribute **)device_ctrl_attr,
+	.default_attrs = device_ctrl_attr,
 };
 
 /*
@@ -401,9 +401,9 @@ INSTANCE_ATTR(ce_count, S_IRUGO, instanc
 INSTANCE_ATTR(ue_count, S_IRUGO, instance_ue_count_show, NULL);
 
 /* list of edac_dev 'instance' attributes */
-static struct instance_attribute *device_instance_attr[] = {
-	&attr_instance_ce_count,
-	&attr_instance_ue_count,
+static struct attribute *const device_instance_attr[] = {
+	&attr_instance_ce_count.attr,
+	&attr_instance_ue_count.attr,
 	NULL,
 };
 
@@ -411,7 +411,7 @@ static struct instance_attribute *device
 static struct kobj_type ktype_instance_ctrl = {
 	.release = edac_device_ctrl_instance_release,
 	.sysfs_ops = &device_instance_ops,
-	.default_attrs = (struct attribute **)device_instance_attr,
+	.default_attrs = device_instance_attr,
 };
 
 /* edac_dev -> instance -> block information */
@@ -499,9 +499,9 @@ BLOCK_ATTR(ce_count, S_IRUGO, block_ce_c
 BLOCK_ATTR(ue_count, S_IRUGO, block_ue_count_show, NULL);
 
 /* list of edac_dev 'block' attributes */
-static struct edac_dev_sysfs_block_attribute *device_block_attr[] = {
-	&attr_block_ce_count,
-	&attr_block_ue_count,
+static struct attribute *const device_block_attr[] = {
+	&attr_block_ce_count.attr,
+	&attr_block_ue_count.attr,
 	NULL,
 };
 
@@ -509,7 +509,7 @@ static struct edac_dev_sysfs_block_attri
 static struct kobj_type ktype_block_ctrl = {
 	.release = edac_device_ctrl_block_release,
 	.sysfs_ops = &device_block_ops,
-	.default_attrs = (struct attribute **)device_block_attr,
+	.default_attrs = device_block_attr,
 };
 
 /* block ctor/dtor  code */
--- 2.6.24-rc7-const.orig/drivers/edac/edac_mc_sysfs.c
+++ 2.6.24-rc7-const/drivers/edac/edac_mc_sysfs.c
@@ -267,13 +267,13 @@ CSROWDEV_ATTR(ue_count, S_IRUGO, csrow_u
 CSROWDEV_ATTR(ce_count, S_IRUGO, csrow_ce_count_show, NULL, 0);
 
 /* default attributes of the CSROW<id> object */
-static struct csrowdev_attribute *default_csrow_attr[] = {
-	&attr_dev_type,
-	&attr_mem_type,
-	&attr_edac_mode,
-	&attr_size_mb,
-	&attr_ue_count,
-	&attr_ce_count,
+static struct attribute *const default_csrow_attr[] = {
+	&attr_dev_type.attr,
+	&attr_mem_type.attr,
+	&attr_edac_mode.attr,
+	&attr_size_mb.attr,
+	&attr_ue_count.attr,
+	&attr_ce_count.attr,
 	NULL,
 };
 
@@ -365,7 +365,7 @@ static void edac_csrow_instance_release(
 static struct kobj_type ktype_csrow = {
 	.release = edac_csrow_instance_release,
 	.sysfs_ops = &csrowfs_ops,
-	.default_attrs = (struct attribute **)default_csrow_attr,
+	.default_attrs = default_csrow_attr,
 };
 
 /* Create a CSROW object under specifed edac_mc_device */
@@ -609,16 +609,16 @@ MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_co
 MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
 	mci_sdram_scrub_rate_store);
 
-static struct mcidev_sysfs_attribute *mci_attr[] = {
-	&mci_attr_reset_counters,
-	&mci_attr_mc_name,
-	&mci_attr_size_mb,
-	&mci_attr_seconds_since_reset,
-	&mci_attr_ue_noinfo_count,
-	&mci_attr_ce_noinfo_count,
-	&mci_attr_ue_count,
-	&mci_attr_ce_count,
-	&mci_attr_sdram_scrub_rate,
+static struct attribute *const mci_attr[] = {
+	&mci_attr_reset_counters.attr,
+	&mci_attr_mc_name.attr,
+	&mci_attr_size_mb.attr,
+	&mci_attr_seconds_since_reset.attr,
+	&mci_attr_ue_noinfo_count.attr,
+	&mci_attr_ce_noinfo_count.attr,
+	&mci_attr_ue_count.attr,
+	&mci_attr_ce_count.attr,
+	&mci_attr_sdram_scrub_rate.attr,
 	NULL
 };
 
@@ -651,7 +651,7 @@ static void edac_mci_control_release(str
 static struct kobj_type ktype_mci = {
 	.release = edac_mci_control_release,
 	.sysfs_ops = &mci_ops,
-	.default_attrs = (struct attribute **)mci_attr,
+	.default_attrs = mci_attr,
 };
 
 /* show/store, tables, etc for the MC kset */
@@ -724,11 +724,11 @@ MEMCTRL_ATTR(edac_mc_poll_msec,
 	S_IRUGO | S_IWUSR, memctrl_int_show, poll_msec_int_store);
 
 /* Base Attributes of the memory ECC object */
-static struct memctrl_dev_attribute *memctrl_attr[] = {
-	&attr_edac_mc_panic_on_ue,
-	&attr_edac_mc_log_ue,
-	&attr_edac_mc_log_ce,
-	&attr_edac_mc_poll_msec,
+static struct attribute *const memctrl_attr[] = {
+	&attr_edac_mc_panic_on_ue.attr,
+	&attr_edac_mc_log_ue.attr,
+	&attr_edac_mc_log_ce.attr,
+	&attr_edac_mc_poll_msec.attr,
 	NULL,
 };
 
@@ -736,7 +736,7 @@ static struct memctrl_dev_attribute *mem
 /* the ktype for the mc_kset internal kobj */
 static struct kobj_type ktype_mc_set_attribs = {
 	.sysfs_ops = &memctrlfs_ops,
-	.default_attrs = (struct attribute **)memctrl_attr,
+	.default_attrs = memctrl_attr,
 };
 
 /* EDAC memory controller sysfs kset:
--- 2.6.24-rc7-const.orig/drivers/edac/edac_pci_sysfs.c
+++ 2.6.24-rc7-const/drivers/edac/edac_pci_sysfs.c
@@ -137,9 +137,9 @@ INSTANCE_ATTR(pe_count, S_IRUGO, instanc
 INSTANCE_ATTR(npe_count, S_IRUGO, instance_npe_count_show, NULL);
 
 /* pci instance attributes */
-static struct instance_attribute *pci_instance_attr[] = {
-	&attr_instance_pe_count,
-	&attr_instance_npe_count,
+static struct attribute *const pci_instance_attr[] = {
+	&attr_instance_pe_count.attr,
+	&attr_instance_npe_count.attr,
 	NULL
 };
 
@@ -147,7 +147,7 @@ static struct instance_attribute *pci_in
 static struct kobj_type ktype_pci_instance = {
 	.release = edac_pci_instance_release,
 	.sysfs_ops = &pci_instance_ops,
-	.default_attrs = (struct attribute **)pci_instance_attr,
+	.default_attrs = pci_instance_attr,
 };
 
 /*
@@ -300,13 +300,13 @@ EDAC_PCI_ATTR(pci_parity_count, S_IRUGO,
 EDAC_PCI_ATTR(pci_nonparity_count, S_IRUGO, edac_pci_int_show, NULL);
 
 /* Base Attributes of the memory ECC object */
-static struct edac_pci_dev_attribute *edac_pci_attr[] = {
-	&edac_pci_attr_check_pci_errors,
-	&edac_pci_attr_edac_pci_log_pe,
-	&edac_pci_attr_edac_pci_log_npe,
-	&edac_pci_attr_edac_pci_panic_on_pe,
-	&edac_pci_attr_pci_parity_count,
-	&edac_pci_attr_pci_nonparity_count,
+static struct attribute *const edac_pci_attr[] = {
+	&edac_pci_attr_check_pci_errors.attr,
+	&edac_pci_attr_edac_pci_log_pe.attr,
+	&edac_pci_attr_edac_pci_log_npe.attr,
+	&edac_pci_attr_edac_pci_panic_on_pe.attr,
+	&edac_pci_attr_pci_parity_count.attr,
+	&edac_pci_attr_pci_nonparity_count.attr,
 	NULL,
 };
 
@@ -334,7 +334,7 @@ static void edac_pci_release_main_kobj(s
 static struct kobj_type ktype_edac_pci_main_kobj = {
 	.release = edac_pci_release_main_kobj,
 	.sysfs_ops = &edac_pci_sysfs_ops,
-	.default_attrs = (struct attribute **)edac_pci_attr,
+	.default_attrs = edac_pci_attr,
 };
 
 /**
--- 2.6.24-rc7-const.orig/drivers/firmware/edd.c
+++ 2.6.24-rc7-const/drivers/firmware/edd.c
@@ -587,7 +587,7 @@ static EDD_DEVICE_ATTR(mbr_signature, 04
 /* These are default attributes that are added for every edd
  * device discovered.  There are none.
  */
-static struct attribute * def_attrs[] = {
+static struct attribute *const def_attrs[] = {
 	NULL,
 };
 
--- 2.6.24-rc7-const.orig/drivers/firmware/efivars.c
+++ 2.6.24-rc7-const/drivers/firmware/efivars.c
@@ -393,7 +393,7 @@ static EFIVAR_ATTR(size, 0400, efivar_si
 static EFIVAR_ATTR(data, 0400, efivar_data_read, NULL);
 static EFIVAR_ATTR(raw_var, 0600, efivar_show_raw, efivar_store_raw);
 
-static struct attribute *def_attrs[] = {
+static struct attribute *const def_attrs[] = {
 	&efivar_attr_guid.attr,
 	&efivar_attr_size.attr,
 	&efivar_attr_attributes.attr,
--- 2.6.24-rc7-const.orig/fs/partitions/check.c
+++ 2.6.24-rc7-const/fs/partitions/check.c
@@ -304,7 +304,7 @@ static struct part_attribute part_attr_f
 
 #endif
 
-static struct attribute * default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&part_attr_uevent.attr,
 	&part_attr_dev.attr,
 	&part_attr_start.attr,
--- 2.6.24-rc7-const.orig/include/linux/kobject.h
+++ 2.6.24-rc7-const/include/linux/kobject.h
@@ -102,7 +102,7 @@ extern char * kobject_get_path(struct ko
 struct kobj_type {
 	void (*release)(struct kobject *);
 	struct sysfs_ops	* sysfs_ops;
-	struct attribute	** default_attrs;
+	struct attribute	*const *default_attrs;
 };
 
 struct kobj_uevent_env {


