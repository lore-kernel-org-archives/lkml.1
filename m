Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbXF1Knq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbXF1Knq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXF1Kne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:43:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145AbXF1Knb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:43:31 -0400
Date: Thu, 28 Jun 2007 03:43:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc6-mm1
Message-Id: <20070628034321.38c9f12b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/

- NOTE (an uppercase one, indeed): there are a lot of menuconfig changes in
  here which break `make oldconfig' badly.  If you grab an old .config and run
  `make oldconfig', your kernel probably won't work.  I lost useful things
  like CONFIG_BLK_DEV and the whole SCSI system, because they were added after
  I generated my .config.

  So save yourself some hassle and check your .config carefully before
  building this kernel.  Make sure that everything you need is still enabled.

  I found that manually adding "CONFIG_BLK_DEV=y" to the .config before
  running oldconfig saved a large number of config items from getting lost.

  Those menuconfig changes have been a huge pain.

- Added the kgdb tree, as git-kgdb.patch (Jason Wessel
  <jason.wessel@windriver.com>)

  This is a large patch which unifies all the various kgdb stubs lying
  around various architectures and extends kgdb support to other
  architectures.  Supported architectures are at present arm, i386, ia64,
  mips, ppc32, ppc64, sh, and x86_64.

  Subject to review, we're aiming this at 2.6.24.

- Jean's hwmon git tree was dropped and was replaced by the new
  git-hwmon.patch (Mark M.  Hoffman <mhoffman@lightlink.com>)

- Added new git-ixgbe.patch: "10GbE driver for Intel 82598 based PCI Express
  adapters" (Ayyappan Veeraiyan <ayyappan.veeraiyan@intel.com>)

- I cannot persuade git to generate a sane diff out of git-wireless, so it
  is dropped.  Which is bad, because it contains a tremendous amount of stuff.

- Added x86_64 dynticks support

- Merged the dynamic commandline length patches - these remove Linux's
  hard-coded limit.



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




Changes since 2.6.22-rc4-mm2:


 origin.patch
 git-acpi.patch
 git-alsa.patch
 git-arm.patch
 git-avr32.patch
 git-cifs.patch
 git-cpufreq.patch
 git-powerpc.patch
 git-drm.patch
 git-dvb.patch
 git-hwmon.patch
 git-gfs2-nmw.patch
 git-hid.patch
 git-ia64.patch
 git-ieee1394.patch
 git-infiniband.patch
 git-input.patch
 git-jfs.patch
 git-kbuild.patch
 git-kvm.patch
 git-leds.patch
 git-libata-all.patch
 git-md-accel.patch
 git-mips.patch
 git-mmc.patch
 git-ubi.patch
 git-netdev-all.patch
 git-ixgbe.patch
 git-net.patch
 git-backlight.patch
 git-battery.patch
 git-ioat.patch
 git-nfs.patch
 git-ocfs2.patch
 git-selinux.patch
 git-s390.patch
 git-scsi-misc.patch
 git-scsi-target.patch
 git-unionfs.patch
 git-watchdog.patch
 git-ipwireless_cs.patch
 git-newsetup.patch
 git-newsetup-fixup.patch
 git-xfs.patch
 git-cryptodev.patch
 git-kgdb.patch
 git-gccbug.patch

 git trees

-update-checkpatchpl-to-version-003.patch
-m68knommu-fix-coldfire-timer-off-by-1.patch
-nommu-report-correct-errno-in-message.patch
-loop-preallocate-eight-loop-devices.patch
-document-acked-by.patch
-pi-futex-fixes.patch
-update-feature-removal-scheduletxt-to-include-deprecated-functions.patch
-mount-t-tmpfs-o-mpol=-check-nodes-online.patch
-slab-fix-alien-cache-handling.patch
-potential-parse-error-in-ifdef-part-3.patch
-slub-return-zero_size_ptr-for-kmalloc0.patch
-ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch
-uml-fix-kernel-stack-size-on-x86_64.patch
-documentation-atomic_opstxt.patch
-move-three-functions-that-are-only-needed-for.patch
-char-stallion-dont-fail-with-less-than-max-panels.patch
-char-stallion-alloc-tty-before-pci-devices-init.patch
-char-stallion-proper-fail-return-values.patch
-frv-build-fix.patch
-uml-get-declaration-of-simple_strtoul.patch
-isdn-diva-fix-section-mismatch.patch
-checkpatch-produce-fewer-lines-of-output.patch
-git-acpi-disable-acpi_processor_throttling_seq_show.patch
-toshica_acpi-fix-section-mismatch-in-allyesconfig.patch
-yet-another-uniwill-laptop-with-alc861-codec.patch
-intel_agp-cleanup-intel-private-data.patch
-intel_agp-cleanup-intel-private-data-update.patch
-intel_agp-use-table-for-device-probe.patch
-intel_agp-use-table-for-device-probe-update.patch
-intel_agp-add-support-for-965gme-gle.patch
-intel_agp-add-support-for-945gme.patch
-intel_agp-add-support-for-g33-q33-and-q35-chipsets.patch
-dm-add-missing-braces-in-driver-debug-code.patch
-do-not-select-macintosh-drivers-by-default.patch
-gregkh-driver-update-documentation-driver-model-platformtxt.patch
-gregkh-driver-driver-core-keep-physdev-for-old-struct-class_device.patch
-gregkh-driver-driver-core-kill-unused-code.patch
-fix-2-gregkh-driver-dmi-based-module-autoloading.patch
-git-dvb-fix-the-tea5761-tuner-support.patch
-i2c-tsl2550-support.patch
-i2c-iop3xx-switch-to-static-adapter-numbering.patch
-thecus-n2100-register-rtc-rs5c372-i2c-device.patch
-git-input-make-xpad_play_effect-static.patch
-ide-serverworks-remove-crappy-code.patch
-ide-serverworks-fix-csb6-tuning-logic.patch
-ide-it821x-raid-mode-fixes.patch
-ide-ide-hpa-detect-from-resume.patch
-ide-ide-generic-add-another-device-exception.patch
-use-menuconfig-objects-ii-netdev-general100mbit.patch
-ppp_mppe-account-for-osize-too-small-errors-in.patch
-unexport-pci_proc_attach_device.patch
-s390-spinlock-initializer-cleanup.patch
-gregkh-usb-usb-set-default-y-for-config_usb_device_class.patch
-gregkh-usb-usblp-don-t-let-suspend-to-kill-used.patch
-gregkh-usb-usb-usb-gadgets-avoid-le-16-32-_to_cpup.patch
-gregkh-usb-usb-unusual_dev-sync-up-some-reported-devices-from-ubuntu.patch
-gregkh-usb-usb-cxacru-add-documentation-file.patch
-gregkh-usb-usb-cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch
-gregkh-usb-usb-cxacru-ignore-error-trying-to-start-adsl-in-atm_start.patch
-gregkh-usb-ohci-fix-machine-check-in-ohci_hub_status_data.patch
-gregkh-usb-usb-ti-serial-driver-sleeps-with-spinlock-held.patch
-gregkh-usb-usb-stimulus.patch
-usb-try-to-debug-bug-8561.patch
-usb-bugfix-gfp_kernel-gfp_atomic-in-spin_locked-region.patch
-usb-serial-fix-something.patch
-add-pci_try_set_mwi-prism54pci.patch
-mac80211-fix-1-bit-bitfield-to-unsigned.patch
-x86_64-mm-via-no-dac.patch
-x86_64-mm-compat-syscall-u64.patch
-x86_64-mm-disable-watchdog.patch
-x86_64-mm-fix-eventd-syscall.patch
-x86_64-mm-mtrr-sections.patch
-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
-fix-x86_64-mm-xen-core-xen-implementation.patch
-i386-hpet-check-if-the-counter-works.patch
-paravirt-helper-to-disable-all-io-space.patch
-xen-disable-all-non-virtual-devices.patch
-x86_64-use-null-for-pointer.patch
-ext3-lost-brelse-in-ext3_read_inode.patch
-ext4-lost-brelse-in-ext4_read_inode.patch
-acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
-sata_promise-use-tf-interface-for-polling-nodata-commands.patch
-rework-ptep_set_access_flags-and-fix-sun4c.patch
-rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
-rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
-rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch
-unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
-hexdump-more-output-formatting.patch
-tidy-up-usermode-helper-waiting-a-bit-fix.patch
-volatile-considered-harmful-take-3.patch
-cobalt-remove-all-traces-of-cobalt-from-nvramc.patch
-ffb-the-pseudo_palette-is-only-16-elements-long.patch
-sunxvr2500fb-fix-pseudo_palette-array-size.patch
-sunxvr500fb-fix-pseudo_palette-array-size.patch
-i386-set-6-bit-dac-channel-properties-in-vesa-video.patch

 Merged into mainline or a subsystem tree

