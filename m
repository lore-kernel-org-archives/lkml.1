Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXIRITK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXIRITK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXIRISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:18:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbXIRISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:18:48 -0400
Date: Tue, 18 Sep 2007 01:18:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc6-mm1
Message-Id: <20070918011841.2381bd93.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/

2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.

It took me over two solid days to get this lot compiling and booting on a few
boxes.  This required around ninety fixup patches and patch droppings.  There
are several bugs in here which I know of (details below) and presumably many
more which I don't know of.  I have to say that this just isn't working any
more.

- The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
  I didn't drop that patch because the iommu patch series depends on it.

- The Vaio also hangs during resume-from-RAM, due to git-acpi.patch

- And it hangs during suspend-to-RAM, due to git-acpi.patch

- Huge churn in networking.  Many wireless drivers will be busted, and b44.c
  has been disabled altogether.  If you need b44, then good luck working out
  what was done to it.

- Added Peter's writeback balancing changes.  Might help people who are
  seeing large latency during heavy writeback.

- Major changes in the basically-unmaintained IPC code.  Needs careful
  testing and reviewing.

- Matthias fixed the mm-to-git importer, so the below-referenced git tree
  should hopefully be working again.

- Pleeeeeze do try to cc the appropriate developer(s) and mailing lists
  when reporting problems, thanks.


Boilerplate:

- See the `hot-fixes' directory for any important updates to this patchset.

- To fetch an -mm tree using git, use (for example)

  git-fetch git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git tag v2.6.16-rc2-mm1
  git-checkout -b local-v2.6.16-rc2-mm1 v2.6.16-rc2-mm1

- -mm kernel commit activity can be reviewed by subscribing to the
  mm-commits mailing list.

        echo "subscribe mm-commits" | mail majordomo@vger.kernel.org

- If you hit a bug in -mm and it is not obvious which patch caused it, it is
  most valuable if you can perform a bisection search to identify which patch
  introduced the bug.  Instructions for this process are at

        http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt

  But beware that this process takes some time (around ten rebuilds and
  reboots), so consider reporting the bug first and if we cannot immediately
  identify the faulty patch, then perform the bisection search.

- When reporting bugs, please try to Cc: the relevant maintainer and mailing
  list on any email.

- When reporting bugs in this kernel via email, please also rewrite the
  email Subject: in some manner to reflect the nature of the bug.  Some
  developers filter by Subject: when looking for messages to read.

- Occasional snapshots of the -mm lineup are uploaded to
  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/ and are announced on
  the mm-commits list.



Changes since 2.6.23-rc4-mm1:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-audit-master.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-jg-misc.patch
 git-kbuild.patch
 git-kvm.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-mtd.patch
 git-ubi.patch
 git-net.patch
 git-tehuti.patch
 git-backlight.patch
 git-nfs.patch
 git-nfsd.patch
 git-ocfs2.patch
 git-r8169.patch
 git-selinux.patch
 git-s390.patch
 git-sh.patch
 git-scsi-misc.patch
 git-block.patch
 git-unionfs.patch
 git-v9fs.patch
 git-watchdog.patch
 git-wireless.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch

 git trees

-quote-fix-infinite-loop.patch
-spi_mpc83xx-hang-fix.patch
-drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
-drivers-edac-fix-e752x-correct-return-code.patch
-bcm1480-serial-build-fix.patch
-pnp-remove-smcf010-quirk.patch
-update-gitignore.patch
-md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch
-mntput-called-before-dput-in-afs.patch
-fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch
-documentation-00-index-notice-ecryptfstxt-moved.patch
-x86_64-add-parenthesis-to-irq-vector-macros.patch
-h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
-alsa-cs5535audio-correctly-set-dma-substream.patch
-alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch
-alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch
-alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch
-alsa-cs5535audio-drop-unused-bus-master-stuff.patch
-arm-extern-inline-static-inline.patch
-arm-cleanup-struct-irqaction-initializers.patch
-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
-ivtv-fbc-bugfix.patch
-hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch
-pci-x-pci-express-read-control-interfaces-mthca.patch
-applesmc-switch-to-using-input-polldev.patch
-ams-switch-to-using-input-polldev.patch
-10-dots-braille-keyboards.patch
-de-dosify-iforce-protocoltxt.patch
-ide-mpc8xx-only-build-mpc8xx-on-arch_ppc.patch
-ide-ide-fix-pci-refcounting.patch
-ide-pdc202xx_new-fix-pci-refcounting.patch
-ide-hpt366-fix-pci-clock-detection-for-hpt374-take-4.patch
-ide-ide-add-ide_dev_is_sata-helper-take-2.patch
-ide-hpt366-ultradma-filter-for-sata-cards-take-2.patch
-ide-pdc202xx_new-pll-detection-fix.patch
-tty-add-the-new-ioctls-and-definitionto-the-mips.patch
-mips-qemu-network-work-again.patch
-drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
-ocfs2-warning-fix.patch
-gregkh-pci-pci-aer-fix-warnings-when-pcieaer-n.patch
-gregkh-pci-pci-remove-devinit-from-pci_read_bridge_bases.patch
-gregkh-pci-pci-remove-__devinit-from-pcibios_get_irq_routing_table.patch
-gregkh-pci-pci-unhide-smbus-on-compaq-deskpro-ep-401963-001-motherboard.patch
-gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing.patch
-gregkh-pci-pci-piggy-bus.patch
-use-menuconfig-objects-fusion.patch
-drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
-mpt-fusion-fix-two-potential-mem-leaks.patch
-message-fusion-remove-redundant-memset.patch
-hptiop-use-pci-vendor-symbol.patch
-drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
-hptiop-add-new-firmware-interface-and-more-pci-device-ids.patch
-git-unionfs-build-fix.patch
-gregkh-usb-usb-oti6858-remove-broken-ioctl-code-in-mm-tree-and-also-the-broken-fixes.patch
-gregkh-usb-usb-iphone-charge.patch
-git-wireless-printk-fixes.patch
-x86_64-mm-cflags-probe.patch
-x86_64-mm-less-stack-alignment.patch
-x86_64-mm-vdso-install-unstripped-copies-on-disk.patch
-x86_64-mm-vdso-do-something-more-with-unstripped-copies-on-disk.patch
-x86_64-mm-fix-leak-of-__-kernel-from-top-level-directory-in-makefile.patch
-x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
-x86_64-family-10h-and-11h-to-k8topology.patch
-x86_64-get-mp_bus_to_node-as-early-v3.patch
-x86_64-get-mp_bus_to_node-as-early-v3-update.patch
-x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
-try-parent-numa_node-at-first-before-using-default.patch
-net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
-i386-optimize-memset-of-6-and-8-bytes.patch
-intel_cacheinfo-misc-section-annotation-fixes-fix.patch
-git-xfs-build-fix.patch
-serio-fix-modpost-warning.patch
-nfs-fix-oops-re-sysctls-and-v4-support.patch
-pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch
-atl1-disable-broken-64-bit-dma.patch
-therm_throtc-fix-section-mismatch.patch
-paravirt-fix-preemptible-lazy-mode-bug.patch
-uml-use-64-bits-for-block-size-on-x86_64.patch

 Merged into mainline or a subsystem tree

+fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
+uml-use-correct-type-in-blkgetsize-ioctl.patch
+atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
+fix-failure-to-resume-from-initrds.patch
+fix-uts-corruption-during-cloneclone_newuts.patch
+rtc-ds1742c-should-use-resource_size_t-for-base-address.patch
+rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch
+mspec-handle-shrinking-virtual-memory-areas.patch
+mspec-handle-shrinking-virtual-memory-areas-3.patch
+pci-fix-unterminated-pci_device_id-lists.patch
+pci-fix-unterminated-pci_device_id-lists-fix.patch
+xen-dont-bother-trying-to-set-cr4.patch
+intelfb-fix-bug-in-dpll-disable.patch
+intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch
+dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
+nfs-fix-oops-re-sysctls-and-v4-support.patch
+disable-sys_timerfd-for-2623.patch

 2.6.23 queue

+ext34-ensure-do_split-leaves-enough-free-space-in-both-blocks.patch
+kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
+convert-uid-hash-to-hlist.patch
+fix-user-namespace-exiting-oops.patch
+fix-numa-memory-policy-reference-counting.patch

 2.6.23 maybe-queue

+git-acpi-fixup.patch

 Fix rejects in git-acpi.patch

+alsa-procfs-fix.patch
+git-alsa-sc6000-build-fix.patch
+generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
+ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch
+routines-for-effect-processor-fx8010-use-list_for_each_entry.patch

 alsa fixes

+arm-unbalanced-parenthesis-fix.patch

 arm fix

-git-powerpc-fixup.patch

 Unneeded

+powerpc-proper-defconfig-for-crosscompiles.patch
+powerpc-proper-defconfig-for-crosscompiles-fix.patch

 powerpc fixes

-gregkh-driver-block-device.patch
-revert-gregkh-driver-block-device.patch

 Dropped

+gregkh-driver-driver-core-add-config_uevent_helper_path.patch
+gregkh-driver-driver-core-remove-subsys_set_kset.patch
+gregkh-driver-driver-core-remove-kset_set_kset_s.patch
+gregkh-driver-driver-core-remove-subsys_put.patch
+gregkh-driver-driver-core-remove-subsys_get.patch
+gregkh-driver-driver-core-remove-put_bus.patch
+gregkh-driver-driver-core-remove-get_bus.patch
+gregkh-driver-kobjects-fix-up-improper-use-of-the-kobject-name-field.patch
+gregkh-driver-cdev-remove-unneeded-setting-of-cdev-names.patch
+gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
+gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
+gregkh-driver-driver-core-make-platform_deviceid-an-int.patch
+gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch

 driver tree updates

+fix-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
+fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
+fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
+fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
+drivers-char-nozomic-__devexit_p-usage-build-fix.patch

 Fix it

+git-dvb-build-fix.patch

 Fix git-dvb

+oops-in-pwc-v4l-driver.patch

 v4l fix

+jdelvare-i2c-i2c-pcf8574-no-init.patch
+jdelvare-i2c-i2c-document-i2c_msg.patch

 I2C tree updates

+i2c-i801-documentation-patch-for-intel-tolapai.patch
+i2c-i801-smbus-patch-for-intel-tolapai.patch
+i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
+bfin_twi-remove-useless-twi_lock-mutex.patch

 i2c stuff

+applesmc-for-mac-pro-2-x-quad-core.patch

 hwmon driver update (needs work)

+ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch

 Fix ia64-tree-wide-misc-__cpuinitdata-init-exit.patch

+ia64-perfmon-remove-exit_pfm_fs.patch

 ia64 fix

+git-input-fixup.patch

 Fix git-input.patch

-pass-g-to-assembler-under-config_debug_info.patch
-pass-g-to-assembler-under-config_debug_info-fix.patch

 These broek

+git-jg-misc-fix.patch

 Fix git-jg-isc

+git-kbuild-fixup.patch

 Fix git-kbuild.patch

+tristate-choices-with-mixed-tristate-and-boolean.patch

 kbuild tweak

+drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
+ahci-raid-mode-sata-patch-for-intel-tolapai.patch
+ata-increase-allowed-config-flags.patch
+ata_piix-replace-spaces-with-tabs.patch

 ata things

+ide-ide-pci-use-pci-dev-revision.patch
+ide-ide-use-io-ops-directly-part-2-take-2.patch
+ide-aec62xx-remove-init-setup.patch
+ide-cmd64x-remove-init-setup.patch
+ide-hpt366-remove-init-setup.patch
+ide-pdc202xx_new-remove-init-setup.patch
+ide-pdc202xx_old-remove-init-setup.patch
+ide-scc_pata-remove-init-setup.patch
+ide-serverworks-remove-init-setup.patch
+ide-ide-remove-init-setup-from-ide-pci-device-t.patch
+ide-aec62xx-no-need-to-disable-udma-in-init-hwif-method-for-atp850uf.patch
+ide-pdc202xx_new-add-declare-pdcnew-dev-macro.patch
+ide-pdc202xx_old-add-declare-pdc2026x-dev-macro.patch
+ide-piix-add-declare-ich-dev-macro.patch
+ide-ide-add-ide-hflag-error-stops-fifo.patch
+ide-ide-add-ide-hflag-serialize.patch
+ide-ide-add-ide-hflag-legacy-irqs.patch
+ide-alim15x3-always-tune-pio.patch
+ide-cs5520-always-tune-pio.patch
+ide-cy82c693-always-tune-pio.patch
+ide-opti621-always-tune-pio.patch
+ide-triflex-always-tune-pio.patch
+ide-ide-set-drive-autotune-in-ide-pci-setup-ports.patch
+ide-cmd64x-always-set-hwif-chipset-for-cmd646.patch
+ide-ide-fix-disabled-ports-reporting-for-pci-controllers.patch
+ide-rz1000-set-serialized-flag-only-if-mate-interface-exists.patch
+ide-serverworks-remove-dead-code-from-svwks-set-dma-mode.patch
+ide-ide-add-hwif-register-devices-helper.patch
+ide-ide-remove-unused-next-field-from-ide-pci-device-t.patch
+ide-ide-add-chipset-field-to-ide-pci-device-t.patch
+ide-ide-add-ide-hflag-force-legacy-irqs.patch
+ide-ide-add-ide-hflag-rqsize-256.patch
+ide-ide-add-ide-hflag-io-32bit-unmask-irqs-host-flags.patch

 IDE tree updates

+git-mips-fixup.patch

 Fix git-mips.patch

+mips-add-gpio-support-to-the-bcm947xx-platform-update.patch

 Fix mips-add-gpio-support-to-the-bcm947xx-platform.patch

+mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch

 Fix mmc tree for driver tree changes

-nommu-present-backing-device-capabilities-for-mtd.patch
-nommu-add-support-for-direct-mapping-through-mtdconcat.patch
-mtd-add-module-license-to-mtdbdi.patch

 Dropped

+blackfin-on-chip-nand-flash-controller-driver.patch

 MTD driver

-git-netdev-all.patch
-e1000e-build-fix.patch
+git-net.patch
+git-net-fixup.patch
+git-net-fix-2.patch
+nit-net-skge-build-fix.patch
-sundance-phy-address-form-0-only-for-device-id-0x0200.patch
+net-atm-lecc-printk-warning-fix.patch
+document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
+net-myri10ge-force-select-inet_lro.patch
+net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
+git-net-af_iucv-fixes.patch
+git-net-sgiseeq-fix.patch
+git-net-fix-ibmveth.patch
-uli526x-add-suspend-and-resume-routines.patch
-add-3c59x-maintainer.patch
-3c59x-check-return-of-pci_enable_device.patch
-ioc3-program-uart-predividers.patch
-sky2-fe-chip-support.patch
-sky2-use-debugfs-rename.patch
-sky2-document-gphy_ctrl-bits.patch
-sky2-dont-restrict-config-space-access.patch
-sky2-advanced-error-reporting.patch
-sky2-use-pci_config-access-functions.patch
-sky2-use-net_device-internal-stats.patch
-ktime_sub_ns-analog-of-ktime_add_ns.patch
-sky2-hardware-receive-timestamp-counter.patch
+skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
+fix-a-potential-null-pointer-dereference-in-uli526x_interrupt.patch
+sb1250-macc-de-typedef-de-volatile-de-etc.patch
+net_sb1250_mac-update-kconfig-entry.patch
+net_sb1250_mac-rename-to-sb1250_mac.patch
+ipg-add-ip1000a-driver-to-kernel-tree.patch
+git-net-broke-ipg-add-ip1000a-driver-to-kernel-tree.patch
+git-tehuti.patch
+git-tehuti-vs-git-net.patch
-git-net.patch
-git-net-fixup.patch
-net-atm-lecc-printk-warning-fix.patch
-e1000e-incorporate-napi_struct-changes-from-net-2624git.patch
+git-net-vs-git-wireless.patch
+git-net-vs-git-wireless-2.patch
+ath5k-panic-fix.patch
+git-net-vs-git-wireless-3.patch
+git-net-broke-git-wireless.patch
+iwl3945-is-bust.patch
+more-wireless-borkage.patch
+more-wireless-borkage-2.patch
+more-wireless-borkage-3.patch
+p54pci-terminate-pci-table.patch
+git-wireless-fix-99.patch
+git-wireless-b44-is-bust.patch

 Networking churn.  It is indescribable, so I won't.

+git-backlight-build-fix.patch
+git-backlight-dependency-fix.patch

 Fix git-backlight.patch

+git-net-vs-git-nfs.patch
+git-nfs-make-nfs_wb_page_priority-static.patch

 Fix git-nfs.patch

+git-nfsd-fixup.patch

 Fix git-nfsd.patch

+pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch
+add-support-for-pcmcia-card-sierra-wireless-ac850.patch
+introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
+pcmcia-use-dma_mask_none-for-the-default-for-all.patch

 pcmcia stuff

+wake-up-from-a-serial-port.patch

 Wake up machine over the serial port

+gregkh-pci-pci-fix-boot-time-hang-on-g31-g33-pc.patch
+gregkh-pci-cpqphp-use-pci_class_revision-instead-of-pci_revision_id-for-read.patch
+gregkh-pci-pci-quirk-amd_8131_mmrbc-omit-reading-pci-revision-id.patch
+gregkh-pci-pci-quirk_vt82c586_acpi-omit-reading-pci-revision-id.patch
+gregkh-pci-pci-re-enable-onboard-sound-on-msi-k8t-neo2-fir.patch

 PCI tree updates

+i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
+i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch

 PCI things

+sched-use-show_regs-to-improve-__schedule_bug-output.patch

 sched cleanup

+git-scsi-misc-fixup.patch
+git-scsi-misc-arcmsr-build-fix.patch

 fix git-scsi-misc

+scsi-early-detection-of-medium-not-present-updated.patch
+scsi-use-notifier-chain-for-asynchronous-event.patch

 scsi fixes

+git-block-fix-u14-34f.patch
+git-block-fix-qlogicpti-build.patch

 Fix git-block.patch

+sparc-fix-build-due-to-termios-changes.patch

 Now-unneeded sparc64 fix

+gregkh-usb-usb-remove-unneeded-pointer-intf-from-speedtch_upload_firmware.patch
+gregkh-usb-usb-fix-location-of-statement-label-in-dummy-hcd.patch
+gregkh-usb-usb-usb-storage-initialize-huawei-e220-properly.patch
+gregkh-usb-usb-elan-u132-host-controller-driver-convert-sw_lock-to-mutex.patch
+gregkh-usb-usb-fix-errornous-assumption-in-the-usb-serial-framework-revealed-by-iuu_phoenix.patch
+gregkh-usb-usb-sisusbvga-fix-bug-and-build-warnings.patch
+gregkh-usb-usb-amd5536-use-pdev-revision.patch
+gregkh-usb-usb-get-rid-of-annoying-endpoint-release-message.patch
+gregkh-usb-usb-move-decision-to-ignore-freeze-events.patch
+gregkh-usb-usb-break-apart-flush_endpoint-and-disable_endpoint.patch
+gregkh-usb-usb-flush-outstanding-urbs-when-suspending.patch
+gregkh-usb-usb-usb-serial-ch341c-make-4-functions-static.patch

 USB tree updates

-9p-build-fix.patch
-9p-is-bust.patch
-9p-is-still-bust.patch

 Unneeded

+x86_64-mm-defconfig-update.patch
+x86_64-mm-vdso-compat-install-unstripped-copies-on-disk.patch
+x86_64-mm-vdso-64bit-install-unstripped-copies-on-disk.patch
+x86_64-mm-implement-missing-x86_64-function-smp_call_function_mask.patch
+x86_64-mm-eliminate-result-signage-problem-in-asm-x86_64-bitops_h.patch
+x86_64-mm-add-parenthesis-to-irq-vector-macros.patch
+x86_64-mm-export-i386-smp_call_function_mask-to-modules.patch
+x86_64-mm-remove-duplicated-nsec-update.patch
+x86_64-mm-remove-stub-early_printk_c.patch
+x86_64-mm-honor-_page_pse-bit-on-page-walks.patch
+x86_64-mm-remove-some-dead-code.patch
+x86_64-mm-honor-notify_die-returning-notify_stop.patch
+x86_64-mm-optionally-show-last-exception-from-to-register-contents-v2.patch
+x86_64-mm-rename-_i-assembler-includes-to-_h.patch

 x86 tree updates

+voyager-include-asm-smph-to-fix-compile-error.patch
+therm_throtc-fix-section-mismatch.patch
+optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
+optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
+hpet-force-enable-on-vt8235-37-chipsets.patch
+x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
+x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
+x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
+x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
+x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
+i386-cpuid_count-fix-argument-signedness-warnings.patch
+voyager-dont-try-to-support-unprocessor-builds.patch
+i386-fix-section-mismatch-warning-in-intelc.patch
+x86-misc-constifications.patch
+x86-constify-wd_ops.patch
+x86-multi-byte-single-instruction-nops.patch

 x86 stuff

-hpet-force-enable-on-vt8235-37-chipsets.patch
-hpet-force-enable-on-vt8235-37-chipsets-fix.patch

 Dropped

+convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
+convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
+convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
+convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
+convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch

 per-cpuification

+scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host.patch
+x86_64-nx-bit-handling-in-change_page_attr.patch
+driver-core-fix-deprectated-sysfs-structure-for-nested-class-devices.patch

 Maybe-2.6.23 patches

+use-vm_read-write-exec-to-set-vm_page_prot.patch
+prevent-kswapd-from-freeing-excessive-amounts-of-lowmem.patch
+mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
+update-n_high_memory-node-state-for-memory-hotadd.patch
+update-n_high_memory-node-state-for-memory-hotadd-fix.patch
+fix-panic-of-cpu-online-with-memory-less-node.patch
+slub-do-not-use-page-mapping-fix.patch
+add-node-states-sysfs-class-attributes-v5.patch
+nfs-remove-congestion_end.patch
+lib-percpu_counter_add.patch
+lib-percpu_counter_sub.patch
+lib-percpu_counter-variable-batch.patch
+lib-make-percpu_counter_add-take-s64.patch
+lib-percpu_counter_set.patch
+lib-percpu_counter_sum_positive.patch
+lib-percpu_count_sum.patch
+lib-percpu_counter_init-error-handling.patch
+lib-percpu_counter_init_irq.patch
+mm-bdi-init-hooks.patch
+mm-scalable-bdi-statistics-counters.patch
+mm-count-reclaimable-pages-per-bdi.patch
+mm-count-writeback-pages-per-bdi.patch
+mm-expose-bdi-statistics-in-sysfs.patch
+lib-floating-proportions.patch
+mm-per-device-dirty-threshold.patch
+mm-per-device-dirty-threshold-warning-fix.patch
+mm-dirty-balancing-for-tasks.patch
+mm-dirty-balancing-for-tasks-warning-fix.patch
+debug-sysfs-files-for-the-current-ratio-size-total.patch
+slub-simplify-irq-off-handling.patch
+slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
+slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
+slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
+slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch

 MM updates

+alpha-convert-to-generic-sys_ptrace.patch

 alpha fix

+hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
+hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
+hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch

 PM updates

+m32r-serial-remove-m32r_sio_share_irqs.patch

 m32r cleanup

+uml-remove-unneeded-void-cast.patch
+uml-remove-unused-file.patch
+uml-more-idiomatic-parameter-parsing.patch

 UML updates

+i-oat-add-support-for-msi-and-msi-x-fix.patch

 Fix i-oat-add-support-for-msi-and-msi-x.patch

+softlockup-improve-debug-output-fix.patch

 Fix softlockup-improve-debug-output.patch

-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch

 Dropped

+ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch

 Fix ufs-fix-sun-state.patch

+i386-and-x86_64-randomize-brk.patch
+i386-and-x86_64-randomize-brk-fix.patch

 brk randomisation

+add-vmcore-cleanup-the-coding-style-according-to-andrews-comments.patch
+add-vmcore-add-nodemask_ts-size-and-nr_free_pagess-value-to-vmcoreinfo_data.patch
+add-vmcore-use-the-existing-ia64_tpa-instead-of-asm-code.patch
+add-vmcore-add-a-prefix-vmcoreinfo_-to-the-vmcoreinfo-macros.patch

 Fix add-vmcoreinfo.patch

+send-quota-messages-via-netlink-fix.patch
+send-quota-messages-via-netlink-fix-fix.patch

 Fix send-quota-messages-via-netlink.patch

+add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch

 Fix add-a-rounddown_pow_of_two-routine-to-log2h.patch

+handle-recursive-calls-to-bust_spinlocks.patch
+store-__setup_str_-in-a-more-compact-way.patch
+constify-string-array-kparam-tracking-structures.patch
+avoid-negative-and-full-width-shifts-in-radix-treec.patch
+futex_compat-simplify-pointer-magic.patch
+futex_compat-update-to-match-native-version.patch
+add-config_vt_unicode.patch
+update-checkpatchpl-to-version-010.patch
+pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
+i2o-fix-defined-but-not-used-build-warnings.patch
+i2o-fix-defined-but-not-used-build-warnings-fix.patch
+ipc-namespace-remove-config-ipc-ns-fix.patch
+spelling-fix-weired-weird.patch
+mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch
+dcache-trivial-comment-fix.patch
+procfs-detect-duplicate-names.patch
+procfs-detect-duplicate-names-fix.patch
+procfs-detect-duplicate-names-fix-fix-2.patch
+remove-dma_cache_wbackinvwback_inv-functions.patch
+maintainers-linux-omap-list-is-subscribers-only.patch
+try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
+keys-make-request_key-and-co-fundamentally-asynchronous.patch
+keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
+make-the-pr_-family-of-macros-in-kernelh-complete.patch
+doc-about-email-clients-for-linux-patches.patch
+jbd-slab-cleanups.patch
+reiserfs-fix-kernel-panic-on-corrupted-directory.patch
+lib-iomapcbad_io_access-print-0x-hex-prefix.patch
+lk201-remove-obsolete-driver.patch

 Misc

+ext2-reservations-fix-for-percpu_counter-changes.patch

 Update ext2-reservations.patch

+ecryptfs-use-generic_file_splice_read.patch

 ecryptfs update

+rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch
+rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
+rtc-pcf8583-check-for-i2c-adapter-functionality.patch

 rtc updates

+uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
+s3c2410fb-byte-ordering-fixes.patch
+intel-fb-support-for-interlaced-video-modes.patch
+fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
+nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch
+fbdev-support-for-byte-reversed-framebuffer-formats.patch
+ps3-fix-black-and-white-stripes.patch
+ps3fb-fix-spurious-mode-change-failures.patch
+fbdev-update-documentation-fb-00-index.patch
+tdfxfb-replace-busy-waiting-with-cpu_relax.patch
+pm2fb-replace-busy-waiting-with-cpu_relax.patch
+pm3fb-replace-busy-waiting-with-cpu_relax.patch
+tdfxfb-checkpatch-fixes.patch
+drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
+export-font_vga_8x16.patch

 fbdev updates

-drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch

 Folded into drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch

+bitmaph-remove-dead-artifacts.patch

 RAID cleanup

+slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch

 Fix revoke for slab changes

+documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
+add-a-missing-00-index-file-for-documentation-vm.patch
+add-a-00-index-file-to-documentation-mips.patch
+add-a-00-index-file-to-documentation-sysctl.patch
+add-a-00-index-file-to-documentation-telephony.patch
+kernel-doc-fix-doc-blocks-and-html.patch
+documentation-delete-unreferenced-xterm-linuxxpm-file.patch
+express-relocatability-of-kernel-on-x86_64-in-documentation.patch
+express-relocatability-of-kernel-on-x86_64-in.patch
+express-new-elf32-mechanisms-in-documentation.patch
+add-reset_devices-to-the-recommended-parameters.patch

 documentation

+sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch

 Fix sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch

+mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
+mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch

 mxser updates

+task-containersv11-basic-task-container-framework-containers-fix-refcount-bug.patch

 Fix task-containersv11-basic-task-container-framework-fix.patch

+task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch

 Fix task-containersv11-add-container_clone-interface.patch

+task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

 Fix task-containersv11-add-procfs-interface.patch

+task-containers-enable-containers-by-default-in-some-configs.patch

 Containers Kconfig tweak

-kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch

 Dropped (I think)

+memory-controller-memory-accounting-v7-fix.patch
+memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch

 Fix memory-controller-memory-accounting-v7.patch

+memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
+memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
+memory-controller-improve-user-interface.patch

 Fix memory-controller-add-per-container-lru-and-reclaim-v7.patch some more

+memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
+memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch

 Fix memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch

+memory-controller-make-charging-gfp-mask-aware.patch
+memory-controller-make-charging-gfp-mask-aware-fix.patch
+memory-controller-bug_on.patch

 Memory controller fixes

+cyclades-avoid-label-defined-but-not-used-warning.patch

 cyclades cleanup

+remove-asm-bitopsh-includes.patch
+forbid-asm-bitopsh-direct-inclusion.patch

 cleanups

 cyber2000fb-rename-bit-macro.patch
+cyber2000fb-checkpatch-fixes.patch

 More fbdev things

+use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch

 Fix use-helpers-to-obtain-task-pid-in-printks.patch

+alpha-lock-bitops-fix.patch

 Fix alpha-lock-bitops.patch

+powerpc-lock-bitops-fix.patch

 Fix powerpc-lock-bitops.patch

-fs-cramfs-inodec-remove-error-variable.patch

 Dropped

+ipc-store-ipcs-into-idrs.patch
+ipc-unify-the-syscalls-code.patch
+ipc-remove-the-ipc_get-routine.patch
+ipc-integrate-ipc_checkid-into-ipc_lock.patch
+ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
+storing-ipcs-into-idrs.patch
+ipc-introduce-the-ipcid_to_idx-macro.patch
+ipc-inline-ipc_buildid.patch

 Major IPC cleanups

+remove-asm-bitopsh-includes-reiser4.patch
+git-nfsd-broke-reiser4.patch
+slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch

 upbreak reiser4 for various things

+add-a-refcount-check-in-dput.patch

 New debug check.



4641 commits in 1872 patch files

All patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/patch-list


