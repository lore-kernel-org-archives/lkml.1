Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXGUXxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXGUXxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXGUXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:52:52 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36195 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXGUXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:52:49 -0400
Date: Sat, 21 Jul 2007 16:51:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721235109.GQ3672@sequoia.sous-sol.org>
References: <1184970779.4012.38.camel@chaos> <20070721222509.GI11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721222509.GI11166@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Mackall (mpm@selenic.com) wrote:
> Can we see some stats on:
> 
> How many files were auto-merged?
> How many files got 32.c and 64.c extensions?
> How many existed only in one arch?

It's mostly about file movement first.

 Kbuild                                             |    8 +-
 Makefile                                           |   23 +-
 arch/i386/Kconfig                                  | 1275 +-------------
 arch/i386/Makefile                                 |  208 +--
 arch/i386/kernel/early_printk.c                    |    2 -
 arch/i386/kernel/tsc_sync.c                        |    1 -
 arch/x86/Kconfig                                   | 1919 ++++++++++++++++++++
 arch/{i386 => x86}/Kconfig.cpu                     |    0 
 arch/{i386 => x86}/Kconfig.debug                   |   50 +-
 arch/x86/Kconfig_32                                | 1283 +++++++++++++
 arch/{i386/Kconfig.debug => x86/Kconfig_32.debug}  |    0 
 arch/x86/Kconfig_64                                |  792 ++++++++
 .../{x86_64/Kconfig.debug => x86/Kconfig_64.debug} |    0 
 arch/x86/Makefile                                  |    5 +
 arch/{i386 => x86}/Makefile.cpu                    |    0 
 arch/x86/Makefile_32                               |  163 ++
 arch/x86/Makefile_64                               |  128 ++
 arch/{i386 => x86}/boot/.gitignore                 |    0 
 arch/{i386 => x86}/boot/Makefile                   |    6 +-
 arch/{i386 => x86}/boot/a20.c                      |    0 
 arch/{i386 => x86}/boot/apm.c                      |    0 
 arch/{i386 => x86}/boot/bitops.h                   |    0 
 arch/{i386 => x86}/boot/boot.h                     |    0 
 arch/{i386 => x86}/boot/cmdline.c                  |    0 
 arch/{i386 => x86}/boot/code16gcc.h                |    0 
 arch/{i386 => x86}/boot/compressed/.gitignore      |    0 
 arch/x86/boot/compressed/Makefile                  |    5 +
 .../Makefile => x86/boot/compressed/Makefile_32}   |    8 +-
 .../Makefile => x86/boot/compressed/Makefile_64}   |    8 +-
 .../head.S => x86/boot/compressed/head_32.S}       |    0 
 .../head.S => x86/boot/compressed/head_64.S}       |    0 
 .../misc.c => x86/boot/compressed/misc_32.c}       |    0 
 .../misc.c => x86/boot/compressed/misc_64.c}       |    0 
 arch/{i386 => x86}/boot/compressed/relocs.c        |    0 
 .../boot/compressed/vmlinux_32.lds}                |    0 
 .../boot/compressed/vmlinux_32.scr}                |    0 
 .../boot/compressed/vmlinux_64.lds}                |    0 
 .../boot/compressed/vmlinux_64.scr}                |    0 
 arch/{i386 => x86}/boot/copy.S                     |    0 
 arch/{i386 => x86}/boot/cpu.c                      |    0 
 arch/{i386 => x86}/boot/cpucheck.c                 |    0 
 arch/{i386 => x86}/boot/edd.c                      |    0 
 arch/{i386 => x86}/boot/header.S                   |    0 
 arch/{i386 => x86}/boot/install.sh                 |    0 
 arch/{i386 => x86}/boot/main.c                     |    0 
 arch/{i386 => x86}/boot/mca.c                      |    0 
 arch/{i386 => x86}/boot/memory.c                   |    0 
 arch/{i386 => x86}/boot/mtools.conf.in             |    0 
 arch/{i386 => x86}/boot/pm.c                       |    0 
 arch/{i386 => x86}/boot/pmjump.S                   |    0 
 arch/{i386 => x86}/boot/printf.c                   |    0 
 arch/x86/boot/setup.S                              |    7 +
 arch/{i386 => x86}/boot/setup.ld                   |    0 
 arch/{i386 => x86}/boot/string.c                   |    0 
 arch/{i386 => x86}/boot/tools/.gitignore           |    0 
 arch/{i386 => x86}/boot/tools/build.c              |    0 
 arch/{i386 => x86}/boot/tty.c                      |    0 
 arch/{i386 => x86}/boot/version.c                  |    0 
 arch/{i386 => x86}/boot/vesa.h                     |    0 
 arch/{i386 => x86}/boot/video-bios.c               |    0 
 arch/{i386 => x86}/boot/video-vesa.c               |    0 
 arch/{i386 => x86}/boot/video-vga.c                |    0 
 arch/{i386 => x86}/boot/video.c                    |    0 
 arch/{i386 => x86}/boot/video.h                    |    0 
 arch/{i386 => x86}/boot/voyager.c                  |    0 
 arch/x86/crypto/Makefile                           |    5 +
 .../crypto/Makefile => x86/crypto/Makefile_32}     |    4 +-
 .../crypto/Makefile => x86/crypto/Makefile_64}     |    4 +-
 arch/{i386 => x86}/crypto/aes-i586-asm.S           |    0 
 arch/{x86_64 => x86}/crypto/aes-x86_64-asm.S       |    0 
 arch/{i386/crypto/aes.c => x86/crypto/aes_32.c}    |    0 
 arch/{x86_64/crypto/aes.c => x86/crypto/aes_64.c}  |    0 
 arch/{i386 => x86}/crypto/twofish-i586-asm.S       |    0 
 arch/{x86_64 => x86}/crypto/twofish-x86_64-asm.S   |    0 
 .../crypto/twofish.c => x86/crypto/twofish_32.c}   |    0 
 .../crypto/twofish.c => x86/crypto/twofish_64.c}   |    0 
 arch/{i386/defconfig => x86/defconfig_32}          |    0 
 arch/{x86_64/defconfig => x86/defconfig_64}        |    0 
 arch/{x86_64 => x86}/ia32/Makefile                 |    0 
 arch/{x86_64 => x86}/ia32/audit.c                  |    2 +-
 arch/{x86_64 => x86}/ia32/fpu32.c                  |    0 
 arch/{x86_64 => x86}/ia32/ia32_aout.c              |    0 
 arch/{x86_64 => x86}/ia32/ia32_binfmt.c            |    0 
 arch/{x86_64 => x86}/ia32/ia32_signal.c            |    0 
 arch/{x86_64 => x86}/ia32/ia32entry.S              |    0 
 arch/{x86_64 => x86}/ia32/ipc32.c                  |    2 +-
 arch/{x86_64 => x86}/ia32/mmap32.c                 |    0 
 arch/{x86_64 => x86}/ia32/ptrace32.c               |    0 
 arch/{x86_64 => x86}/ia32/sys_ia32.c               |    0 
 arch/{x86_64 => x86}/ia32/syscall32.c              |    0 
 arch/{x86_64 => x86}/ia32/syscall32_syscall.S      |    4 +-
 arch/{x86_64 => x86}/ia32/tls32.c                  |    0 
 arch/{x86_64 => x86}/ia32/vsyscall-sigreturn.S     |    2 +-
 arch/{x86_64 => x86}/ia32/vsyscall-syscall.S       |    0 
 arch/{x86_64 => x86}/ia32/vsyscall-sysenter.S      |    0 
 arch/{x86_64 => x86}/ia32/vsyscall.lds             |    0 
 arch/{i386 => x86}/kernel/.gitignore               |    0 
 arch/x86/kernel/Makefile                           |    5 +
 .../kernel/Makefile => x86/kernel/Makefile_32}     |   40 +-
 arch/x86/kernel/Makefile_64                        |   55 +
 arch/x86/kernel/acpi/Makefile                      |    5 +
 .../acpi/Makefile => x86/kernel/acpi/Makefile_32}  |    2 +-
 arch/x86/kernel/acpi/Makefile_64                   |    7 +
 arch/{i386 => x86}/kernel/acpi/boot.c              |    0 
 arch/{i386 => x86}/kernel/acpi/cstate.c            |    0 
 arch/{i386 => x86}/kernel/acpi/earlyquirk.c        |    0 
 arch/{i386 => x86}/kernel/acpi/processor.c         |    0 
 .../acpi/sleep.c => x86/kernel/acpi/sleep_32.c}    |    0 
 .../acpi/sleep.c => x86/kernel/acpi/sleep_64.c}    |    0 
 .../acpi/wakeup.S => x86/kernel/acpi/wakeup_32.S}  |    0 
 .../acpi/wakeup.S => x86/kernel/acpi/wakeup_64.S}  |    0 
 arch/{i386 => x86}/kernel/alternative.c            |    0 
 arch/{x86_64 => x86}/kernel/aperture.c             |    0 
 arch/{i386/kernel/apic.c => x86/kernel/apic_32.c}  |    0 
 .../{x86_64/kernel/apic.c => x86/kernel/apic_64.c} |    0 
 arch/{i386 => x86}/kernel/apm.c                    |    0 
 arch/x86/kernel/asm-offsets.c                      |    7 +
 .../asm-offsets.c => x86/kernel/asm-offsets_32.c}  |    0 
 .../asm-offsets.c => x86/kernel/asm-offsets_64.c}  |    0 
 arch/{x86_64 => x86}/kernel/audit.c                |    0 
 arch/{i386 => x86}/kernel/bootflag.c               |    0 
 arch/{x86_64 => x86}/kernel/bugs.c                 |    0 
 arch/{i386 => x86}/kernel/cpu/Makefile             |    0 
 .../kernel/cpu/addon_cpuid_features.c              |    0 
 arch/{i386 => x86}/kernel/cpu/amd.c                |    0 
 arch/{i386 => x86}/kernel/cpu/bugs.c               |    0 
 arch/{i386 => x86}/kernel/cpu/centaur.c            |    0 
 arch/{i386 => x86}/kernel/cpu/common.c             |    0 
 arch/{i386 => x86}/kernel/cpu/cpu.h                |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/Kconfig      |   90 +-
 .../Kconfig => x86/kernel/cpu/cpufreq/Kconfig_32}  |    0 
 .../Kconfig => x86/kernel/cpu/cpufreq/Kconfig_64}  |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/Makefile     |    0 
 .../kernel/cpu/cpufreq/acpi-cpufreq.c              |    0 
 .../kernel/cpu/cpufreq/cpufreq-nforce2.c           |    0 
 .../kernel/cpu/cpufreq/e_powersaver.c              |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/elanfreq.c   |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/gx-suspmod.c |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/longhaul.c   |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/longhaul.h   |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/longrun.c    |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/p4-clockmod.c |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/powernow-k6.c |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/powernow-k7.c |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/powernow-k7.h |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/powernow-k8.c |    0 
 .../{i386 => x86}/kernel/cpu/cpufreq/powernow-k8.h |    0 
 arch/{i386 => x86}/kernel/cpu/cpufreq/sc520_freq.c |    0 
 .../kernel/cpu/cpufreq/speedstep-centrino.c        |    0 
 .../kernel/cpu/cpufreq/speedstep-ich.c             |    0 
 .../kernel/cpu/cpufreq/speedstep-lib.c             |    0 
 .../kernel/cpu/cpufreq/speedstep-lib.h             |    0 
 .../kernel/cpu/cpufreq/speedstep-smi.c             |    0 
 arch/{i386 => x86}/kernel/cpu/cyrix.c              |    0 
 arch/{i386 => x86}/kernel/cpu/intel.c              |    0 
 arch/{i386 => x86}/kernel/cpu/intel_cacheinfo.c    |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/Makefile      |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/k7.c          |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/mce.c         |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/mce.h         |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/non-fatal.c   |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/p4.c          |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/p5.c          |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/p6.c          |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/therm_throt.c |    0 
 arch/{i386 => x86}/kernel/cpu/mcheck/winchip.c     |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/Makefile        |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/amd.c           |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/centaur.c       |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/cyrix.c         |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/generic.c       |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/if.c            |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/main.c          |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/mtrr.h          |    0 
 arch/{i386 => x86}/kernel/cpu/mtrr/state.c         |    0 
 arch/{i386 => x86}/kernel/cpu/nexgen.c             |    0 
 arch/{i386 => x86}/kernel/cpu/perfctr-watchdog.c   |    0 
 arch/{i386 => x86}/kernel/cpu/proc.c               |    0 
 arch/{i386 => x86}/kernel/cpu/rise.c               |    0 
 arch/{i386 => x86}/kernel/cpu/transmeta.c          |    0 
 arch/{i386 => x86}/kernel/cpu/umc.c                |    0 
 arch/{x86_64 => x86}/kernel/cpufreq/Makefile       |    2 +-
 arch/{i386 => x86}/kernel/cpuid.c                  |    0 
 .../{i386/kernel/crash.c => x86/kernel/crash_32.c} |    0 
 .../kernel/crash.c => x86/kernel/crash_64.c}       |    0 
 .../crash_dump.c => x86/kernel/crash_dump_32.c}    |    0 
 .../crash_dump.c => x86/kernel/crash_dump_64.c}    |    0 
 arch/{i386 => x86}/kernel/doublefault.c            |    0 
 arch/{i386/kernel/e820.c => x86/kernel/e820_32.c}  |    0 
 .../{x86_64/kernel/e820.c => x86/kernel/e820_64.c} |    0 
 arch/{x86_64 => x86}/kernel/early-quirks.c         |    0 
 arch/{x86_64 => x86}/kernel/early_printk.c         |    0 
 arch/{i386 => x86}/kernel/efi.c                    |    0 
 arch/{i386 => x86}/kernel/efi_stub.S               |    0 
 .../{i386/kernel/entry.S => x86/kernel/entry_32.S} |    0 
 .../kernel/entry.S => x86/kernel/entry_64.S}       |    0 
 arch/{x86_64 => x86}/kernel/genapic.c              |    0 
 arch/{x86_64 => x86}/kernel/genapic_flat.c         |    0 
 arch/{x86_64 => x86}/kernel/head64.c               |    0 
 arch/{i386/kernel/head.S => x86/kernel/head_32.S}  |    0 
 .../{x86_64/kernel/head.S => x86/kernel/head_64.S} |    0 
 arch/{i386/kernel/hpet.c => x86/kernel/hpet_32.c}  |    0 
 .../{x86_64/kernel/hpet.c => x86/kernel/hpet_64.c} |    0 
 arch/{i386 => x86}/kernel/i386_ksyms.c             |    0 
 arch/{i386/kernel/i387.c => x86/kernel/i387_32.c}  |    0 
 .../{x86_64/kernel/i387.c => x86/kernel/i387_64.c} |    0 
 arch/{i386 => x86}/kernel/i8237.c                  |    0 
 arch/{i386 => x86}/kernel/i8253.c                  |    0 
 .../{i386/kernel/i8259.c => x86/kernel/i8259_32.c} |    0 
 .../kernel/i8259.c => x86/kernel/i8259_64.c}       |    0 
 .../init_task.c => x86/kernel/init_task_32.c}      |    0 
 .../init_task.c => x86/kernel/init_task_64.c}      |    0 
 .../kernel/io_apic.c => x86/kernel/io_apic_32.c}   |    0 
 .../kernel/io_apic.c => x86/kernel/io_apic_64.c}   |    0 
 .../kernel/ioport.c => x86/kernel/ioport_32.c}     |    0 
 .../kernel/ioport.c => x86/kernel/ioport_64.c}     |    0 
 arch/{i386/kernel/irq.c => x86/kernel/irq_32.c}    |    0 
 arch/{x86_64/kernel/irq.c => x86/kernel/irq_64.c}  |    0 
 arch/{x86_64 => x86}/kernel/k8.c                   |    0 
 .../kernel/kprobes.c => x86/kernel/kprobes_32.c}   |    0 
 .../kernel/kprobes.c => x86/kernel/kprobes_64.c}   |    0 
 arch/{i386/kernel/ldt.c => x86/kernel/ldt_32.c}    |    0 
 arch/{x86_64/kernel/ldt.c => x86/kernel/ldt_64.c}  |    0 
 arch/{i386 => x86}/kernel/legacy_serial.c          |    0 
 .../kernel/machine_kexec_32.c}                     |    0 
 .../kernel/machine_kexec_64.c}                     |    0 
 arch/{i386 => x86}/kernel/mca.c                    |    0 
 arch/{x86_64 => x86}/kernel/mce.c                  |    0 
 arch/{x86_64 => x86}/kernel/mce_amd.c              |    0 
 arch/{x86_64 => x86}/kernel/mce_intel.c            |    0 
 arch/{i386 => x86}/kernel/microcode.c              |    0 
 .../kernel/module.c => x86/kernel/module_32.c}     |    0 
 .../kernel/module.c => x86/kernel/module_64.c}     |    0 
 .../kernel/mpparse.c => x86/kernel/mpparse_32.c}   |    0 
 .../kernel/mpparse.c => x86/kernel/mpparse_64.c}   |    0 
 arch/{i386 => x86}/kernel/msr.c                    |    0 
 arch/{i386/kernel/nmi.c => x86/kernel/nmi_32.c}    |    0 
 arch/{x86_64/kernel/nmi.c => x86/kernel/nmi_64.c}  |    0 
 arch/{i386 => x86}/kernel/numaq.c                  |    0 
 arch/{i386 => x86}/kernel/paravirt.c               |    0 
 arch/{x86_64 => x86}/kernel/pci-calgary.c          |    0 
 .../kernel/pci-dma.c => x86/kernel/pci-dma_32.c}   |    0 
 .../kernel/pci-dma.c => x86/kernel/pci-dma_64.c}   |    0 
 arch/{x86_64 => x86}/kernel/pci-gart.c             |    0 
 arch/{x86_64 => x86}/kernel/pci-nommu.c            |    0 
 arch/{x86_64 => x86}/kernel/pci-swiotlb.c          |    0 
 arch/{i386 => x86}/kernel/pcspeaker.c              |    0 
 arch/{x86_64 => x86}/kernel/pmtimer.c              |    0 
 .../kernel/process.c => x86/kernel/process_32.c}   |    0 
 .../kernel/process.c => x86/kernel/process_64.c}   |    0 
 .../kernel/ptrace.c => x86/kernel/ptrace_32.c}     |    0 
 .../kernel/ptrace.c => x86/kernel/ptrace_64.c}     |    0 
 arch/{i386 => x86}/kernel/quirks.c                 |    0 
 .../kernel/reboot.c => x86/kernel/reboot_32.c}     |    0 
 .../kernel/reboot.c => x86/kernel/reboot_64.c}     |    0 
 arch/{i386 => x86}/kernel/reboot_fixups.c          |    0 
 .../kernel/relocate_kernel_32.S}                   |    0 
 .../kernel/relocate_kernel_64.S}                   |    0 
 arch/{i386 => x86}/kernel/scx200.c                 |    0 
 arch/{x86_64 => x86}/kernel/setup64.c              |    0 
 .../{i386/kernel/setup.c => x86/kernel/setup_32.c} |    0 
 .../kernel/setup.c => x86/kernel/setup_64.c}       |    0 
 arch/{i386 => x86}/kernel/sigframe.h               |    0 
 .../kernel/signal.c => x86/kernel/signal_32.c}     |    0 
 .../kernel/signal.c => x86/kernel/signal_64.c}     |    0 
 arch/{i386/kernel/smp.c => x86/kernel/smp_32.c}    |    0 
 arch/{x86_64/kernel/smp.c => x86/kernel/smp_64.c}  |    0 
 .../kernel/smpboot.c => x86/kernel/smpboot_32.c}   |    0 
 .../kernel/smpboot.c => x86/kernel/smpboot_64.c}   |    0 
 arch/{i386 => x86}/kernel/smpcommon.c              |    0 
 arch/{i386 => x86}/kernel/srat.c                   |    0 
 arch/{x86_64 => x86}/kernel/stacktrace.c           |    0 
 arch/{i386 => x86}/kernel/summit.c                 |    0 
 arch/{x86_64 => x86}/kernel/suspend.c              |    0 
 arch/{x86_64 => x86}/kernel/suspend_asm.S          |    0 
 arch/{i386 => x86}/kernel/sys_i386.c               |    0 
 arch/{x86_64 => x86}/kernel/sys_x86_64.c           |    0 
 arch/{x86_64 => x86}/kernel/syscall.c              |    4 +-
 arch/{i386 => x86}/kernel/syscall_table.S          |    0 
 arch/{i386 => x86}/kernel/sysenter.c               |    0 
 arch/{x86_64 => x86}/kernel/tce.c                  |    0 
 arch/{i386/kernel/time.c => x86/kernel/time_32.c}  |    0 
 .../{x86_64/kernel/time.c => x86/kernel/time_64.c} |    0 
 arch/{i386 => x86}/kernel/topology.c               |    0 
 .../trampoline.S => x86/kernel/trampoline_32.S}    |    0 
 .../trampoline.S => x86/kernel/trampoline_64.S}    |    0 
 .../{i386/kernel/traps.c => x86/kernel/traps_32.c} |    0 
 .../kernel/traps.c => x86/kernel/traps_64.c}       |    0 
 arch/{i386/kernel/tsc.c => x86/kernel/tsc_32.c}    |    0 
 arch/{x86_64/kernel/tsc.c => x86/kernel/tsc_64.c}  |    0 
 arch/{x86_64 => x86}/kernel/tsc_sync.c             |    0 
 arch/{x86_64 => x86}/kernel/verify_cpu.S           |    0 
 arch/{i386 => x86}/kernel/vm86.c                   |    0 
 arch/{i386 => x86}/kernel/vmi.c                    |    0 
 arch/{i386 => x86}/kernel/vmiclock.c               |    0 
 arch/x86/kernel/vmlinux.lds.S                      |    7 +
 .../vmlinux.lds.S => x86/kernel/vmlinux.lds_32.S}  |    0 
 .../vmlinux.lds.S => x86/kernel/vmlinux.lds_64.S}  |    0 
 arch/{x86_64 => x86}/kernel/vsmp.c                 |    0 
 arch/{i386 => x86}/kernel/vsyscall-int80.S         |    0 
 arch/{i386 => x86}/kernel/vsyscall-note.S          |    0 
 arch/{i386 => x86}/kernel/vsyscall-sigreturn.S     |    0 
 arch/{i386 => x86}/kernel/vsyscall-sysenter.S      |    0 
 arch/{i386 => x86}/kernel/vsyscall.lds.S           |    0 
 .../kernel/vsyscall.S => x86/kernel/vsyscall_32.S} |    4 +-
 .../kernel/vsyscall.c => x86/kernel/vsyscall_64.c} |    0 
 arch/{x86_64 => x86}/kernel/x8664_ksyms.c          |    0 
 arch/x86/lib/Makefile                              |    5 +
 arch/{i386/lib/Makefile => x86/lib/Makefile_32}    |    4 +-
 arch/x86/lib/Makefile_64                           |   13 +
 arch/{i386/lib/bitops.c => x86/lib/bitops_32.c}    |    0 
 arch/{x86_64/lib/bitops.c => x86/lib/bitops_64.c}  |    0 
 arch/{x86_64 => x86}/lib/bitstr.c                  |    0 
 arch/{i386 => x86}/lib/checksum.S                  |    0 
 arch/{x86_64 => x86}/lib/clear_page.S              |    0 
 arch/{x86_64 => x86}/lib/copy_page.S               |    0 
 arch/{x86_64 => x86}/lib/copy_user.S               |    0 
 arch/{x86_64 => x86}/lib/copy_user_nocache.S       |    0 
 arch/{x86_64 => x86}/lib/csum-copy.S               |    0 
 arch/{x86_64 => x86}/lib/csum-partial.c            |    0 
 arch/{x86_64 => x86}/lib/csum-wrappers.c           |    0 
 arch/{i386/lib/delay.c => x86/lib/delay_32.c}      |    0 
 arch/{x86_64/lib/delay.c => x86/lib/delay_64.c}    |    0 
 arch/{i386/lib/getuser.S => x86/lib/getuser_32.S}  |    0 
 .../{x86_64/lib/getuser.S => x86/lib/getuser_64.S} |    0 
 arch/{x86_64 => x86}/lib/io.c                      |    0 
 arch/{x86_64 => x86}/lib/iomap_copy.S              |    0 
 arch/{i386/lib/memcpy.c => x86/lib/memcpy_32.c}    |    0 
 arch/{x86_64/lib/memcpy.S => x86/lib/memcpy_64.S}  |    0 
 arch/{x86_64 => x86}/lib/memmove.c                 |    0 
 arch/{x86_64 => x86}/lib/memset.S                  |    0 
 arch/{i386 => x86}/lib/mmx.c                       |    0 
 arch/{i386 => x86}/lib/msr-on-cpu.c                |    0 
 arch/{i386/lib/putuser.S => x86/lib/putuser_32.S}  |    0 
 .../{x86_64/lib/putuser.S => x86/lib/putuser_64.S} |    0 
 arch/{x86_64 => x86}/lib/rwlock.S                  |    0 
 arch/{i386 => x86}/lib/semaphore.S                 |    0 
 arch/{i386 => x86}/lib/strstr.c                    |    0 
 arch/{x86_64 => x86}/lib/thunk.S                   |    0 
 .../{i386/lib/usercopy.c => x86/lib/usercopy_32.c} |    0 
 .../lib/usercopy.c => x86/lib/usercopy_64.c}       |    0 
 arch/{i386 => x86}/mach-default/Makefile           |    0 
 arch/{i386 => x86}/mach-default/setup.c            |    0 
 arch/{i386 => x86}/mach-es7000/Makefile            |    0 
 arch/{i386 => x86}/mach-es7000/es7000.h            |    0 
 arch/{i386 => x86}/mach-es7000/es7000plat.c        |    0 
 arch/{i386 => x86}/mach-generic/Makefile           |    0 
 arch/{i386 => x86}/mach-generic/bigsmp.c           |    0 
 arch/{i386 => x86}/mach-generic/default.c          |    0 
 arch/{i386 => x86}/mach-generic/es7000.c           |    0 
 arch/{i386 => x86}/mach-generic/probe.c            |    0 
 arch/{i386 => x86}/mach-generic/summit.c           |    0 
 arch/{i386 => x86}/mach-visws/Makefile             |    0 
 arch/{i386 => x86}/mach-visws/mpparse.c            |    0 
 arch/{i386 => x86}/mach-visws/reboot.c             |    0 
 arch/{i386 => x86}/mach-visws/setup.c              |    0 
 arch/{i386 => x86}/mach-visws/traps.c              |    0 
 arch/{i386 => x86}/mach-visws/visws_apic.c         |    0 
 arch/{i386 => x86}/mach-voyager/Makefile           |    0 
 arch/{i386 => x86}/mach-voyager/setup.c            |    0 
 arch/{i386 => x86}/mach-voyager/voyager_basic.c    |    0 
 arch/{i386 => x86}/mach-voyager/voyager_cat.c      |    0 
 arch/{i386 => x86}/mach-voyager/voyager_smp.c      |    0 
 arch/{i386 => x86}/mach-voyager/voyager_thread.c   |    0 
 arch/{i386 => x86}/math-emu/Makefile               |    0 
 arch/{i386 => x86}/math-emu/README                 |    0 
 arch/{i386 => x86}/math-emu/control_w.h            |    0 
 arch/{i386 => x86}/math-emu/div_Xsig.S             |    0 
 arch/{i386 => x86}/math-emu/div_small.S            |    0 
 arch/{i386 => x86}/math-emu/errors.c               |    0 
 arch/{i386 => x86}/math-emu/exception.h            |    0 
 arch/{i386 => x86}/math-emu/fpu_arith.c            |    0 
 arch/{i386 => x86}/math-emu/fpu_asm.h              |    0 
 arch/{i386 => x86}/math-emu/fpu_aux.c              |    0 
 arch/{i386 => x86}/math-emu/fpu_emu.h              |    0 
 arch/{i386 => x86}/math-emu/fpu_entry.c            |    0 
 arch/{i386 => x86}/math-emu/fpu_etc.c              |    0 
 arch/{i386 => x86}/math-emu/fpu_proto.h            |    0 
 arch/{i386 => x86}/math-emu/fpu_system.h           |    0 
 arch/{i386 => x86}/math-emu/fpu_tags.c             |    0 
 arch/{i386 => x86}/math-emu/fpu_trig.c             |    0 
 arch/{i386 => x86}/math-emu/get_address.c          |    0 
 arch/{i386 => x86}/math-emu/load_store.c           |    0 
 arch/{i386 => x86}/math-emu/mul_Xsig.S             |    0 
 arch/{i386 => x86}/math-emu/poly.h                 |    0 
 arch/{i386 => x86}/math-emu/poly_2xm1.c            |    0 
 arch/{i386 => x86}/math-emu/poly_atan.c            |    0 
 arch/{i386 => x86}/math-emu/poly_l2.c              |    0 
 arch/{i386 => x86}/math-emu/poly_sin.c             |    0 
 arch/{i386 => x86}/math-emu/poly_tan.c             |    0 
 arch/{i386 => x86}/math-emu/polynom_Xsig.S         |    0 
 arch/{i386 => x86}/math-emu/reg_add_sub.c          |    0 
 arch/{i386 => x86}/math-emu/reg_compare.c          |    0 
 arch/{i386 => x86}/math-emu/reg_constant.c         |    0 
 arch/{i386 => x86}/math-emu/reg_constant.h         |    0 
 arch/{i386 => x86}/math-emu/reg_convert.c          |    0 
 arch/{i386 => x86}/math-emu/reg_divide.c           |    0 
 arch/{i386 => x86}/math-emu/reg_ld_str.c           |    0 
 arch/{i386 => x86}/math-emu/reg_mul.c              |    0 
 arch/{i386 => x86}/math-emu/reg_norm.S             |    0 
 arch/{i386 => x86}/math-emu/reg_round.S            |    0 
 arch/{i386 => x86}/math-emu/reg_u_add.S            |    0 
 arch/{i386 => x86}/math-emu/reg_u_div.S            |    0 
 arch/{i386 => x86}/math-emu/reg_u_mul.S            |    0 
 arch/{i386 => x86}/math-emu/reg_u_sub.S            |    0 
 arch/{i386 => x86}/math-emu/round_Xsig.S           |    0 
 arch/{i386 => x86}/math-emu/shr_Xsig.S             |    0 
 arch/{i386 => x86}/math-emu/status_w.h             |    0 
 arch/{i386 => x86}/math-emu/version.h              |    0 
 arch/{i386 => x86}/math-emu/wm_shrx.S              |    0 
 arch/{i386 => x86}/math-emu/wm_sqrt.S              |    0 
 arch/x86/mm/Makefile                               |    5 +
 arch/{i386/mm/Makefile => x86/mm/Makefile_32}      |    2 +-
 arch/{x86_64/mm/Makefile => x86/mm/Makefile_64}    |    3 +-
 arch/{i386 => x86}/mm/boot_ioremap.c               |    0 
 arch/{i386 => x86}/mm/discontig.c                  |    0 
 arch/{i386/mm/extable.c => x86/mm/extable_32.c}    |    0 
 arch/{x86_64/mm/extable.c => x86/mm/extable_64.c}  |    0 
 arch/{i386/mm/fault.c => x86/mm/fault_32.c}        |    0 
 arch/{x86_64/mm/fault.c => x86/mm/fault_64.c}      |    0 
 arch/{i386 => x86}/mm/highmem.c                    |    0 
 arch/{i386 => x86}/mm/hugetlbpage.c                |    0 
 arch/{i386/mm/init.c => x86/mm/init_32.c}          |    0 
 arch/{x86_64/mm/init.c => x86/mm/init_64.c}        |    0 
 arch/{i386/mm/ioremap.c => x86/mm/ioremap_32.c}    |    0 
 arch/{x86_64/mm/ioremap.c => x86/mm/ioremap_64.c}  |    0 
 arch/{x86_64 => x86}/mm/k8topology.c               |    0 
 arch/{i386/mm/mmap.c => x86/mm/mmap_32.c}          |    0 
 arch/{x86_64/mm/mmap.c => x86/mm/mmap_64.c}        |    0 
 arch/{x86_64 => x86}/mm/numa.c                     |    0 
 arch/{i386/mm/pageattr.c => x86/mm/pageattr_32.c}  |    0 
 .../{x86_64/mm/pageattr.c => x86/mm/pageattr_64.c} |    0 
 arch/{i386 => x86}/mm/pgtable.c                    |    0 
 arch/{x86_64 => x86}/mm/srat.c                     |    0 
 arch/{i386 => x86}/oprofile/Kconfig                |    0 
 arch/x86/oprofile/Makefile                         |    5 +
 .../oprofile/Makefile => x86/oprofile/Makefile_32} |    0 
 .../oprofile/Makefile => x86/oprofile/Makefile_64} |    7 +-
 arch/{i386 => x86}/oprofile/backtrace.c            |    0 
 arch/{i386 => x86}/oprofile/init.c                 |    0 
 arch/{i386 => x86}/oprofile/nmi_int.c              |    0 
 arch/{i386 => x86}/oprofile/nmi_timer_int.c        |    0 
 arch/{i386 => x86}/oprofile/op_counter.h           |    0 
 arch/{i386 => x86}/oprofile/op_model_athlon.c      |    0 
 arch/{i386 => x86}/oprofile/op_model_p4.c          |    0 
 arch/{i386 => x86}/oprofile/op_model_ppro.c        |    0 
 arch/{i386 => x86}/oprofile/op_x86_model.h         |    0 
 arch/x86/pci/Makefile                              |    5 +
 arch/{i386/pci/Makefile => x86/pci/Makefile_32}    |    2 +-
 arch/x86/pci/Makefile_64                           |   17 +
 arch/{i386 => x86}/pci/acpi.c                      |    0 
 arch/{i386 => x86}/pci/common.c                    |    0 
 arch/{i386 => x86}/pci/direct.c                    |    0 
 arch/{i386 => x86}/pci/early.c                     |    0 
 arch/{i386 => x86}/pci/fixup.c                     |    0 
 arch/{i386 => x86}/pci/i386.c                      |    0 
 arch/{i386 => x86}/pci/init.c                      |    0 
 arch/{i386 => x86}/pci/irq.c                       |    0 
 arch/{x86_64 => x86}/pci/k8-bus.c                  |    0 
 arch/{i386 => x86}/pci/legacy.c                    |    0 
 arch/{i386 => x86}/pci/mmconfig-shared.c           |    0 
 .../{i386/pci/mmconfig.c => x86/pci/mmconfig_32.c} |    0 
 .../pci/mmconfig.c => x86/pci/mmconfig_64.c}       |    0 
 arch/{i386 => x86}/pci/numa.c                      |    0 
 arch/{i386 => x86}/pci/pcbios.c                    |    0 
 arch/{i386 => x86}/pci/pci.h                       |    0 
 arch/{i386 => x86}/pci/visws.c                     |    0 
 arch/{i386 => x86}/power/Makefile                  |    0 
 arch/{i386 => x86}/power/cpu.c                     |    0 
 arch/{i386 => x86}/power/suspend.c                 |    0 
 arch/{i386 => x86}/power/swsusp.S                  |    0 
 arch/{i386 => x86}/video/Makefile                  |    0 
 arch/{i386 => x86}/video/fbdev.c                   |    0 
 arch/{i386 => x86}/xen/Kconfig                     |    0 
 arch/{i386 => x86}/xen/Makefile                    |    0 
 arch/{i386 => x86}/xen/enlighten.c                 |    0 
 arch/{i386 => x86}/xen/events.c                    |    0 
 arch/{i386 => x86}/xen/features.c                  |    0 
 arch/{i386 => x86}/xen/manage.c                    |    0 
 arch/{i386 => x86}/xen/mmu.c                       |    0 
 arch/{i386 => x86}/xen/mmu.h                       |    0 
 arch/{i386 => x86}/xen/multicalls.c                |    0 
 arch/{i386 => x86}/xen/multicalls.h                |    0 
 arch/{i386 => x86}/xen/setup.c                     |    0 
 arch/{i386 => x86}/xen/smp.c                       |    0 
 arch/{i386 => x86}/xen/time.c                      |    0 
 arch/{i386 => x86}/xen/vdso.h                      |    0 
 arch/{i386 => x86}/xen/xen-asm.S                   |    0 
 arch/{i386 => x86}/xen/xen-head.S                  |    0 
 arch/{i386 => x86}/xen/xen-ops.h                   |    0 
 arch/x86_64/Kconfig                                |  788 +--------
 arch/x86_64/Makefile                               |  184 +--
 arch/x86_64/boot/.gitignore                        |    5 -
 arch/x86_64/boot/Makefile                          |    9 -
 arch/x86_64/boot/tools/.gitignore                  |    1 -
 arch/x86_64/kernel/Makefile                        |   65 -
 arch/x86_64/kernel/acpi/Makefile                   |    9 -
 arch/x86_64/lib/Makefile                           |   13 -
 arch/x86_64/lib/msr-on-cpu.c                       |    1 -
 arch/x86_64/oprofile/Kconfig                       |   17 -
 arch/x86_64/pci/Makefile                           |   27 -
 drivers/pci/hotplug/cpqphp_core.c                  |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c                   |    2 +-
 drivers/pci/hotplug/ibmphp_core.c                  |    2 +-
 include/asm-i386/k8.h                              |    1 -
 include/asm-i386/mach-es7000/mach_apicdef.h        |   13 -
 include/asm-i386/mach-summit/irq_vectors_limits.h  |   14 -
 include/asm-i386/mach-summit/mach_apicdef.h        |   13 -
 include/asm-i386/mach-summit/mach_ipi.h            |   25 -
 include/asm-i386/pci-direct.h                      |    1 -
 include/asm-i386/stacktrace.h                      |    1 -
 .../{asm-i386/8253pit.h => asm-x86/8253pit_32.h}   |    0 
 .../{asm-x86_64/8253pit.h => asm-x86/8253pit_64.h} |    0 
 include/{asm-i386/Kbuild => asm-x86/Kbuild_32}     |    0 
 include/{asm-x86_64/Kbuild => asm-x86/Kbuild_64}   |    0 
 include/{asm-i386/a.out.h => asm-x86/a.out_32.h}   |    0 
 include/{asm-x86_64/a.out.h => asm-x86/a.out_64.h} |    0 
 include/{asm-i386/acpi.h => asm-x86/acpi_32.h}     |    0 
 include/{asm-x86_64/acpi.h => asm-x86/acpi_64.h}   |    0 
 include/{asm-i386/agp.h => asm-x86/agp_32.h}       |    0 
 include/{asm-x86_64/agp.h => asm-x86/agp_64.h}     |    0 
 .../alternative-asm_32.i}                          |    0 
 .../alternative-asm_64.i}                          |    0 
 .../alternative.h => asm-x86/alternative_32.h}     |    0 
 .../alternative.h => asm-x86/alternative_64.h}     |    0 
 include/{asm-i386/apic.h => asm-x86/apic_32.h}     |    0 
 include/{asm-x86_64/apic.h => asm-x86/apic_64.h}   |    0 
 .../{asm-i386/apicdef.h => asm-x86/apicdef_32.h}   |    0 
 .../{asm-x86_64/apicdef.h => asm-x86/apicdef_64.h} |    0 
 include/{asm-i386 => asm-x86}/arch_hooks.h         |    0 
 include/{asm-i386/atomic.h => asm-x86/atomic_32.h} |    0 
 .../{asm-x86_64/atomic.h => asm-x86/atomic_64.h}   |    0 
 include/{asm-i386/auxvec.h => asm-x86/auxvec_32.h} |    0 
 .../{asm-x86_64/auxvec.h => asm-x86/auxvec_64.h}   |    0 
 include/{asm-i386/bitops.h => asm-x86/bitops_32.h} |    0 
 .../{asm-x86_64/bitops.h => asm-x86/bitops_64.h}   |    0 
 include/{asm-i386 => asm-x86}/boot.h               |    0 
 include/{asm-i386 => asm-x86}/bootparam.h          |    0 
 include/{asm-x86_64 => asm-x86}/bootsetup.h        |    0 
 include/{asm-i386/bug.h => asm-x86/bug_32.h}       |    0 
 include/{asm-x86_64/bug.h => asm-x86/bug_64.h}     |    0 
 include/{asm-i386/bugs.h => asm-x86/bugs_32.h}     |    0 
 include/{asm-x86_64/bugs.h => asm-x86/bugs_64.h}   |    0 
 .../byteorder.h => asm-x86/byteorder_32.h}         |    0 
 .../byteorder.h => asm-x86/byteorder_64.h}         |    0 
 include/{asm-i386/cache.h => asm-x86/cache_32.h}   |    0 
 include/{asm-x86_64/cache.h => asm-x86/cache_64.h} |    0 
 .../cacheflush.h => asm-x86/cacheflush_32.h}       |    0 
 .../cacheflush.h => asm-x86/cacheflush_64.h}       |    0 
 include/{asm-x86_64 => asm-x86}/calgary.h          |    0 
 include/{asm-x86_64 => asm-x86}/calling.h          |    0 
 .../{asm-i386/checksum.h => asm-x86/checksum_32.h} |    0 
 .../checksum.h => asm-x86/checksum_64.h}           |    0 
 .../{asm-i386/cmpxchg.h => asm-x86/cmpxchg_32.h}   |    0 
 .../{asm-x86_64/cmpxchg.h => asm-x86/cmpxchg_64.h} |    0 
 include/{asm-x86_64 => asm-x86}/compat.h           |    0 
 include/{asm-i386 => asm-x86}/cpu.h                |    0 
 include/{asm-i386 => asm-x86}/cpufeature.h         |    0 
 .../{asm-i386/cputime.h => asm-x86/cputime_32.h}   |    0 
 .../{asm-x86_64/cputime.h => asm-x86/cputime_64.h} |    0 
 .../{asm-i386/current.h => asm-x86/current_32.h}   |    0 
 .../{asm-x86_64/current.h => asm-x86/current_64.h} |    0 
 .../{asm-i386/debugreg.h => asm-x86/debugreg_32.h} |    0 
 .../debugreg.h => asm-x86/debugreg_64.h}           |    0 
 include/{asm-i386/delay.h => asm-x86/delay_32.h}   |    0 
 include/{asm-x86_64/delay.h => asm-x86/delay_64.h} |    0 
 include/{asm-i386/desc.h => asm-x86/desc_32.h}     |    0 
 include/{asm-x86_64/desc.h => asm-x86/desc_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/desc_defs.h        |    0 
 include/{asm-i386/device.h => asm-x86/device_32.h} |    0 
 .../{asm-x86_64/device.h => asm-x86/device_64.h}   |    0 
 include/{asm-i386/div64.h => asm-x86/div64_32.h}   |    0 
 include/{asm-x86_64/div64.h => asm-x86/div64_64.h} |    0 
 .../dma-mapping.h => asm-x86/dma-mapping_32.h}     |    0 
 .../dma-mapping.h => asm-x86/dma-mapping_64.h}     |    0 
 include/{asm-i386/dma.h => asm-x86/dma_32.h}       |    0 
 include/{asm-x86_64/dma.h => asm-x86/dma_64.h}     |    0 
 include/{asm-i386/dmi.h => asm-x86/dmi_32.h}       |    0 
 include/{asm-x86_64/dmi.h => asm-x86/dmi_64.h}     |    0 
 include/{asm-i386/dwarf2.h => asm-x86/dwarf2_32.h} |    0 
 .../{asm-x86_64/dwarf2.h => asm-x86/dwarf2_64.h}   |    0 
 include/{asm-i386/e820.h => asm-x86/e820_32.h}     |    0 
 include/{asm-x86_64/e820.h => asm-x86/e820_64.h}   |    0 
 include/{asm-i386/edac.h => asm-x86/edac_32.h}     |    0 
 include/{asm-x86_64/edac.h => asm-x86/edac_64.h}   |    0 
 include/{asm-i386/elf.h => asm-x86/elf_32.h}       |    0 
 include/{asm-x86_64/elf.h => asm-x86/elf_64.h}     |    0 
 include/{asm-i386 => asm-x86}/emergency-restart.h  |    0 
 include/{asm-i386/errno.h => asm-x86/errno_32.h}   |    0 
 include/{asm-x86_64/errno.h => asm-x86/errno_64.h} |    0 
 include/{asm-i386/fb.h => asm-x86/fb_32.h}         |    0 
 include/{asm-x86_64/fb.h => asm-x86/fb_64.h}       |    0 
 include/{asm-i386 => asm-x86}/fcntl.h              |    0 
 include/{asm-i386/fixmap.h => asm-x86/fixmap_32.h} |    0 
 .../{asm-x86_64/fixmap.h => asm-x86/fixmap_64.h}   |    0 
 include/{asm-i386/floppy.h => asm-x86/floppy_32.h} |    0 
 .../{asm-x86_64/floppy.h => asm-x86/floppy_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/fpu32.h            |    0 
 include/{asm-i386 => asm-x86}/frame.i              |    0 
 include/{asm-i386/futex.h => asm-x86/futex_32.h}   |    0 
 include/{asm-x86_64/futex.h => asm-x86/futex_64.h} |    0 
 .../{asm-i386/genapic.h => asm-x86/genapic_32.h}   |    0 
 .../{asm-x86_64/genapic.h => asm-x86/genapic_64.h} |    0 
 .../{asm-i386/hardirq.h => asm-x86/hardirq_32.h}   |    0 
 .../{asm-x86_64/hardirq.h => asm-x86/hardirq_64.h} |    0 
 include/{asm-i386 => asm-x86}/highmem.h            |    0 
 include/{asm-i386/hpet.h => asm-x86/hpet_32.h}     |    0 
 include/{asm-x86_64/hpet.h => asm-x86/hpet_64.h}   |    0 
 include/{asm-i386/hw_irq.h => asm-x86/hw_irq_32.h} |    0 
 .../{asm-x86_64/hw_irq.h => asm-x86/hw_irq_64.h}   |    0 
 include/{asm-i386 => asm-x86}/hypertransport.h     |    0 
 include/{asm-i386/i387.h => asm-x86/i387_32.h}     |    0 
 include/{asm-x86_64/i387.h => asm-x86/i387_64.h}   |    0 
 include/{asm-i386 => asm-x86}/i8253.h              |    0 
 include/{asm-i386 => asm-x86}/i8259.h              |    0 
 include/{asm-x86_64 => asm-x86}/ia32.h             |    0 
 include/{asm-x86_64 => asm-x86}/ia32_unistd.h      |    0 
 include/{asm-i386 => asm-x86}/ide.h                |    0 
 include/{asm-x86_64 => asm-x86}/idle.h             |    0 
 .../intel_arch_perfmon_32.h}                       |    0 
 .../intel_arch_perfmon_64.h}                       |    0 
 include/{asm-i386/io.h => asm-x86/io_32.h}         |    0 
 include/{asm-x86_64/io.h => asm-x86/io_64.h}       |    0 
 .../{asm-i386/io_apic.h => asm-x86/io_apic_32.h}   |    0 
 .../{asm-x86_64/io_apic.h => asm-x86/io_apic_64.h} |    0 
 include/{asm-i386 => asm-x86}/ioctl.h              |    0 
 include/{asm-i386/ioctls.h => asm-x86/ioctls_32.h} |    0 
 .../{asm-x86_64/ioctls.h => asm-x86/ioctls_64.h}   |    0 
 include/{asm-i386 => asm-x86}/ipc.h                |    0 
 include/{asm-i386/ipcbuf.h => asm-x86/ipcbuf_32.h} |    0 
 .../{asm-x86_64/ipcbuf.h => asm-x86/ipcbuf_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/ipi.h              |    0 
 include/{asm-i386/irq.h => asm-x86/irq_32.h}       |    0 
 include/{asm-x86_64/irq.h => asm-x86/irq_64.h}     |    0 
 .../{asm-i386/irq_regs.h => asm-x86/irq_regs_32.h} |    0 
 .../irq_regs.h => asm-x86/irq_regs_64.h}           |    0 
 .../{asm-i386/irqflags.h => asm-x86/irqflags_32.h} |    0 
 .../irqflags.h => asm-x86/irqflags_64.h}           |    0 
 include/{asm-i386 => asm-x86}/ist.h                |    0 
 include/{asm-x86_64 => asm-x86}/k8.h               |    0 
 include/{asm-i386/kdebug.h => asm-x86/kdebug_32.h} |    0 
 .../{asm-x86_64/kdebug.h => asm-x86/kdebug_64.h}   |    0 
 include/{asm-i386/kexec.h => asm-x86/kexec_32.h}   |    0 
 include/{asm-x86_64/kexec.h => asm-x86/kexec_64.h} |    0 
 .../kmap_types.h => asm-x86/kmap_types_32.h}       |    0 
 .../kmap_types.h => asm-x86/kmap_types_64.h}       |    0 
 .../{asm-i386/kprobes.h => asm-x86/kprobes_32.h}   |    0 
 .../{asm-x86_64/kprobes.h => asm-x86/kprobes_64.h} |    0 
 include/{asm-i386/ldt.h => asm-x86/ldt_32.h}       |    0 
 include/{asm-x86_64/ldt.h => asm-x86/ldt_64.h}     |    0 
 .../{asm-i386/linkage.h => asm-x86/linkage_32.h}   |    0 
 .../{asm-x86_64/linkage.h => asm-x86/linkage_64.h} |    0 
 include/{asm-i386/local.h => asm-x86/local_32.h}   |    0 
 include/{asm-x86_64/local.h => asm-x86/local_64.h} |    0 
 .../{asm-i386 => asm-x86}/mach-bigsmp/mach_apic.h  |    0 
 .../mach-bigsmp/mach_apicdef.h                     |    0 
 .../{asm-i386 => asm-x86}/mach-bigsmp/mach_ipi.h   |    0 
 .../mach-bigsmp/mach_mpspec.h                      |    0 
 include/{asm-i386 => asm-x86}/mach-default/apm.h   |    0 
 .../{asm-i386 => asm-x86}/mach-default/bios_ebda.h |    0 
 .../{asm-i386 => asm-x86}/mach-default/do_timer.h  |    0 
 .../mach-default/entry_arch.h                      |    0 
 .../{asm-i386 => asm-x86}/mach-default/io_ports.h  |    0 
 .../mach-default/irq_vectors.h                     |    0 
 .../mach-default/irq_vectors_limits.h              |    0 
 .../{asm-i386 => asm-x86}/mach-default/mach_apic.h |    0 
 .../mach-default/mach_apicdef.h                    |    0 
 .../{asm-i386 => asm-x86}/mach-default/mach_ipi.h  |    0 
 .../mach-default/mach_mpparse.h                    |    0 
 .../mach-default/mach_mpspec.h                     |    0 
 .../mach-default/mach_reboot.h                     |    0 
 .../{asm-i386 => asm-x86}/mach-default/mach_time.h |    0 
 .../mach-default/mach_timer.h                      |    0 
 .../mach-default/mach_traps.h                      |    0 
 .../mach-default/mach_wakecpu.h                    |    0 
 .../mach-default/pci-functions.h                   |    0 
 .../mach-default/setup_arch.h                      |    0 
 .../mach-default/smpboot_hooks.h                   |    0 
 .../{asm-i386 => asm-x86}/mach-es7000/mach_apic.h  |    0 
 .../mach-es7000}/mach_apicdef.h                    |    0 
 .../{asm-i386 => asm-x86}/mach-es7000/mach_ipi.h   |    0 
 .../mach-es7000/mach_mpparse.h                     |    0 
 .../mach-es7000/mach_mpspec.h                      |    0 
 .../mach-es7000/mach_wakecpu.h                     |    0 
 .../mach-generic/irq_vectors_limits.h              |    0 
 .../{asm-i386 => asm-x86}/mach-generic/mach_apic.h |    0 
 .../mach-generic/mach_apicdef.h                    |    0 
 .../{asm-i386 => asm-x86}/mach-generic/mach_ipi.h  |    0 
 .../mach-generic/mach_mpparse.h                    |    0 
 .../mach-generic/mach_mpspec.h                     |    0 
 .../{asm-i386 => asm-x86}/mach-numaq/mach_apic.h   |    0 
 .../mach-numaq/mach_apicdef.h                      |    0 
 .../{asm-i386 => asm-x86}/mach-numaq/mach_ipi.h    |    0 
 .../mach-numaq/mach_mpparse.h                      |    0 
 .../{asm-i386 => asm-x86}/mach-numaq/mach_mpspec.h |    0 
 .../mach-numaq/mach_wakecpu.h                      |    0 
 .../mach-summit}/irq_vectors_limits.h              |    0 
 .../{asm-i386 => asm-x86}/mach-summit/mach_apic.h  |    0 
 .../mach-summit}/mach_apicdef.h                    |    0 
 .../mach-bigsmp => asm-x86/mach-summit}/mach_ipi.h |    0 
 .../mach-summit/mach_mpparse.h                     |    0 
 .../mach-summit/mach_mpspec.h                      |    0 
 include/{asm-i386 => asm-x86}/mach-visws/cobalt.h  |    0 
 .../{asm-i386 => asm-x86}/mach-visws/entry_arch.h  |    0 
 .../{asm-i386 => asm-x86}/mach-visws/irq_vectors.h |    0 
 include/{asm-i386 => asm-x86}/mach-visws/lithium.h |    0 
 .../{asm-i386 => asm-x86}/mach-visws/mach_apic.h   |    0 
 .../mach-visws/mach_apicdef.h                      |    0 
 include/{asm-i386 => asm-x86}/mach-visws/piix4.h   |    0 
 .../{asm-i386 => asm-x86}/mach-visws/setup_arch.h  |    0 
 .../mach-visws/smpboot_hooks.h                     |    0 
 .../{asm-i386 => asm-x86}/mach-voyager/do_timer.h  |    0 
 .../mach-voyager/entry_arch.h                      |    0 
 .../mach-voyager/irq_vectors.h                     |    0 
 .../mach-voyager/setup_arch.h                      |    0 
 include/{asm-x86_64 => asm-x86}/mach_apic.h        |    0 
 include/{asm-i386 => asm-x86}/math_emu.h           |    0 
 .../mc146818rtc.h => asm-x86/mc146818rtc_32.h}     |    0 
 .../mc146818rtc.h => asm-x86/mc146818rtc_64.h}     |    0 
 include/{asm-i386 => asm-x86}/mca.h                |    0 
 include/{asm-i386 => asm-x86}/mca_dma.h            |    0 
 include/{asm-i386/mce.h => asm-x86/mce_32.h}       |    0 
 include/{asm-x86_64/mce.h => asm-x86/mce_64.h}     |    0 
 include/{asm-i386/mman.h => asm-x86/mman_32.h}     |    0 
 include/{asm-x86_64/mman.h => asm-x86/mman_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/mmsegment.h        |    0 
 include/{asm-i386/mmu.h => asm-x86/mmu_32.h}       |    0 
 include/{asm-x86_64/mmu.h => asm-x86/mmu_64.h}     |    0 
 .../mmu_context.h => asm-x86/mmu_context_32.h}     |    0 
 .../mmu_context.h => asm-x86/mmu_context_64.h}     |    0 
 include/{asm-i386 => asm-x86}/mmx.h                |    0 
 include/{asm-i386/mmzone.h => asm-x86/mmzone_32.h} |    0 
 .../{asm-x86_64/mmzone.h => asm-x86/mmzone_64.h}   |    0 
 include/{asm-i386/module.h => asm-x86/module_32.h} |    0 
 .../{asm-x86_64/module.h => asm-x86/module_64.h}   |    0 
 include/{asm-i386/mpspec.h => asm-x86/mpspec_32.h} |    0 
 .../{asm-x86_64/mpspec.h => asm-x86/mpspec_64.h}   |    0 
 include/{asm-i386 => asm-x86}/mpspec_def.h         |    0 
 include/{asm-i386/msgbuf.h => asm-x86/msgbuf_32.h} |    0 
 .../{asm-x86_64/msgbuf.h => asm-x86/msgbuf_64.h}   |    0 
 include/{asm-i386 => asm-x86}/msidef.h             |    0 
 include/{asm-i386 => asm-x86}/msr-index.h          |    0 
 include/{asm-i386/msr.h => asm-x86/msr_32.h}       |    0 
 include/{asm-x86_64/msr.h => asm-x86/msr_64.h}     |    0 
 include/{asm-i386/mtrr.h => asm-x86/mtrr_32.h}     |    0 
 include/{asm-x86_64/mtrr.h => asm-x86/mtrr_64.h}   |    0 
 include/{asm-i386/mutex.h => asm-x86/mutex_32.h}   |    0 
 include/{asm-x86_64/mutex.h => asm-x86/mutex_64.h} |    0 
 include/{asm-i386/namei.h => asm-x86/namei_32.h}   |    0 
 include/{asm-x86_64/namei.h => asm-x86/namei_64.h} |    0 
 include/{asm-i386/nmi.h => asm-x86/nmi_32.h}       |    0 
 include/{asm-x86_64/nmi.h => asm-x86/nmi_64.h}     |    0 
 include/{asm-x86_64 => asm-x86}/node.h             |    0 
 include/{asm-i386/numa.h => asm-x86/numa_32.h}     |    0 
 include/{asm-x86_64/numa.h => asm-x86/numa_64.h}   |    0 
 include/{asm-i386 => asm-x86}/numaq.h              |    0 
 include/{asm-i386/page.h => asm-x86/page_32.h}     |    0 
 include/{asm-x86_64/page.h => asm-x86/page_64.h}   |    0 
 include/{asm-i386/param.h => asm-x86/param_32.h}   |    0 
 include/{asm-x86_64/param.h => asm-x86/param_64.h} |    0 
 include/{asm-i386 => asm-x86}/paravirt.h           |    0 
 .../{asm-i386/parport.h => asm-x86/parport_32.h}   |    0 
 .../{asm-x86_64/parport.h => asm-x86/parport_64.h} |    0 
 include/{asm-x86_64 => asm-x86}/pci-direct.h       |    0 
 include/{asm-i386/pci.h => asm-x86/pci_32.h}       |    0 
 include/{asm-x86_64/pci.h => asm-x86/pci_64.h}     |    0 
 include/{asm-x86_64 => asm-x86}/pda.h              |    0 
 include/{asm-i386/percpu.h => asm-x86/percpu_32.h} |    0 
 .../{asm-x86_64/percpu.h => asm-x86/percpu_64.h}   |    0 
 .../{asm-i386/pgalloc.h => asm-x86/pgalloc_32.h}   |    0 
 .../{asm-x86_64/pgalloc.h => asm-x86/pgalloc_64.h} |    0 
 .../{asm-i386 => asm-x86}/pgtable-2level-defs.h    |    0 
 include/{asm-i386 => asm-x86}/pgtable-2level.h     |    0 
 .../{asm-i386 => asm-x86}/pgtable-3level-defs.h    |    0 
 include/{asm-i386 => asm-x86}/pgtable-3level.h     |    0 
 .../{asm-i386/pgtable.h => asm-x86/pgtable_32.h}   |    0 
 .../{asm-x86_64/pgtable.h => asm-x86/pgtable_64.h} |    0 
 include/{asm-i386 => asm-x86}/poll.h               |    0 
 .../posix_types.h => asm-x86/posix_types_32.h}     |    0 
 .../posix_types.h => asm-x86/posix_types_64.h}     |    0 
 include/{asm-x86_64 => asm-x86}/prctl.h            |    0 
 include/{asm-i386 => asm-x86}/processor-flags.h    |    0 
 .../processor.h => asm-x86/processor_32.h}         |    0 
 .../processor.h => asm-x86/processor_64.h}         |    0 
 include/{asm-x86_64 => asm-x86}/proto.h            |    0 
 .../ptrace-abi.h => asm-x86/ptrace-abi_32.h}       |    0 
 .../ptrace-abi.h => asm-x86/ptrace-abi_64.h}       |    0 
 include/{asm-i386/ptrace.h => asm-x86/ptrace_32.h} |    0 
 .../{asm-x86_64/ptrace.h => asm-x86/ptrace_64.h}   |    0 
 include/{asm-i386 => asm-x86}/reboot.h             |    0 
 include/{asm-i386 => asm-x86}/reboot_fixups.h      |    0 
 .../required-features_32.h}                        |    0 
 .../required-features_64.h}                        |    0 
 .../{asm-i386/resource.h => asm-x86/resource_32.h} |    0 
 .../resource.h => asm-x86/resource_64.h}           |    0 
 include/{asm-x86_64 => asm-x86}/rio.h              |    0 
 include/{asm-i386/rtc.h => asm-x86/rtc_32.h}       |    0 
 include/{asm-x86_64/rtc.h => asm-x86/rtc_64.h}     |    0 
 include/{asm-i386/rwlock.h => asm-x86/rwlock_32.h} |    0 
 .../{asm-x86_64/rwlock.h => asm-x86/rwlock_64.h}   |    0 
 include/{asm-i386 => asm-x86}/rwsem.h              |    0 
 .../scatterlist.h => asm-x86/scatterlist_32.h}     |    0 
 .../scatterlist.h => asm-x86/scatterlist_64.h}     |    0 
 .../{asm-i386/seccomp.h => asm-x86/seccomp_32.h}   |    0 
 .../{asm-x86_64/seccomp.h => asm-x86/seccomp_64.h} |    0 
 .../{asm-i386/sections.h => asm-x86/sections_32.h} |    0 
 .../sections.h => asm-x86/sections_64.h}           |    0 
 .../{asm-i386/segment.h => asm-x86/segment_32.h}   |    0 
 .../{asm-x86_64/segment.h => asm-x86/segment_64.h} |    0 
 .../semaphore.h => asm-x86/semaphore_32.h}         |    0 
 .../semaphore.h => asm-x86/semaphore_64.h}         |    0 
 include/{asm-i386/sembuf.h => asm-x86/sembuf_32.h} |    0 
 .../{asm-x86_64/sembuf.h => asm-x86/sembuf_64.h}   |    0 
 include/{asm-i386/serial.h => asm-x86/serial_32.h} |    0 
 .../{asm-x86_64/serial.h => asm-x86/serial_64.h}   |    0 
 include/{asm-i386/setup.h => asm-x86/setup_32.h}   |    0 
 include/{asm-x86_64/setup.h => asm-x86/setup_64.h} |    0 
 include/{asm-i386/shmbuf.h => asm-x86/shmbuf_32.h} |    0 
 .../{asm-x86_64/shmbuf.h => asm-x86/shmbuf_64.h}   |    0 
 .../{asm-i386/shmparam.h => asm-x86/shmparam_32.h} |    0 
 .../shmparam.h => asm-x86/shmparam_64.h}           |    0 
 include/{asm-x86_64 => asm-x86}/sigcontext32.h     |    0 
 .../sigcontext.h => asm-x86/sigcontext_32.h}       |    0 
 .../sigcontext.h => asm-x86/sigcontext_64.h}       |    0 
 .../{asm-i386/siginfo.h => asm-x86/siginfo_32.h}   |    0 
 .../{asm-x86_64/siginfo.h => asm-x86/siginfo_64.h} |    0 
 include/{asm-i386/signal.h => asm-x86/signal_32.h} |    0 
 .../{asm-x86_64/signal.h => asm-x86/signal_64.h}   |    0 
 include/{asm-i386/smp.h => asm-x86/smp_32.h}       |    0 
 include/{asm-x86_64/smp.h => asm-x86/smp_64.h}     |    0 
 include/{asm-i386/socket.h => asm-x86/socket_32.h} |    0 
 .../{asm-x86_64/socket.h => asm-x86/socket_64.h}   |    0 
 .../{asm-i386/sockios.h => asm-x86/sockios_32.h}   |    0 
 .../{asm-x86_64/sockios.h => asm-x86/sockios_64.h} |    0 
 .../sparsemem.h => asm-x86/sparsemem_32.h}         |    0 
 .../sparsemem.h => asm-x86/sparsemem_64.h}         |    0 
 .../{asm-i386/spinlock.h => asm-x86/spinlock_32.h} |    0 
 .../spinlock.h => asm-x86/spinlock_64.h}           |    0 
 include/{asm-i386 => asm-x86}/spinlock_types.h     |    0 
 include/{asm-i386 => asm-x86}/srat.h               |    0 
 include/{asm-x86_64 => asm-x86}/stacktrace.h       |    0 
 include/{asm-i386/stat.h => asm-x86/stat_32.h}     |    0 
 include/{asm-x86_64/stat.h => asm-x86/stat_64.h}   |    0 
 include/{asm-i386/statfs.h => asm-x86/statfs_32.h} |    0 
 .../{asm-x86_64/statfs.h => asm-x86/statfs_64.h}   |    0 
 include/{asm-i386/string.h => asm-x86/string_32.h} |    0 
 .../{asm-x86_64/string.h => asm-x86/string_64.h}   |    0 
 .../{asm-i386/suspend.h => asm-x86/suspend_32.h}   |    0 
 .../{asm-x86_64/suspend.h => asm-x86/suspend_64.h} |    0 
 include/{asm-x86_64 => asm-x86}/swiotlb.h          |    0 
 include/{asm-i386 => asm-x86}/sync_bitops.h        |    0 
 include/{asm-i386/system.h => asm-x86/system_32.h} |    0 
 .../{asm-x86_64/system.h => asm-x86/system_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/tce.h              |    0 
 .../{asm-i386/termbits.h => asm-x86/termbits_32.h} |    0 
 .../termbits.h => asm-x86/termbits_64.h}           |    0 
 .../{asm-i386/termios.h => asm-x86/termios_32.h}   |    0 
 .../{asm-x86_64/termios.h => asm-x86/termios_64.h} |    0 
 include/{asm-i386 => asm-x86}/therm_throt.h        |    0 
 .../thread_info.h => asm-x86/thread_info_32.h}     |    0 
 .../thread_info.h => asm-x86/thread_info_64.h}     |    0 
 include/{asm-i386 => asm-x86}/time.h               |    0 
 include/{asm-i386 => asm-x86}/timer.h              |    0 
 include/{asm-i386/timex.h => asm-x86/timex_32.h}   |    0 
 include/{asm-x86_64/timex.h => asm-x86/timex_64.h} |    0 
 include/{asm-i386/tlb.h => asm-x86/tlb_32.h}       |    0 
 include/{asm-x86_64/tlb.h => asm-x86/tlb_64.h}     |    0 
 .../{asm-i386/tlbflush.h => asm-x86/tlbflush_32.h} |    0 
 .../tlbflush.h => asm-x86/tlbflush_64.h}           |    0 
 .../{asm-i386/topology.h => asm-x86/topology_32.h} |    0 
 .../topology.h => asm-x86/topology_64.h}           |    0 
 include/{asm-i386 => asm-x86}/tsc.h                |    0 
 include/{asm-i386/types.h => asm-x86/types_32.h}   |    0 
 include/{asm-x86_64/types.h => asm-x86/types_64.h} |    0 
 .../{asm-i386/uaccess.h => asm-x86/uaccess_32.h}   |    0 
 .../{asm-x86_64/uaccess.h => asm-x86/uaccess_64.h} |    0 
 .../{asm-i386/ucontext.h => asm-x86/ucontext_32.h} |    0 
 .../ucontext.h => asm-x86/ucontext_64.h}           |    0 
 .../unaligned.h => asm-x86/unaligned_32.h}         |    0 
 .../unaligned.h => asm-x86/unaligned_64.h}         |    0 
 include/{asm-i386/unistd.h => asm-x86/unistd_32.h} |    0 
 .../{asm-x86_64/unistd.h => asm-x86/unistd_64.h}   |    0 
 include/{asm-i386/unwind.h => asm-x86/unwind_32.h} |    0 
 .../{asm-x86_64/unwind.h => asm-x86/unwind_64.h}   |    0 
 include/{asm-x86_64 => asm-x86}/user32.h           |    0 
 include/{asm-i386/user.h => asm-x86/user_32.h}     |    0 
 include/{asm-x86_64/user.h => asm-x86/user_64.h}   |    0 
 include/{asm-i386 => asm-x86}/vga.h                |    0 
 include/{asm-i386 => asm-x86}/vic.h                |    0 
 include/{asm-i386 => asm-x86}/vm86.h               |    0 
 include/{asm-i386 => asm-x86}/vmi.h                |    0 
 include/{asm-i386 => asm-x86}/vmi_time.h           |    0 
 include/{asm-i386 => asm-x86}/voyager.h            |    0 
 include/{asm-x86_64 => asm-x86}/vsyscall.h         |    0 
 include/{asm-x86_64 => asm-x86}/vsyscall32.h       |    0 
 include/{asm-i386 => asm-x86}/xen/hypercall.h      |    0 
 include/{asm-i386 => asm-x86}/xen/hypervisor.h     |    0 
 include/{asm-i386 => asm-x86}/xen/interface.h      |    0 
 include/{asm-i386/xor.h => asm-x86/xor_32.h}       |    0 
 include/{asm-x86_64/xor.h => asm-x86/xor_64.h}     |    0 
 include/asm-x86_64/boot.h                          |    1 -
 include/asm-x86_64/bootparam.h                     |    1 -
 include/asm-x86_64/cpu.h                           |    1 -
 include/asm-x86_64/cpufeature.h                    |   30 -
 include/asm-x86_64/emergency-restart.h             |    6 -
 include/asm-x86_64/fcntl.h                         |    1 -
 include/asm-x86_64/hypertransport.h                |   42 -
 include/asm-x86_64/ide.h                           |    1 -
 include/asm-x86_64/ioctl.h                         |    1 -
 include/asm-x86_64/msidef.h                        |   47 -
 include/asm-x86_64/msr-index.h                     |    1 -
 include/asm-x86_64/poll.h                          |    1 -
 include/asm-x86_64/processor-flags.h               |    1 -
 include/asm-x86_64/spinlock_types.h                |   20 -
 include/asm-x86_64/therm_throt.h                   |    1 -
 include/asm-x86_64/tsc.h                           |    1 -
 include/asm-x86_64/vga.h                           |   20 -
 scripts/checksyscalls.sh                           |    2 +-
 918 files changed, 4745 insertions(+), 2836 deletions(-)