+ecryptfs-fix-write-zeros-behavior.patch
+ecryptfs-initialize-crypt_stat-in-setattr.patch
+ecryptfs-zero-out-last-page-for-llseek-write.patch
+atyfb-fix-xclk-frequency-on-apple-ibook1.patch
+eventfd-clean-compile-when-config_eventfd=n.patch
+mtrr-cyrix-fix-sections.patch
+smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch
+pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch
+mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
+fix-kconfig-dependency-problems-wrt-boolean-menuconfigs.patch
+ioatdma-fix-section-mismatches.patch
+alsa-fix-ice1712-section-mismatch.patch
+saa7134-fix-thread-shutdown-handling.patch
+avoid-spurious-pollin-returns-in-signalfd.patch
+fix-section-mismatch-in-chipsfb.patch
+documentation-howto-update-urls-of-git-trees.patch
+alsa-use-__devexit_p.patch
+relay-file-read-start-pos-fixpatch.patch
+relayfs-fix-overwrites.patch
+w1_therm_read_bin-suspicious-usage-of-flush_signals.patch
+mips-jazz-correct-flags-for-timer-io-resource.patch
+add-some-pci-ids-for-xgi-chips.patch
+ext2-fix-return-of-uninitialised-variable.patch
+serial-clear-proper-mpsc-interrupt-cause-bits.patch
+introduce-fixed-sys_sync_file_range2-syscall-implement-on.patch
+slab-remove-warn_on_once-for-zero-sized-objects-for-2622-release.patch

 2.6.22 queue

+always-probe-the-nmi-watchdog.patch
+linux-hpet-issue-with-amd-southbridges.patch

 x86 fixes

+serial-assert-dtr-for-serial-console-devices.patch

 serial fix

+git-acpi-fixup.patch

 Fix rejects in git-acpi

+git-acpi-ia64-build-fix.patch

 Fix git-acpi

+cpuidle-menu-governor-and-hrtimer-compile-fix.patch
+cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
+cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
+cpuidle-menu-governor-change-the-early-break-condition.patch
+cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
+cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
+cpuidle-first-round-of-documentation-updates.patch

 cpuidle updates

+acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch
+make-drivers-acpi-oslcosi_linux-static.patch
+drivers-acpi-processor_throttlingc-make-2-functions.patch
+drivers-cpuidle-governors-menuc-make-a-struct-static.patch
+fix-empty-macros-in-acpi.patch
+drivers-acpi-sbsc-remove-dead-code.patch
+remove-leftover-documentation-of-acpi_generic_hotkey.patch

 acpi fixes

+cifs-zero_user_page-conversion.patch

 cifs cleanup

-agk-dm-dm-use-singlethread-workqueues.patch
+agk-dm-dm-use-singlethread-workqueues.patch
+agk-dm-dm-snapshot-fix-invalidation-deadlock.patch
+agk-dm-dm-snapshot-permit-invalid-activation.patch
+agk-dm-dm-raid1-clear-region-outside-spinlock.patch
+agk-dm-dm-netlink.patch
+agk-dm-dm-netlink-add-to-core.patch
+agk-dm-dm-netlink-mpath.patch
+agk-dm-dm-mpath-rdac.patch

 device mapper tree updates

+powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
+powerpc-tlb_32c-build-fix.patch

 powerpc stuff

