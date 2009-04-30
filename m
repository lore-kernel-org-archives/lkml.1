Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZD3HjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZD3HjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZD3Hiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:38:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40871 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZD3Hiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:38:54 -0400
Message-ID: <49F95564.5020402@jp.fujitsu.com>
Date: Thu, 30 Apr 2009 16:38:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Huang Ying <ying.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: 32bit mce unification (Re: Re-implement MCE log ring buffer as per-CPU
 ring buffer II)
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <49EEFD88.1030604@linux.intel.com> <49EF3DE2.6000201@zytor.com> <49F8A734.8050106@linux.intel.com>
In-Reply-To: <49F8A734.8050106@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen wrote:
> H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>> And then restart here? Add 32bit workarounds, add hook
>>> to initialize p5/winchip, make 64bit code 32bit clean.
>>> That can come straight from my patchkit. I can do that
>>> if there is interest.
>>>
>>
>> Could you come up with a tree we can look at?
> 
> Sorry for taking longer, had to fight some infrastructure issues.
> 
> I merged the two trees in
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git
> mce-32bit-merge
> 
> This is my old 32bit mce unification tree forward ported to mce2 and
> some fixes
> for the code in mce2. This is currently with Kconfig for old/new,
> deprecation
> of old for .32 (could be done directly too, but doing it with this
> additional
> step seems safer to me because it will allow easier debugging)
> 
> This currently includes the two error injection patches as last (used
> for testing), those can be dropped/added later of course too.
> 
> If this is ok I can respin the rest of the mce patches on top of that
> tree.

Thank you for providing updates.
They are looks good, but I have some comments:


We can get an instant numbered list from your tree by following:

$ git format-patch origin/master..origin/mce-32bit-merge
0001-x86-mce-Add-mce_threshold-option-for-intel-cmci.patch
0002-x86-mce-Cleanup-param-parser.patch
0003-x86-mce-Add-mce-nopoll-option-to-disable-timer-pol.patch
0004-x86-mce-clean-up-the-mce_64.c-code.patch
0005-x86-mce-clean-up-the-sysfs-variables-namespace.patch
0006-x86-mce-clean-up-mce_amd_64.c.patch
0007-x86-mce-clean-up-p4.c.patch
0008-x86-mce-clean-up-therm_throt.c.patch
0009-x86-mce-clean-up-p6.c.patch
0010-x86-mce-clean-up-k7.c.patch
0011-x86-mce-clean-up-non-fatal.c.patch
0012-x86-mce-clean-up-mce_32.c.patch
0013-x86-mce-clean-up-p5.c.patch
0014-x86-mce-clean-up-winchip.c.patch
0015-x86-mce-clean-up-mce.h.patch
0016-mce-unify-Intel-thermal-init-prepare.patch
0017-x86-mce-unify-the-Intel-thermal-interrupt-code.patch
0018-x86-mce-clean-up-mce_intel.c.patch
0019-x86-mce-clean-up-mce_64.c.patch
0020-x86-mce-prepare-mce.h-and-mce_64.c-for-unification.patch
0021-x86-mce-prepare-unification.patch
0022-x86-mce-unify-prepare-for-32-bit.patch
0023-x86-mce-unify.patch
0024-x86-mce-print-number-of-MCE-banks.patch
0025-x86-MCE-Make-mce_amd_64.c-compile-again.patch
0026-Revert-x86-mce-Add-mce-nopoll-option-to-disable-t.patch
0027-x86-MCE-Move-ifdef-X86_64-to-the-beginning-of-the.patch
0028-x86-MCE-Initial-steps-to-make-64bit-mce-code-32bit.patch
0029-x86-MCE-Implement-the-PPro-bank-0-quirk-in-the-64b.patch
0030-x86-MCE-Port-K7-bank-0-quirk-to-64bit-mce-code.patch
0031-x86-MCE-Use-a-call-vector-to-call-the-64bit-mce-ha.patch
0032-x86-MCE-Rename-64bit-mce_dont_init-to-mce_disabled.patch
0033-x86-MCE-Move-mce_disabled-option-into-common-64bit.patch
0034-x86-MCE-Remove-machine-check-handler-idle-notify-o.patch
0035-x86-MCE-Remove-oops_begin-use-in-64bit-machine-c.patch
0036-x86-MCE-Remove-unused-stop-restart_mce-on-32bit.patch
0037-x86-MCE-Use-64bit-machine-check-code-on-32bit.patch
0038-x86-MCE-Deprecate-old-32bit-machine-check-code.patch
0039-x86-MCE-Enable-MCE_INTEL-for-32bit-new-MCE.patch
0040-x86-MCE-Enable-MCE_AMD-for-32bit-NEW_MCE.patch
0041-x86-MCE-Document-new-32bit-mcelog-requirement-in-D.patch
0042-x86-MCE-Add-MSR-read-wrappers-for-easier-error-inj.patch
0043-x86-MCE-Add-basic-error-injection-infrastructure.patch


