Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbXBJLmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbXBJLmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXBJLmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:42:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:55360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXBJLmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:42:53 -0500
From: Andi Kleen <ak@suse.de>
To: linux-kernel@vger.kernel.org
Subject: What will be in the x86-64/x86 2.6.21 merge
Date: Sat, 10 Feb 2007 12:42:48 +0100
User-Agent: KMail/1.9.5
Cc: discuss@x86-64.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101242.48467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I will post the existing patches in batches for closer review.

Can be already all viewed at ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/

Highlights: 

- Using %fs instead of %gs for PDA register (Jeremy F.)
- Removed the old static rom probing on x86-64. We really trust e820 now.
  This is slightly experimental still. We'll see how it does.
- uncached copy user 
  Not a clear win, but also not a loss. Follow i386.
- Fix 32bit EFI with regparms.
- Fix boot slowdown as VT guest (Zach Amsden) 
- VMI for paravirtualized VMware 
  * first paravirt ops client
  * still some changes missing which need more work
- Various changes in APIC routing setup (Ingo Molnar)  
- Various changes in mmconfig handling (Olivier Galibert, OGAWA Hirofumi, me) 
  * Share code between i386/x86-64
  * Be more aggressive at ignoring bogus MCFG tables 
  * Now supports white lists for some chipsets (currently only Intel 945/915) 
- Some patches for the upcomming AMD Family10 CPUs.
- More init section reference fixes from Vivek
- Some preparation patches for Perfmon
- New NUMA hash function for x86-64 and related changes (Amul Shah) 
- Support a trigger on machine check events on x86-64
- NMI watchdog fixes for Core2 from Venkatesh
- Fix a HPET timer calibration issue on systems with long SMM events at boot (Jack Steiner)
- Fix compat a.out signals on x86-64 
- Lots of small stuff

Not included yet. Might or might not make .21:

- Solution for Nvidia IOMMU corruptions. We could default to iommu=soft for 
  nvidia, but I was still hoping for a workaround from the hardware vendors.
- vDSO support (still trouble with newer toolkits)  
- Xen paravirt ops support from Jeremy/Chris
- Dynamic command line from Bernhard Walle
- Fast getcpu from Dean (requires vDSO) 
- Rewritten RAID XOR functions 
- Fixes for empty nodes from mm
- Fake node improvements for x86-64
- New dynamic IRQ 0 probing to work around all chipset issues
- lguest
  * still seems heavily in development. Not sure it will be ready in time.

Not likely to make .21:
- PAT support (needs some more work and lot more testing) 
- Early firewire support for firescope at early boot

Full list of patches:

Note I will do at least a second review pass before sending them to Linus,
so there might be changes. No guarantee all patches will make it.

defconfig-update
i386-defconfig-update
	Defconfig updates

copy-user-nocache
	Support cache bypassing copy_from_user for file system workloads
	Wasn't a clear win, but also not a clear loss.
#io-apic-reuse
#vdso
	Not yet

#last-branch
	Private Debugging 

make-the-numa-hash-function-nodemap-allocation
convert-i386-pda-code-to-use-%fs
kernel-mode-faults-pollute-current-thead
	Fix for UML

revert-i386-fix-the-verify_quirk_intel_irqbalance
revert-x86_64-mm-add-genapic_force
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
optimize-fix-apic-mode-setup
always-use-physical-delivery-mode-on-8-cpus
remove-clustered-apic-mode
default-to-physical-mode-on-hotplug-cpu-kernels
	genapic changes from Ingo

x86_64-make-the-numa-hash-function-nodemap-allocation-fix-fix
fix-a-typo-in-an-irq-handler-name

mmconfig-share
only-call-unreachable_devices-when-type-1-is-available.
detect-and-support-the-e7520-and-the-945g-gz-p-pl
reserve-resources-but-only-when-were-sure-about-them.
mmconfig-ioremap
mmconfig-reject-broken-table
	mmconfig changes

get-rid-of-arch_have_xtime_lock

a-memcpy-that-tries-to-reduce-cache-pressure
use-memcpy_uncached_read-in-rdma-interrupt-handler-to-reduce-packet-loss
	Infiniband uncached copy support

improved-iommu-documentation
do-not-always-end-the-stack-trace-with-ulong_max
e820-include
	Misc fixes

page-allocation-hooks-for-vmi-backend
paravirt-cpu-hypercall-batching-mode
iopl-handling-for-paravirt-guests
smp-boot-hook-for-paravirt
vmi-backend-for-paravirt-ops
vmi-timer
profile-pc-badness
kprobe-rpl-fix
vmi-timer-race
paravirt-debug-defaults-off
	VMI

move-startup_32-in-text.head-section
break-init-in-two-parts-to-avoid-modpost-warnings
	section warning fixes from Vivek

mcheck-include
add-idle-notifier
	Idle notifier for perfmon 
	
improve-sched_clock-on-i686
romsignature-checksum-cleanup
fix-fake-numa-for-x86_64-machines-with-big-io-hole
remove-fastcall-references-in-x86_64-code
use-constant-instead-of-raw-number-in-x86_64-ioperm.c

handle-32-bit-perfmon-counter-writes-cleanly-in-x86_64-nmi_watchdog
handle-32-bit-perfmon-counter-writes-cleanly-in-i386-nmi_watchdog
handle-32-bit-perfmon-counter-writes-cleanly-in-oprofile
	Core2 NMI watchdog fixes

config_physical_align-limited-to-4m
cleanup-doc-x86_64-files
list-x86_64-quilt-tree
simplify-notify_page_fault
	Misc fixes

mce_amd-issues
mce-trigger
	Machine check trigger support

remove-get_pmd
fix-tlbflush-comment
msr-on-cpu
kconfig-typos
msr-scf-single
mtrr-scf-single
fix-preprocessor-condition
mtrr-compat
	MTRR support for 32bit compat clients
apm-seqfile
fix-size_or_mask-and-size_and_mask
	48 bit MTRR support step 1.
ignore-long-smi-interrupts-in-clock-calibration-code-update-1
	Fix HPET calibration problem when SMI interrupts
putreg-check
unexport-supported-pte
aout-no-vdso
	Fix a.out
fs-gs-clear
	VT boot performance fix
iommu-boundary
efi-regparms
	Fix EFI on 32bit
remove-rom-reservation
	Trust e820 completely. Muahaha!
define-dma-noncoherent-api-functions
robustify-bad_dma_address-handling
fix-laptop-bootup-hang-in-init_acpi
all-transmeta-cpus-have-constant-tscs
avoid-gcc-extension
support-classic-mediagxm
	Support for older Cyrix CPUs
entrys-end-endproc-annotations
clean-up-sparsemem-memory_present-call
arch-i386-kernel-alternativec-should-include-asm-bugsh
remove-unused-kernel-config-option-x86_xadd
	Misc cleanups
update-io-apic-dest-field-to-8-bit-for-xapic
	Fix kexec on es7000 with 8 bit APIC IDs
avoid-warning-message-livelock
minor-patch-for-compilation-warning-in-x86_64-signal-code
dont-include-bugsh
add-option-to-show-more-code-in-oops-reports
32-bit-ptrace-mangles-sixth-system-call-argument
geode-configuration-fixes
survive-having-no-irq-mapping-for-a-vector
fix-gcc-check
	Misc changes
paravirt-remove-fastcall
	Small cleanup
fam10-cpuid
fam10-l3cache
fam10-nmi-watchdog
	AMD family10 support

fix-microcode-warning
i386-fix-transmeta-warning
fails-to-detect-mediagx


-Andi