+gregkh-driver-sysfs-rules.patch
+gregkh-driver-pm-remove-pm_parent-from-struct-dev_pm_info.patch
+gregkh-driver-pm-remove-saved_state-from-struct-dev_pm_info.patch
+gregkh-driver-pm-simplify-suspend_device.patch
+gregkh-driver-driver-core-include-linux-mutexh-from-attribute_containerc.patch
+gregkh-driver-driver-core-properly-get-driver-in-device_release_driver.patch
+gregkh-driver-driver-core-fix-kernel-doc-of-device_release_driver.patch
+gregkh-driver-driver-core-fix-devres_release_all-return-value.patch
+gregkh-driver-pm-remove-prev_state-from-struct-dev_pm_info.patch
+gregkh-driver-pm-remove-power_stateevent-checks-from-suspend-core-code.patch
+gregkh-driver-pm-do-not-check-parent-state-in-suspend-and-resume-core-code.patch
+gregkh-driver-howto-translated-into-japanese.patch
+gregkh-driver-add-japanese-translated-stable_api_nonsensetxt.patch
+gregkh-driver-howto-add-chinese-translation-of-documentation-howto.patch
+gregkh-driver-chinese-translation-of-documentation-stable_api_nonsensetxt.patch
-gregkh-driver-sysfs-reimplement-syfs_drop_dentry.patch
+gregkh-driver-sysfs-reimplement-sysfs_drop_dentry.patch
+gregkh-driver-sysfs-fix-oops-in-sysfs_drop_dentry-on-x86_64.patch
+gregkh-driver-sysfs-make-sysfs_drop_dentry-access-inodes-using-ilookup.patch
+gregkh-driver-sysfs-rename-sysfs_dirent-s_type-to-s_flags-and-make-room-for-flags.patch
+gregkh-driver-sysfs-implement-sysfs_flag_removed-flag.patch
+gregkh-driver-sysfs-implement-sysfs_find_dirent-and-sysfs_get_dirent.patch
+gregkh-driver-sysfs-make-kobj-point-to-sysfs_dirent-instead-of-dentry.patch
+gregkh-driver-sysfs-consolidate-sysfs-spinlocks.patch
+gregkh-driver-sysfs-use-sysfs_mutex-to-protect-the-sysfs_dirent-tree.patch
+gregkh-driver-sysfs-restructure-add-remove-paths-and-fix-inode-update.patch
+gregkh-driver-sysfs-move-sysfs_drop_dentry-to-dirc-and-make-it-static.patch
+gregkh-driver-sysfs-implement-sysfs_get_dentry.patch
+gregkh-driver-sysfs-make-directory-dentries-and-inodes-reclaimable.patch

 driver tree udpates

+fix-gregkh-driver-nozomi.patch

 Fix it.

+pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch

 PM update (might break arm)

+revert-saa7134-fix-thread-shutdown-handling.patch

 Make git-dvb apply

+dvb-saa7134-dependency-fix.patch

 dvb fix

+jdelvare-i2c-i2c-sis5595-resolve-resource-conflict.patch
+jdelvare-i2c-i2c-kill-struct-i2c_device_id.patch
+jdelvare-i2c-i2c-iop3xx-numbered-adapter.patch
+jdelvare-i2c-i2c-gpio-add-support-for-new-style-clients.patch
+jdelvare-i2c-i2c-gpio-make-some-internal-functions-static.patch
+jdelvare-i2c-i2c-pxa-numbered-adapter.patch
+jdelvare-i2c-i2c-tsl2550-support.patch
+jdelvare-i2c-i2c-i801-cleanups.patch
+jdelvare-i2c-i2c-i801-use-block-buffer.patch
+jdelvare-i2c-i2c-taos-evm-new-driver.patch
+jdelvare-i2c-i2c-tsl2550-faster-init.patch

 I2C tree updates

-jdelvare-hwmon-hwmon-new-maintainer.patch
-jdelvare-hwmon-hwmon-lm90-spelling-fix-explicitly.patch
-jdelvare-hwmon-hwmon-smsc47m192-use-mutex-instead-of-semaphore.patch
-jdelvare-hwmon-hwmon-ds1621-cleanups.patch
-jdelvare-hwmon-hwmon-ds1621-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-ds1621-individual-alarm-files.patch
-jdelvare-hwmon-hwmon-dme1737-new-driver.patch
-jdelvare-hwmon-hwmon-dme1737-documentation.patch
-jdelvare-hwmon-hwmon-pc87360-to-platform-driver.patch
-jdelvare-hwmon-hwmon-use-platform_device_add_data.patch
-jdelvare-hwmon-hwmon-lm90-add-max6681-support.patch
-jdelvare-hwmon-hwmon-fault-file-name.patch
-jdelvare-hwmon-hwmon-it87-add-it8726f-support.patch
-jdelvare-hwmon-hwmon-w83627hf-pwm-freq-support.patch
-jdelvare-hwmon-hwmon-via686a-fix-temperature-interrupt-mode.patch
-jdelvare-hwmon-hwmon-via686a-to-platform-driver.patch
-jdelvare-hwmon-hwmon-via686a-dynamic-attributes.patch
-jdelvare-hwmon-hwmon-sis5595-to-platform-driver.patch
-jdelvare-hwmon-hwmon-sis5595-dynamic-attributes.patch

 hwmon tree got dropped

+git-gfs2-nmw-build-fix.patch

 Fix git-gfs2-nmw.patch

-git-input-fixup.patch

 Unneeded

+serio_raw_read-warning-fix.patch
+tsdev-fix-broken-usecto-millisecs-conversion.patch

 Input updates

+git-kbuild-fixup.patch

 Fix rejects in git-kbuild.patch

+modpost-white-list-pattern-adjustment.patch
+strip-config_-automatically-in-kernel-configuration-search.patch

 kbuild stuff

+led_colour_show-warning-fix.patch

 Fix git-leds.patch

-libata-check-for-an-support.patch
-scsi-expose-an-to-user-space.patch
-libata-expose-an-to-user-space.patch
-scsi-save-disk-in-scsi_device.patch
-libata-send-event-when-an-received.patch

 Dropped, it was old

+libata-add-hts541616j9sa00-to-ncq-blacklist.patch
+libata-add-ich8m-pciids-to-ata_piix.patch
+sata_promise-cleanups.patch
+sata_promise-sata-hotplug-support.patch
+libata-add-irq_flags-to-struct-pata_platform_info.patch
+libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
-drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
+ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
+ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch

 ata things

+ide-ide-never-called-printk-statement-in-ide-taskfilec-wait_drive_not_busy.patch
+ide-ide-fix-a-theoretical-oops-case.patch
+ide-serverworks-tune-csb6.patch
-ide-hpt366-simplify-ultradma-filtering-take2.patch
+ide-hpt366-simplify-ultradma-filtering-take-3.patch
-ide-aec62xx-remove-init_dma-method.patch
+ide-aec62xx-remove-init_dma-method-take-2.patch
+ide-idecd-replace-c-code-with-call-to-array_size-macro.patch
+ide-ide-remove-references-to-the-non-existent-config_scsi_eata_dma-variable.patch
+ide-ide-remove-content-related-to-dead-config_blk_dev_mac_mediabay-config-variable.patch
+ide-hd-array-size-calculation-using-sizeof-replaced-with-array_size.patch
+ide-ide-pre-eide-swdma-support-fix.patch
+ide-ide-convert-ide-find-best-mode-users-to-use-ide-max-dma-mode.patch
+ide-ide-add-short-cable-support.patch
+ide-piix-handle-short-cables.patch
+ide-alim15x3-handle-short-cables.patch
+ide-sis5513-handle-short-cables.patch
+ide-via82cxxx-handle-short-cables.patch
+ide-unexport-ide_set_dma.patch
+ide-ide-stop-mapping-roms.patch

 IDE tree updates

+ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch

 IDE fix

-git-md-accel-fixup.patch

 Unneeded

+tty-add-the-new-ioctls-and-definitionto-the-mips.patch

 tty update