Let's start comment/review on this list:

0001-x86-mce-Add-mce_threshold-option-for-intel-cmci.patch
0002-x86-mce-Cleanup-param-parser.patch
0003-x86-mce-Add-mce-nopoll-option-to-disable-timer-pol.patch

  These 3 above are merged in tip/x86/mce2, but not pushed into
  mainline yet.
  You(Andi) and I agreed that 0001 and 0003 should be reverted and
  re-implemented before pushing them into .31, and I have patches
  to do it.
  One of revert patches is placed in 0026.  It's fine but I'd like to
  replace it with that I own, which have more detailed description.

0004-x86-mce-clean-up-the-mce_64.c-code.patch
0005-x86-mce-clean-up-the-sysfs-variables-namespace.patch
0006-x86-mce-clean-up-mce_amd_64.c.patch
0007-x86-mce-clean-up-p4.c.patch
0008-x86-mce-clean-up-therm_throt.c.patch
0009-x86-mce-clean-up-p6.c.patch
0010-x86-mce-clean-up-k7.c.patch
0011-x86-mce-clean-up-non-fatal.c.patch
0012-x86-mce-clean-up-mce_32.c.patch
0013-x86-mce-clean-up-p5.c.patch
0014-x86-mce-clean-up-winchip.c.patch
0015-x86-mce-clean-up-mce.h.patch
0016-mce-unify-Intel-thermal-init-prepare.patch
0017-x86-mce-unify-the-Intel-thermal-interrupt-code.patch
0018-x86-mce-clean-up-mce_intel.c.patch
0019-x86-mce-clean-up-mce_64.c.patch
0020-x86-mce-prepare-mce.h-and-mce_64.c-for-unification.patch
0021-x86-mce-prepare-unification.patch
0022-x86-mce-unify-prepare-for-32-bit.patch
0023-x86-mce-unify.patch
0024-x86-mce-print-number-of-MCE-banks.patch

  These 21 patches above are now top of tip/x86/mce2.
  Some are broken and some following patches from Andi are
  addressed to fix it.

0025-x86-MCE-Make-mce_amd_64.c-compile-again.patch

  The description of this patch is "It's device_mce, not mce_dev."
  This is for a bug of 0005, which was intended to rename device_mce
  to mce_dev, but the rename was not finished.
  I suppose "mce_" prefix is better for name space, so I think
  rework on 0005 or incremental fix to finish renaming will be more
  better solution.

0026-Revert-x86-mce-Add-mce-nopoll-option-to-disable-t.patch

  This reverts 0003.  I'd like to replace this with that I own.

0027-x86-MCE-Move-ifdef-X86_64-to-the-beginning-of-the.patch

  This is for a bug of 0022, that places ifdefs wrongly.


