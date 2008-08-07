Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYHGNm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYHGNm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYHGNmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:42:40 -0400
Received: from saeurebad.de ([85.214.36.134]:50220 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbYHGNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:42:39 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org
Subject: [PATCH] lockdep: spin_lock_nest_lock fix
References: <200808062133.m76LXpGk016460@imap1.linux-foundation.org>
Date: Thu, 07 Aug 2008 15:42:10 +0200
In-Reply-To: <200808062133.m76LXpGk016460@imap1.linux-foundation.org>
	(akpm@linux-foundation.org's message of "Wed, 06 Aug 2008 14:20:54
	-0700")
Message-ID: <87vdyduekt.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

akpm@linux-foundation.org writes:

> The mm-of-the-moment snapshot 2008-08-06-14-20 has been uploaded to
>
>    http://userweb.kernel.org/~akpm/mmotm/
>
> It contains the following patches against 2.6.27-rc2:
>
> feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
> hugetlb-call-arch_prepare_hugepage-for-surplus-pages.patch
> quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch
> page-allocator-use-no-panic-variant-of-alloc_bootmem-in-alloc_large_system_hash.patch
> cpu-hotplug-s390-doesnt-support-additional_cpus-anymore.patch
> radeonfb-fix-copyarea-for-r300-and-later.patch
> memcg-fix-oops-in-mem_cgroup_shrink_usage.patch
> sm501-update-debugging-low-information-messages.patch
> seq_file-fix-bug-when-seq_read-reads-nothing.patch
> repeatable-slab-corruption-with-ltp-msgctl08.patch
> linux-next.patch
> next-remove-localversion.patch
> acpi-add-checking-for-null-early-param.patch
> mm-only-enforce-acpi-resource-conflict-checks.patch
> calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
> x86-remove-init_mm-export-as-planned-for-2626.patch
> use-warn-in-arch-x86-mm-ioremapc.patch
> use-warn-in-arch-x86-mm-pageattrc.patch
> use-warn-in-arch-x86-kernel.patch
> arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
> i386-vmalloc-size-fix.patch
> zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
> x86-64-fix-overlap-of-modules-and-fixmap-areas.patch
> x86_64-remove-empty-lines-from-stack-traces-oopses.patch
> x86-tracehook_signal_handler.patch
> x86-tracehook-syscall.patch
> x86-tracehook-asm-syscallh.patch
> x86-signals-use-asm-syscallh.patch
> x86-tracehook-tif_notify_resume.patch
> x86-tracehook-config_have_arch_tracehook.patch
> hda_intel-enable-snoop-for-nvidia-hda-controller.patch
> cifs-remove-global_extern-macro.patch
> cifs-fix-range-check.patch
> pcmcia-pccard-deadlock-fix.patch
> ppc-use-the-common-ascii-hex-helpers.patch
> powerpc-replace-__function__-with-__func__.patch
> v4l-link-tuner-before-saa7134.patch
> v4l-drx397xdc-sparse-annotations.patch
> i2c-renesas-highlander-fpga-smbus-support.patch
> i2c-renesas-highlander-fpga-smbus-support-update.patch
> i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
> hid-wellspring-device-quirks.patch
> add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
> ntp-let-update_persistent_clock-sleep.patch
> migrate_timers-add-comment-use-spinlock_irq.patch
> tick-schedc-suppress-needless-timer-reprogramming.patch
> timekeeping-fix-rounding-problem-during-clock-update.patch
> git-ia64.patch
> drivers-input-serio-xilinx_ps2c-fix-warning.patch
> wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch
> elantech-touchpad-driver.patch
> input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
> input-bcm5974-055-smoother-motion-irq-simplification.patch
> input-ads7846c-sparse-lock-annotation.patch
> git-jg-misc.patch
> git-kbuild-fixes.patch
> genksyms-track-symbol-checksum-changes.patch
> genksyms-allow-to-ignore-symbol-checksum-changes.patch
> lkdtm-fix-for-config_scsi=n.patch
> git-lblnet.patch
> git-libata-all.patch
> libata-scsi-dont-start-hotplug-work-queue-if-hotplug-is-disabled.patch
> sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
> m32r-remove-the-unused-nohighmem-option.patch
> m32r-dont-offer-config_isa.patch
> mmc-fix-clock-off-in-pxa255-270.patch
> git-ubi.patch
> git-ubi-git-rejects.patch
> configure-out-igmp-support.patch
> acpi-compal-laptop-use-rfkill-switch-subsystem.patch
> forcedeth-power-down-phy-when-interface-is-down.patch
> forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
> sundance-set-carrier-status-on-link-change-events.patch
> via-velocity-give-a-structure-to-the-rx-tx-fields.patch
> via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
> hamradio-add-missing-sanity-check-to-tty-operation.patch
> skge-adapt-skge-to-use-reworked-pci-pm.patch
> cassini-use-request_firmware.patch
> pegasus-add-blacklist-support-to-fix-belkin-bluetooth-dongle.patch
> drivers-net-replace-__function__-with-__func__.patch
> e1000e-convert-ndev_-printks-to-something-smaller.patch
> e1000e-perform-basic-82573-eeprom-checks-for-known-issues.patch
> e1000e-fix-drv-load-issues.patch
> e1000e-remove-inapplicable-test-for-ioport.patch
> e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
> sky2-adapt-to-use-reworked-pci-pm-code.patch
> e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
> 3x59x-fix-pci-resource-management.patch
> smc-ultra-get-rid-of-eth%d-message.patch
> nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch
> sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
> git-parisc.patch
> pciidsh-remove-a-duplicated-symbol.patch
> use-warn-in-kernel-lockdepc.patch
> sched-do_wait_for_common-use-signal_pending_state.patch
> wait_task_inactive-dont-consider-task-nivcsw.patch
> wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
> wait_task_inactive-fix-the-config_smp-version.patch
> sched-type-fix.patch
> lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
> lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
> lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
> lockdep-re-annotate-scheduler-runqueues.patch
> lockdep-shrink-held_lock-structure.patch
> lockdep-shrink-held_lock-structure-fix.patch
> lockdep-shrink-held_lock-structure-fix-2.patch
> lockdep-map_acquire.patch
> lockdep-lock-protection-locks.patch
> lockdep-spin_lock_nest_lock.patch

---

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 kernel/spinlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -323,7 +323,7 @@ void __lockfunc _spin_lock_nest_lock(spi
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-EXPORT_SYMBOL(_spin_lock_nest_lock)
+EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