+mmc-at91_mci-typo.patch

 Fix git-mmc.patch

+cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch

 MTD fix

+ubi-one-less-bug-usage.patch

 UBI fix

+use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
+use-is_power_of_2-in-myri10ge-myri10gec.patch
+extract-chip-specific-code-out-of-lasi_82596c.patch
+extract-chip-specific-code-out-of-lasi_82596c-update.patch
+ethernet-driver-for-eisa-only-sni-rm200-rm400-machines.patch
+ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch
+ehea-whitespace-cleanup.patch

 netdev stuff

+tun-tap-allow-group-ownership-of-tun-tap-devices.patch

 tun/tap driver feature

+git-battery-vs-git-acpi.patch

 fix git-battery for git-acpi API changes

+git-ioat-vs-git-md-accel.patch

 Fix git-ioat.patch for git-md-accel.patch changes

+pa-risc-use-page-allocator-instead-of-slab-allocator.patch
+pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch

 parisc stuff

+git-selinux-fixup.patch

 Fix rejects in git-selinux.patch

+git-selinux-disable-mmap_min_addr-by-default.patch

 Fix git-selinux

+dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
+dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
+dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch
+serial-add-support-for-ite-887x-chips.patch

 serial stuff

+gregkh-pci-pci-remove-cpqphp-maintainer.patch
+gregkh-pci-pci-fix-the-error-message-to-point-to-the-proper-person.patch
+gregkh-pci-pciehp-fix-possible-race-condition-in-writing-slot.patch
+gregkh-pci-pciehp-wait-for-1-second-after-power-off-slot.patch
+gregkh-pci-pci-fix-aer-driver-error-information.patch
+gregkh-pci-pci-aer-fix-stub-return-values.patch
+gregkh-pci-pci-aer-add-pci_cleanup_aer_correct_aer_status.patch
+gregkh-pci-pci-unexport-pci_proc_attach_device.patch
+gregkh-pci-pci-remove-useless-pci-driver-method.patch
+gregkh-pci-pci-read-revision-id-by-default.patch
+gregkh-pci-pci-atm-lanai-change-vendor-to-device.patch
+gregkh-pci-pci-i386-traps-change-vendor-to-device.patch
+gregkh-pci-pci-pci_ids-reorder-some-entries.patch
+gregkh-pci-pci-pci_ids-add-atheros-and-3com_2-vendors.patch
+gregkh-pci-pci-pci_ids-remove-double-or-more-empty-lines.patch

 PCI tree updates

+revert-gregkh-pci-pci_bridge-device.patch
+fix-gregkh-pci-pci-syscallc-switch-to-refcounting-api.patch

 Fix it

+revert-acpi-change-for-scsi.patch

 Make the scsi tree apply

+restore-acpi-change-for-scsi.patch

 Fix that up again

+git-scsi-misc-vs-greg-sysfs-stuff.patch

 Fix scsi changes for driver tree changes

+use-menuconfig-objects-ii-scsi-fix.patch

 "fix" use-menuconfig-objects-ii-scsi.patch

+ppa-coding-police-and-printk-levels.patch
+remove-the-dead-cyberstormiii_scsi-option.patch

 scsi fixes

+use-menuconfig-objects-ii-block-devices-fix.patch

 "fix" use-menuconfig-objects-ii-block-devices.patch

+block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
+cdrom_sysctl_info-fix.patch

 block things

+gregkh-usb-usb-m66592-udc-fix-use-old-interrupt-flags.patch
+gregkh-usb-usb-r8a66597-hcd-fix-null-access.patch
+gregkh-usb-usb-disable-file_storage-usb_config_att_wakeup.patch
+gregkh-usb-usb-fix-nec-ohci-chip-silicon-bug.patch
+gregkh-usb-usb-remove-__usb_port_suspend.patch
+gregkh-usb-usb-separate-root-and-non-root-suspend-resume.patch
+gregkh-usb-usb-remove-excess-code-from-hubc.patch
+gregkh-usb-usb-add-reset_resume-method.patch
+gregkh-usb-usb-unify-reset_resume-and-normal-resume.patch
+gregkh-usb-usb-add-power-persist-device-attribute.patch
+gregkh-usb-usb-fsl_usb2_udc-replace-deprecated-irq-flag.patch
+gregkh-usb-usb-fsl_usb2_udc-get-max-ep-number-from-dccparams-register.patch
+gregkh-usb-usb-option-fix-usage-of-urb-status-abuse.patch
+gregkh-usb-usb-ps3-usb-system-bus-rework.patch
+gregkh-usb-usb-gadget-driver-for-samsung-s3c2410-arm-soc.patch
+gregkh-usb-usb-usb-storage-use-kthread_stop-for-the-control-thread.patch
+gregkh-usb-usb-usb-host-side-can-be-configured-given-pcmcia.patch
+gregkh-usb-ehci-hub-improved-over-current-recovery.patch
+gregkh-usb-usb-io_ti-sleep-with-spinlock-held-detected-by-automatic-tool.patch
+gregkh-usb-usb-fix-usb_serial_put-synchronization.patch
+gregkh-usb-usb-handle-bogus-low-speed-bulk-endpoints.patch
+gregkh-usb-usb-free-dma-mappings-if-enqueue-fails.patch
+gregkh-usb-usb-serial-license-fix.patch
+gregkh-usb-usb-aircable-status.patch
+gregkh-usb-usb-airprime-status.patch
+gregkh-usb-usb-belkin_sa-status.patch
+gregkh-usb-usb-cyberjack-status.patch
+gregkh-usb-usb-cypress_m8-status.patch
+gregkh-usb-usb-digi_acceleport-status.patch
+gregkh-usb-usb-empeg-status.patch
+gregkh-usb-usb-ftdi_sio-status.patch
+gregkh-usb-usb-garmin_gps-status.patch
+gregkh-usb-usb-generic-status.patch
+gregkh-usb-usb-io_edgeport-status.patch
+gregkh-usb-usb-io_ti-status.patch
+gregkh-usb-usb-ipaq-status.patch
+gregkh-usb-usb-ipw-status.patch
+gregkh-usb-usb-ir-usb-status.patch
+gregkh-usb-usb-keyspan-status.patch
+gregkh-usb-usb-keyspan_pda-status.patch
+gregkh-usb-usb-kl5kusb105-status.patch
+gregkh-usb-usb-kobil_sct-status.patch
+gregkh-usb-usb-mct_u232-status.patch
+gregkh-usb-usb-mos7720-status.patch
+gregkh-usb-usb-mos7840-status.patch
+gregkh-usb-usb-navman-status.patch
+gregkh-usb-usb-omninet-status.patch
+gregkh-usb-usb-option-status.patch
+gregkh-usb-usb-oti6858-status.patch
+gregkh-usb-usb-pl2303-status.patch
+gregkh-usb-usb-safe_serial-status.patch
+gregkh-usb-usb-sierra-status.patch
+gregkh-usb-usb-ti_usb_3410_5052-status.patch
+gregkh-usb-usb-visor-status.patch
+gregkh-usb-usb-whiteheat-status.patch
+gregkh-usb-usb-sierra-fix-status-usage.patch
+gregkh-usb-usb-sierra-cleanup-urb-startup.patch
+gregkh-usb-usb-serial-ark3116c-mixed-fixups.patch
+gregkh-usb-usb-serial-belkin_sa-various-needed-fixes.patch
+gregkh-usb-usb-serial-ir_usb-clean-up-the-worst-of-it-remove-exciting-crash-on-open-feature.patch
+gregkh-usb-usb-usb-skeleton-use-anchors-in-disconnect-handling.patch
+gregkh-usb-usb-usb-skeleton-use-anchors-in-suspend-resume-handling.patch
+gregkh-usb-usb-usb-skeleton-use-anchors-in-pre-post-reset.patch
+gregkh-usb-usb-fix-up-full-speed-binterval-values-in-high-speed-interrupt-descriptor.patch
+gregkh-usb-usb-add-urb_free_buffer-flag-and-the-logic-behind-it.patch
+gregkh-usb-usb-gadget-rename-husb2dev-usba.patch
+gregkh-usb-usb-autosuspend-for-usblcd.patch
+gregkh-usb-usb-fsl_usb2_udc-fix-bug-for-portsc-bit-masking.patch
+gregkh-usb-usb-pete-s-taking-over-usblp.patch
+gregkh-usb-usb-usblp-add-dynamic-urbs-fix-races.patch
+gregkh-usb-usb-remove-usages-of-dev-powerpower_state.patch
+gregkh-usb-usb-don-t-resume-root-hub-if-the-controller-is-suspended.patch
+gregkh-usb-usb-fix-off-by-1-error-in-the-scatter-gather-library.patch
+gregkh-usb-usb-mos7720-developer-change.patch
+gregkh-usb-usb-add-iad-support-to-usbfs-and-sysfs.patch
+gregkh-usb-usb-support-blackberry-pearl-with-berry_charge.patch
+gregkh-usb-don-t-autosuspend-blackberry-devices.patch
+gregkh-usb-usb-add-printer-gadget-driver.patch

 USB tree updates

