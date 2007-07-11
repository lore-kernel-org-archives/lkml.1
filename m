Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXGKLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXGKLsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbXGKLsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:48:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:47414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbXGKLsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:48:12 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jeremy@goop.org,
       "Tim Hockin" <thockin@google.com>, jesse.barnes@intel.com
Subject: x86 status was Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Jul 2007 14:43:15 +0200
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Message-ID: <p734pkbyuu4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> revert-x86_64-mm-verify-cpu-rename.patch
> add-kstrndup-fix.patch
> xen-build-fix.patch
> fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
> fix-x86_64-mm-xen-xen-smp-guest-support.patch
> more-fix-x86_64-mm-xen-xen-smp-guest-support.patch

> fix-x86_64-mm-sched-clock-share.patch
> fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
> fix-x86_64-mm-add-common-orderly_poweroff.patch
> fix-x86_64-mm-xen-xen-event-channels.patch
> arch-i386-xen-mmuc-must-include-linux-schedh.patch
> tidy-up-usermode-helper-waiting-a-bit-fix.patch
> update-x86_64-mm-xen-use-iret-directly-where-possible.patch


Xen is probably going to be merged. I'm still not fully happy
about the review status of the drivers and xenbus, but there doesn't seem
to be much value in delaying it further.

I'll consolidate the fixes and fixes-to-fixes.


These all need re-review:

> i386-add-support-for-picopower-irq-router.patch
> make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
> arch-i386-kernel-i8253c-should-include-asm-timerh.patch
> make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
> quicklist-support-for-x86_64.patch
> x86_64-extract-helper-function-from-e820_register_active_regions.patch
> x86_64-fix-e820_hole_size-based-on-address-ranges.patch
> x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
> x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
> x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
> x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
> mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
> x86_64-fix-smp_call_function_single-return-value.patch
> x86_64-o_excl-on-dev-mcelog.patch
> x86_64-support-poll-on-dev-mcelog.patch

It's still not clear to me this is any useful. The current code
can run a program on MCE which should be really fast enough
for machine check handling.

> i386-fix-machine-rebooting.patch
> x86-fix-section-mismatch-warnings-in-mtrr.patch
> x86_64-ratelimit-segfault-reporting-rate.patch

I think that one was bogus.

> x86_64-pm_trace-support.patch
> make-alt-sysrq-p-display-the-debug-register-contents.patch
> i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
> round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
> pci-disable-decode-of-io-memory-during-bar-sizing.patch
> mmconfig-validate-against-acpi-motherboard-resources.patch
> x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
> i386-remove-support-for-the-rise-cpu.patch

> i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
> i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
> i386-do-not-restore-reserved-memory-after-hibernation.patch
> paravirt-helper-to-disable-all-io-space-fix.patch
> dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
> i386-hpet-check-if-the-counter-works.patch
> i386-trim-memory-not-covered-by-wb-mtrrs.patch

Might need more testing? 

More review:

> kprobes-x86_64-fix-for-mark-ro-data.patch
> kprobes-i386-fix-for-mark-ro-data.patch
> divorce-config_x86_pae-from-config_highmem64g.patch
> remove-unneeded-test-of-task-in-dump_trace.patch
> i386-move-the-kernel-to-16mb-for-numa-q.patch
> i386-show-unhandled-signals.patch
> i386-minor-nx-handling-adjustment.patch
> x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
> x86-64-remove-unused-variable-maxcpus.patch
> move-functions-declarations-to-header-file.patch
> x86_64-during-vm-oom-condition.patch
> i386-during-vm-oom-condition.patch
> x86-64-disable-the-gart-in-shutdown.patch
> x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
> i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
> i386-add-cpu_relax-to-cmos_lock.patch
> x86_64-flush_tlb_kernel_range-warning-fix.patch
> x86_64-add-ioapic-nmi-support.patch
> x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
> x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
> x86_64-fix-wrong-comment-regarding-set_fixmap.patch
> arch-x86_64-kernel-processc-lower-printk-severity.patch
> nohz-fix-nohz-x86-dyntick-idle-handling.patch
> acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
> clockevents-fix-typo-in-acpi_pmc.patch
> timekeeping-fixup-shadow-variable-argument.patch
> timerc-cleanup-recently-introduced-whitespace-damage.patch
> clockevents-remove-prototypes-of-removed-functions.patch
> clockevents-fix-resume-logic.patch
> clockevents-fix-device-replacement.patch
> tick-management-spread-timer-interrupt.patch
> highres-improve-debug-output.patch
> hrtimer-speedup-hrtimer_enqueue.patch
> pcspkr-use-the-global-pit-lock.patch
> ntp-move-the-cmos-update-code-into-ntpc.patch
> i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
> i386-remove-volatile-in-apicc.patch
> i386-hpet-assumes-boot-cpu-is-0.patch
> i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
> x86_64-untangle-asm-hpeth-from-asm-timexh.patch
> x86_64-use-generic-cmos-update.patch
> x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
> x86_64-fix-apic-typo.patch
> x86_64-convert-to-cleckevents.patch
> acpi-remove-the-useless-ifdef-code.patch
> x86_64-hpet-restore-vread.patch
> x86_64-restore-restore-nohpet-cmdline.patch
> x86_64-block-irq-balancing-for-timer.patch
> x86_64-prep-idle-loop-for-dynticks.patch
> x86_64-enable-high-resolution-timers-and-dynticks.patch
> x86_64-dynticks-disable-hpet_id_legsup-hpets.patch


I'm sceptical about the dynticks code. It just rips out the
x86-64 timing code completely, which needs a lot more review and testing.
Probably not .23

More review: 

> xen-fix-x86-config-dependencies.patch
> x86_64-get-mp_bus_to_node-as-early.patch
> xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
> xen-cant-support-numa-yet.patch
> x86-fix-iounmaps-use-of-vm_structs-size-field.patch
> arch-x86_64-kernel-aperturec-lower-printk-severity.patch
> arch-x86_64-kernel-e820c-lower-printk-severity.patch
> ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
> ich-force-hpet-restructure-hpet-generic-clock-code.patch
> ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
> ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
> ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
> ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
> ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
> geode-basic-infrastructure-support-for-amd-geode-class.patch
> geode-mfgpt-support-for-geode-class-machines.patch
> geode-mfgpt-clock-event-device-support.patch
> i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
> i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
> i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch

-Andi