0028-x86-MCE-Initial-steps-to-make-64bit-mce-code-32bit.patch
0029-x86-MCE-Implement-the-PPro-bank-0-quirk-in-the-64b.patch
0030-x86-MCE-Port-K7-bank-0-quirk-to-64bit-mce-code.patch
0031-x86-MCE-Use-a-call-vector-to-call-the-64bit-mce-ha.patch
0032-x86-MCE-Rename-64bit-mce_dont_init-to-mce_disabled.patch
0033-x86-MCE-Move-mce_disabled-option-into-common-64bit.patch
0034-x86-MCE-Remove-machine-check-handler-idle-notify-o.patch
0035-x86-MCE-Remove-oops_begin-use-in-64bit-machine-c.patch
0036-x86-MCE-Remove-unused-stop-restart_mce-on-32bit.patch
0037-x86-MCE-Use-64bit-machine-check-code-on-32bit.patch
0038-x86-MCE-Deprecate-old-32bit-machine-check-code.patch
0039-x86-MCE-Enable-MCE_INTEL-for-32bit-new-MCE.patch
0040-x86-MCE-Enable-MCE_AMD-for-32bit-NEW_MCE.patch
0041-x86-MCE-Document-new-32bit-mcelog-requirement-in-D.patch
0042-x86-MCE-Add-MSR-read-wrappers-for-easier-error-inj.patch
0043-x86-MCE-Add-basic-error-injection-infrastructure.patch

  These 16 patches above is 32bit mce unification by Andi.
  0028~0036 are preparation and cleanup,
  0037~0041 are main part of unification, and
  0042~0043 are for error injection.
  My comments are as followings:


  0029,0037,0038,0041:
  have space before tab in indent / trailing whitespace.


  0038:
  The change in the first line is not required, and we need to schedule
  feature removal not so soon.
  Since the patch description is "Schedule for removal in 2.6.32",
  the "When:" should be .32 instead of .31

  >@@ -1,4 +1,4 @@
  >-The following is a list of files and features that are going to be
  >+he following is a list of files and features that are going to be
  > removed in the kernel source tree.  Every entry should contain what
  > exactly is going away, why it is happening, and who is going to be doing
  > the work.  When the feature is removed from the kernel, it should also
  >@@ -428,3 +428,13 @@
  >        After a reasonable transition period, we will remove the legacy
  >        fakephp interface.
  > Who:   Alex Chiang <achiang@hp.com>
  >+
  >+----------------------------
  >+
  >+What:  CONFIG_X86_OLD_MCE
  >+When:  2.6.31
  >+Why:   Remove the old legacy 32bit machine check code. This has been
  >+       superseded by the newer machine check code from the 64bit port,
  >+       but the old version has been kept around for easier testing. Note this
  >+        doesn't impact the old P5 and WinChip machine check handlers.
  >+Who:   Andi Kleen <andi@firstfloor.org>


  0039:
  The comment is wrongly changed, and it would be better to place vectors
  in sorted order.

  >@@ -88,12 +88,13 @@
  > #define THERMAL_APIC_VECTOR            0xfa
  >
  > #ifdef CONFIG_X86_32
  >-/* 0xf8 - 0xf9 : free */
  >+/* 0xf9 : free */
  > #else
  >-# define THRESHOLD_APIC_VECTOR         0xf9
  > # define UV_BAU_MESSAGE                        0xf8
  > #endif
  >
  >+#define THRESHOLD_APIC_VECTOR          0xf9
  >+
  > /* f0-f7 used for spreading out TLB flushes: */
  > #define INVALIDATE_TLB_VECTOR_END      0xf7
  > #define INVALIDATE_TLB_VECTOR_START    0xf0


  0041:
  Is this version correct?
  The latest (git://git.kernel.org/pub/scm/utils/cpu/mce/mcelog.git) is:
  #define MCELOG_VERSION "0.8pre2"

  >@@ -48,6 +48,7 @@ o  procps                 3.2.0                   # ps --version
  > o  oprofile               0.9                     # oprofiled --version
  > o  udev                   081                     # udevinfo -V
  > o  grub                   0.93                    # grub --version
  >+o  mcelog                0.6
  >
  > Kernel compilation
  > ==================


  0043:
  From checkpatch:
  WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
  #174: FILE: arch/x86/kernel/cpu/mcheck/mce-inject.c:96:
  +       if (m.cpu >= NR_CPUS || !cpu_online(m.cpu))

  Plus, with CONFIG_X86_MCE_INJECT=m, I got:
    ERROR: "add_timer_on" [arch/x86/kernel/cpu/mcheck/mce-inject.ko] undefined!
  IIRC there was a patch named "Export add_timer_on for modules" for
  error injection. (Or how about using bool instead of tristate if there
  are no strong reason to make it kernel module?)

  >@@ -823,6 +823,14 @@ config X86_MCE_THRESHOLD
  >        bool
  >        default y
  >
  >+config X86_MCE_INJECT
  >+       depends on X86_NEW_MCE
  >+       tristate "Machine check injector support"
  >+       help
  >+         Provide support for injecting machine checks for testing purposes.
  >+         If you don't know what a machine check is and you don't do kernel
  >+         QA it is safe to say n.
  >+
  > config X86_MCE_NONFATAL
  >        tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
  >        depends on X86_OLD_MCE


Thanks,
H.Seto