+fix-gregkh-usb-usb-use-menuconfig-objects.patch

 Fix it

+x86_64-mm-paravirt-helper-to-disable-all-io-space.patch
+x86_64-mm-xen-use-iret-directly-where-possible.patch
+x86_64-mm-xen-xen_start_kernel-is-__init-so-startup_xen-should-be-too.patch
+x86_64-mm-xen-disable-all-non-virtual-devices.patch
+x86_64-mm-use-null-for-pointer.patch
+x86_64-mm-remove-extra-extern-declaring-dmi_ioremap.patch
+x86_64-mm-smp-call-no-bh.patch

 x86 tree updates

-revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
-revert-x86_64-mm-cpa-cache-flush.patch

 Unneeded

+more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
+fix-x86_64-mm-add-common-orderly_poweroff.patch
+tidy-up-usermode-helper-waiting-a-bit-fix.patch
+update-x86_64-mm-xen-use-iret-directly-where-possible.patch

 x86 fixes

+mmconfig-validate-against-acpi-motherboard-resources.patch
+mmconfig-validate-against-acpi-motherboard-resources-fix.patch
+mmconfig-validate-against-acpi-motherboard-resources-fix-2.patch
+mmconfig-validate-against-acpi-motherboard-resources-fix-3.patch
+mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch

 mmconfig fix

+i386-hpet-check-if-the-counter-works.patch
+i386-trim-memory-not-covered-by-wb-mtrrs.patch
+i386-trim-memory-not-covered-by-wb-mtrrs-fix.patch
+kprobes-x86_64-fix-for-mark-ro-data.patch
+kprobes-i386-fix-for-mark-ro-data.patch
+divorce-config_x86_pae-from-config_highmem64g.patch
+remove-unneeded-test-of-task-in-dump_trace.patch
+i386-move-the-kernel-to-16mb-for-numa-q.patch
+i386-show-unhandled-signals.patch
+i386-show-unhandled-signals-fix.patch
+i386-minor-nx-handling-adjustment.patch
+i386-minor-nx-handling-adjustment-fix.patch
+x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
+x86-64-remove-unused-variable-maxcpus.patch
+move-functions-declarations-to-header-file.patch
+x86_64-during-vm-oom-condition.patch
+i386-during-vm-oom-condition.patch
+x86-64-disable-the-gart-in-shutdown.patch
+x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
+x86_84-move-iommu-declaration-from-proto-to-iommuh-fix.patch
+i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
+i386-add-cpu_relax-to-cmos_lock.patch
+i386-add-cpu_relax-to-cmos_lock-fix.patch
+x86_64-flush_tlb_kernel_range-warning-fix.patch
+x86_64-add-ioapic-nmi-support.patch
+x86_64-add-ioapic-nmi-support-fix.patch
+x86_64-add-ioapic-nmi-support-fix-2.patch
+x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
+x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
+reserve-the-right-performance-counter-for-the-intel-perfmon-nmi-watchdog.patch

 x86 stuff

+nohz-fix-nohz-x86-dyntick-idle-handling.patch
+acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
+clockevents-fix-typo-in-acpi_pmc.patch
+timekeeping-fixup-shadow-variable-argument.patch
+timerc-cleanup-recently-introduced-whitespace-damage.patch
+clockevents-remove-prototypes-of-removed-functions.patch
+clockevents-fix-resume-logic.patch
+clockevents-fix-device-replacement.patch
+tick-management-spread-timer-interrupt.patch
+highres-improve-debug-output.patch
+highres-improve-debug-output-fix.patch
+hrtimer-speedup-hrtimer_enqueue.patch
+pcspkr-use-the-global-pit-lock.patch
+ntp-move-the-cmos-update-code-into-ntpc.patch
+ntp-move-the-cmos-update-code-into-ntpc-fix.patch
+ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
+i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
+i386-remove-volatile-in-apicc.patch
+i386-hpet-assumes-boot-cpu-is-0.patch
+i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
+x86_64-untangle-asm-hpeth-from-asm-timexh.patch
+x86_64-use-generic-cmos-update.patch
+x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
+x86_64-fix-apic-typo.patch
+x86_64-convert-to-cleckevents.patch
+acpi-remove-the-useless-ifdef-code.patch
+x86_64-hpet-restore-vread.patch
+x86_64-restore-restore-nohpet-cmdline.patch
+x86_64-block-irq-balancing-for-timer.patch
+x86_64-prep-idle-loop-for-dynticks.patch
+x86_64-enable-high-resolution-timers-and-dynticks.patch

 dynticks for x86_64

+x86_64-dynticks-disable-hpet_id_legsup-hpets.patch

 pretend to fix it

+ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
+ich-force-hpet-restructure-hpet-generic-clock-code.patch
+ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
+ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
+ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
+ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
+ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
+ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
+ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch

 Enable i386 hpet when the BIOS forgot to

+git-newsetup-fixup.patch

 Fix rejects in git-newsetup.patch

+fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch
+fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch
+fix-xfs_ioc_fsbulkstat_single-and-xfs_ioc_fsinumbers-in-compat-mode.patch
+xfs-warning-fix.patch

 XFS stuff

+git-kgdb.patch

 KGDB tree

+git-kgdb-fixup.patch
+kgdb-warning-fix.patch
+kgdb-kconfig-fix.patch
+kgdb-use-new-style-interrupt-flags.patch
+kgdb-section-fix.patch
+kgdb_skipexception-warning-fix.patch
+kgdb-ia64-fixes.patch
+kgdb-bust-on-ia64.patch

 fix it

+pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch

 Fix pci-x-pci-express-read-control-interfaces-qla2xxx.patch

+irda-fix-printk-format.patch
+netconsole-fix-soft-lockup-when-removing-module.patch
+gen_estimator-fix-locking-and-timer-related-bugs.patch

 net fixes which we might want in 2.6.22

+serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
+serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch

 Fix serial patches in -mm some more

+mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch

 Fix mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch

-numa-mempolicy-allow-tunable-policy-for-system-init.patch
-numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
+numa-mempolicy-dynamic-interleave-map-for-system-init.patch
+oom-stop-allocating-user-memory-if-tif_memdie-is-set.patch
+numa-mempolicy-trivial-debug-fixes.patch
+mm-fix-improper-init-type-section-references.patch
+page-table-handling-cleanup.patch
+kill-vmalloc_earlyreserve.patch
+mm-more-__meminit-annotations.patch
+mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
+madvise_need_mmap_write-usage.patch
+slob-initial-numa-support.patch

 mm updates

+fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
+fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch
+fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
+fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
+fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch

 Fix fs-introduce-write_begin-write_end-and-perform_write-aops.patch rather a
 lot.

+ext3-convert-to-new-aops-fix.patch

 Fix ext3-convert-to-new-aops.patch

+ext4-convert-to-new-aops-fix.patch

 Fix ext4-convert-to-new-aops.patch

+ufs-convert-to-new-aops-fix.patch

 Fix ufs-convert-to-new-aops.patch

+sysv-convert-to-new-aops-fix.patch

 Fix sysv-convert-to-new-aops.patch

+minix-convert-to-new-aops-fix.patch

 Fix minix-convert-to-new-aops.patch

+fs-adfs-convert-to-new-aops.patch
+fs-affs-convert-to-new-aops.patch

 Fix unconverted filesystems

-nick-broke-stuff.patch
-nick-broke-more-stuff.patch
-nick-broke-even-more-stuff.patch
-nick-really-did-it-this-time.patch

 Unneeded

+fix-read-truncate-race.patch
+make-sure-readv-stops-reading-when-it-hits-end-of-file.patch

 VFS fixes

+create-the-zone_movable-zone-fix-2.patch

 Fix create-the-zone_movable-zone.patch some more

+allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch

 Fix allow-huge-page-allocations-to-use-gfp_high_movable.patch some more

+handle-kernelcore=-generic-fix.patch

 Fix handle-kernelcore=-generic.patch

+mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch

 Fix mm-clean-up-and-kernelify-shrinker-registration.patch for git-nfs

+slub-remove-useless-export_symbol.patch
+slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
+slub-slab-validation-move-tracking-information-alloc-outside-of.patch
+slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
+slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
+slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
+slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
+slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
+slub-extract-dma_kmalloc_cache-from-get_cache.patch
+slub-do-proper-locking-during-dma-slab-creation.patch
+slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
+slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
+slub-faster-more-efficient-slab-determination-for-__kmalloc-fix-2.patch
+slub-simplify-dma-index-size-calculation.patch
+add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch

 slub/slab/slob updates

-implement-file-posix-capabilities-update.patch

 Folded into implement-file-posix-capabilities.patch

+implement-file-posix-capabilities-fix.patch
+file-capabilities-introduce-cap_setfcap.patch

 Update implement-file-posix-capabilities.patch

+alpha-fix-trivial-section-mismatch-warnings.patch
+fix-alpha-isa-support.patch
+fix-alpha-isa-support-fix.patch

 alpha fixes

+pm-reduce-code-duplication-between-mainc-and-userc.patch
+pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch

 PM updates

+uml-use-get_free_pages-to-allocate-kernel-stacks.patch
+add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
+uml-debug_shirq-fixes.patch
+uml-xterm-driver-tidying.patch
+uml-pty-channel-tidying.patch
+uml-handle-errors-on-opening-host-side-of-consoles.patch
+uml-sigio-support-cleanup.patch
+uml-simplify-helper-stack-handling.patch
+uml-eliminate-kernel-allocator-wrappers.patch

 UML updates

+use-menuconfig-objects-ii-auxdisplay-fix.patch
+use-menuconfig-objects-ii-misc-strange-dev-fix.patch
+use-menuconfig-objects-ii-oprofile-fix.patch
+use-menuconfig-objects-crypto-hw-fix.patch

 "fix" the menuconfig updates

+init-wait-for-asynchronously-scanned-block-devices-fix.patch

 Fix init-wait-for-asynchronously-scanned-block-devices.patch

+kernel-utf-8-handling-fix.patch

 Fix kernel-utf-8-handling.patch

+zsc-drain-the-transmission-line.patch
+hugetlbfs-use-lib-parser-fix-docs.patch
+report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
+intel-rng-undo-mess-made-by-an-80-column-extremist.patch
+improve-behaviour-of-spurious-irq-detect.patch
+improve-behaviour-of-spurious-irq-detect-fix.patch
+audit-add-tty-input-auditing.patch
+audit-add-tty-input-auditing-fix.patch
+audit-add-tty-input-auditing-fix-2.patch
+remove-config_uts_ns-and-config_ipc_ns.patch
+user-namespace-add-the-framework.patch
+user-namespace-add-unshare.patch
+revert-vanishing-ioctl-handler-debugging.patch
+binfmt_elf-warning-fix.patch
+document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
+cobalt-remove-all-references-to-cobalt-nvram.patch
+allow-softlockup-to-be-runtime-disabled.patch
+dirty_writeback_centisecs_handler-cleanup.patch
+mm-fix-create_new_namespaces-return-value.patch
+add-a-kmem_cache-for-nsproxy-objects.patch
+ptrace_peekdata-consolidation.patch
+ptrace_pokedata-consolidation.patch
+adjust-nosmp-handling.patch
+ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
+ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
+remove-unused-lock_cpu_hotplug_interruptible-definition.patch
+add-werror-implicit-function-declaration.patch
+kerneldoc-fix-in-audit_core_dumps.patch
+add-lzo1x-algorithm-to-the-kernel.patch
+introduce-compat_u64-and-compat_s64-types.patch
+diskquota-32bit-quota-tools-on-64bit-architectures.patch
+diskquota-32bit-quota-tools-on-64bit-architectures-fix.patch
+diskquota-32bit-quota-tools-on-64bit-architectures-fix-fix.patch
+blink-only-blink-when-parameter-is-set.patch
+blink-only-blink-when-parameter-is-set-fix.patch
+remove-final-two-references-to-__obsolete_setup-macro.patch
+update-procfs-guide-doc-of-read_func.patch
+ext3-remove-extra-is_rdonly-check.patch
+namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
+doc-oops-tracing-add-code-decode-info.patch
+drop-obsolete-sys_ioctl-export.patch
+is_power_of_2-ext3-superc.patch
+is_power_of_2-jbd.patch
+sys_time-speedup.patch
+sys_time-speedup-build-fixes.patch
+cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
+# hw_random-add-quality-categories.patch: mpm had design issues
+#hw_random-add-quality-categories-bcm43xx.patch
+update-description-in-documentation-filesystems-vfstxt-typo-fixed.patch
+futex-tidy-up-the-code-v2.patch
+add-documentation-sysctl-ctl_unnumberedtxt.patch
+sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
+# drivers-pmc-msp71xx-gpio-char-driver.patch: david-b panned it
+drivers-pmc-msp71xx-gpio-char-driver.patch
+mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch
+hfs-refactor-ascii-to-unicode-conversion-routine.patch
+hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
+hfs-add-custom-dentry-hash-and-comparison-operations.patch
+sprint_symbol-cleanup.patch
+hwrng-add-type-categories.patch
+#hwrng-add-type-categories-bcm43xx.patch
+fs-namespacec-should-include-internalh.patch
+proper-prototype-for-proc_nr_files.patch
+replace-obscure-constructs-in-fs-block_devc.patch
+replace-obscure-constructs-in-fs-block_devc-fix.patch
+bd_claim_by_disk-fix-warning.patch
+fs-reiserfs-cleanups.patch
+adb_probe_task-remove-unneeded-flush_signals-call.patch
+kcdrwd-remove-unneeded-flush_signals-call.patch
+nbdcsock_xmit-cleanup-signal-related-code.patch
+move-seccomp-from-proc-to-a-prctl.patch
+make-seccomp-zerocost-in-schedule.patch
+is_power_of_2-kernel-kfifoc.patch
+parport_pc-it887x-fix.patch
+is_power_of_2-ufs-superc.patch
+codingstyle-add-information-about-trailing-whitespace.patch
+codingstyle-add-information-about-editor-modelines.patch
+uninline-check_signature.patch

 Misc

+introduce-i_sync-fix.patch

 Fix introduce-i_sync.patch

+atmel_spi-minor-updates.patch
+s3c24xx-spi-controllers-both-select-bitbang.patch
+spi-tle620x-power-switch-driver.patch
+spi-master-driver-for-xilinx-virtex.patch
+spi-master-driver-for-xilinx-virtex-fix.patch

 SPI updates

+isdn-capi-warning-fixes.patch
+i4l-leak-in-eicon-idifuncc.patch

 ISDN updates

+knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
+knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
+knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
+knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
+knfsd-nfsd4-fix-handling-of-acl-errrors.patch
+knfsd-nfsd-remove-unused-header-interfaceh.patch
+knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
+knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
+knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
+knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
+knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix.patch
+knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch

 knfsd updates

+thecus-n2100-register-rtc-rs5c372-i2c-device.patch
+rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
+rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
+driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
+driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
+driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
+driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
+rtc_class-is-no-longer-considered-experimental.patch
+rtc-kconfig-tweax.patch
+rtc-add-rtc-m41t80-driver-take-2.patch
+rtc-add-rtc-m41t80-driver-take-2-fix.patch
+rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
+rtc-add-support-for-the-st-m48t59-rtc.patch
+rtc-add-support-for-the-st-m48t59-rtc-fix-2.patch
+rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
+rtc-add-support-for-the-st-m48t59-rtc-fix-3.patch
+rtc-driver-for-ds1216-chips.patch
+rtc-driver-for-ds1216-chips-fix.patch
+rtc-ds1307-oscillator-restart-for-ds1337383940.patch

 rtc driver updates

-lguest-the-guest-code-tidyups.patch
-lguest-the-guest-code-tidyups-update.patch
-lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
-lguest-speed-up-paravirt_lazy_flush-handling.patch
-lguest-more-lazy_hcalls.patch
-lguest-the-guest-code-tsc-fix.patch
-lguest-the-guest-code-suppress-ide-probing.patch

 Folded into lguest-the-guest-code.patch

-lguest-the-host-code-tidyups.patch
-lguest-the-host-code-tidyups-update.patch
-lguest-the-host-code-borkages.patch
-lguest-faster-tls-switching.patch
-lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
-lguest-the-host-code-use-tsc.patch
-lguest-the-host-code-use-hrtimers.patch
-lguest-the-host-code-update-for-mm-simplify-boot_params.patch

 Folded into lguest-the-host-code.patch

+lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch

 Fix lguest for x86_64 dynticks changes

-lguest-the-makefile-and-kconfig-tidyups.patch

 Folded into lguest-the-makefile-and-kconfig.patch

-lguest-the-console-driver-tidyups.patch

 Folded into lguest-the-console-driver.patch

-lguest-the-net-driver-tidyups.patch
-lguest-the-net-driver-tidyups-update.patch
-lguest-the-net-driver-include-fix.patch

 Folded into lguest-the-net-driver.patch

-lguest-the-block-driver-tidyups.patch
-lguest-the-block-driver-tidyups-update.patch

 Folded into lguest-the-block-driver.patch

-lguest-the-documentation-example-launcher-example-launcher-fix.patch
-lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch

 Folded into lguest-the-documentation-example-launcher.patch

+remove-options-depending-on-oss_obsolete.patch

 OSS fix

+unprivileged-mounts-allow-unprivileged-fuse-mounts-fuse-fix-double-fs_flags-initializer.patch

 Fix unprivileged-mounts-allow-unprivileged-mounts.patch some more

+char-istallion-initlocking-fixes-try-2.patch

 stallion fix

+fbdev-move-arch-specific-bits-to-their-respective-fix.patch

 Fix fbdev-move-arch-specific-bits-to-their-respective.patch

+fb-epson1355fb-kill-off-dead-sh-support.patch
+fix-the-graphic-corruption-issue-on-ia64-machines.patch
+omap-add-ti-omap-framebuffer-driver.patch
+omap-add-ti-omap1610-accelerator-entry.patch
+omap-add-ti-omap1-internal-lcd-controller.patch
+omap-add-ti-omap2-internal-display-controller-support.patch
+omap-add-ti-omap1-external-lcd-controller-support-sossi.patch
+omap-add-ti-omap2-external-lcd-controller-support-rfbi.patch
+omap-add-external-epson-hwa742-lcd-controller-support.patch
+omap-add-external-epson-blizzard-lcd-controller-support.patch
+omap-lcd-panel-support-for-the-ti-omap-h4-board.patch
+omap-lcd-panel-support-for-the-ti-omap-h3-board.patch
+omap-lcd-panel-support-for-the-palm-tungsten-e.patch
+omap-lcd-panel-support-for-palm-tungstent.patch
+omap-lcd-panel-support-for-the-palm-zire71.patch
+omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch
+omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch
+omap-lcd-panel-support-for-the-ti-omap-osk-board.patch
+omap-lcd-panel-support-for-the-siemens-sx1-mobile-phone.patch

 fbdev updates

+readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
+readahead-pass-real-splice-size.patch

 readahead updates

-mm-share-pg_readahead-and-pg_reclaim-fix.patch
-mm-share-pg_readahead-and-pg_reclaim-fix-2.patch

 Foldedinto mm-share-pg_readahead-and-pg_reclaim.patch

+readahead-split-ondemand-readahead-interface-into-two-functions.patch
+readahead-sanify-file_ra_state-names.patch

 readahead updates

+jprobes-make-struct-jprobeentry-a-void.patch
+jprobes-remove-jprobe_entry.patch
+jprobes-make-jprobes-a-little-safer-for-users.patch
+jprobes-make-jprobes-a-little-safer-for-users-fix.patch

 jprobes updates

+intel-iommu-dmar-detection-and-parsing-logic.patch
+intel-iommu-pci-generic-helper-function.patch
+intel-iommu-pci-generic-helper-function-fix.patch
+intel-iommu-clflush_cache_range-now-takes-size-param.patch
+intel-iommu-iova-allocation-and-management-routines.patch
+intel-iommu-iova-allocation-and-management-routines-fix.patch
+intel-iommu-iova-allocation-and-management-routines-fix-2.patch
+intel-iommu-intel-iommu-driver.patch
+intel-iommu-intel-iommu-driver-fix.patch
+intel-iommu-intel-iommu-driver-fix-2.patch
+intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
+intel-iommu-intel-iommu-cmdline-option-forcedac.patch
+intel-iommu-dmar-fault-handling-support.patch
+intel-iommu-iommu-gfx-workaround.patch
+intel-iommu-iommu-floppy-workaround.patch
+intel-iommu-iommu-floppy-workaround-fix.patch
+intel-iommu-iommu-floppy-workaround-fix-fix.patch

 Intel IOMMU support

+define-new-percpu-interface-for-shared-data-version-4.patch
+use-the-new-percpu-interface-for-shared-data-version-4.patch

 percpu tweak

+arch-personality-independent-stack-top.patch
+audit-rework-execve-audit.patch
+mm-variable-length-argument-support.patch
+mm-variable-length-argument-support-fix.patch

 Remove the fixed command-line length limit

+ext4-zero_user_page-conversion.patch
+ext4-remove-extra-is_rdonly-check.patch
+is_power_of_2-ext4-superc.patch

 ext4 udpates

+cfs-scheduler-v16.patch
+sched-cfs-v2.6.22-git-v18.patch

 CFS scheduler updates

+mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch

 Fix mm-implement-swap-prefetching.patch

+drivers-edac-new-i82443bxgz-mc-driver-broken.patch

 Fix drivers-edac-new-i82443bxgz-mc-driver.patch

+driver-edac-add-mips-and-ppc-visibility.patch
+driver-edac-mod-race-fix-i82875p.patch
+driver-edac-fix-ignored-return-i82875p.patch
+include-linux-pci_id-h-add-amd-northbridge-defines.patch
+driver-edac-i5000-define-typo.patch
+driver-edac-remove-null-from-statics.patch
+driver-edac-i5000-code-tidying.patch
+driver-edac-edac_device-code-tidying.patch
+driver-edac-mod-edac_align_ptr-function.patch
+driver-edac-mod-edac_opt_state_to_string-function.patch
+driver-edac-remove-file-edac_mc-h.patch

 More EDAC updates

+cpuset-zero-malloc-revert-the-old-cpuset-fix.patch

 cpusets revert to make the containers patches apply

+containersv10-basic-container-framework-fix-3.patch
+containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch

 Fix containersv10-basic-container-framework-fix-2.patch

+containersv10-add-tasks-file-interface-fix-2.patch

 Fix containersv10-add-tasks-file-interface.patch some more

+containersv10-make-cpusets-a-client-of-containers-whitespace.patch

 Fix containersv10-make-cpusets-a-client-of-containers.patch

+containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch

 Fix containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch

+containersv10-support-for-automatic-userspace-release-agents-whitespace.patch

 Fix containersv10-support-for-automatic-userspace-release-agents.patch

+add-containerstats-v3.patch
+add-containerstats-v3-fix.patch
+update-getdelays-to-become-containerstats-aware.patch

 Container stats

+containers-implement-subsys-post_clone.patch
+containers-implement-namespace-tracking-subsystem-v3.patch

 More containers stuff

+lockstat-core-infrastructure-fix-fix-fix.patch

 Fix lockstat-core-infrastructure.patch even more

+lockdep-various-fixes.patch
+lockdep-various-fixes-checkpatch.patch
+lockdep-fixup-sk_callback_lock-annotation.patch
+lockstat-measure-lock-bouncing.patch
+lockstat-measure-lock-bouncing-checkpatch.patch
+lockstat-better-class-name-representation.patch

 lockdep/lockstat things

+reiser4-fix-for-new-aops-patches.patch
-nick-broke-reiser4-too.patch

 Fix reiser4 for Nick's stuff

+allow-page_owner-to-be-set-on-any-architecture.patch
+allow-page_owner-to-be-set-on-any-architecture-fix.patch

 Make page-owner tracking (potentially) non-x86

+beeping-patch-for-debugging-acpi-sleep.patch

 Weird patch which goes beep (I still don't understand this)

+alloc_pages-debug.patch

 More debugging




All 1689 patches:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/patch-list


