Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYFXMEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYFXMEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYFXMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:04:14 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58855 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYFXMEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:04:13 -0400
Date: Tue, 24 Jun 2008 05:04:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080624120404.GA7978@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com> <20080616034659.GA7600@martell.zuzino.mipt.ru> <20080617034228.GA18217@linux.vnet.ibm.com> <20080624005053.GA4827@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624005053.GA4827@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 04:50:53AM +0400, Alexey Dobriyan wrote:
> [rcutorture failures with PREEMPT_RCU]
> 
> Status update:
> * bug is reproduced on another box with the very same symptoms:
>   SMP=y, maxcpus=1 kernel occasionally fails, SMP=n is fine.
>   Also Core 2 Duo, x86_64 [1]
> 
>   Race is wide -- 60 seconds of rcutorture is enough.
> 
> So far tried without effect:
> 	not doing SMP-alternatives
> 	NO_HZ=y/n
> 	HIGH_RES_TIMERS=y/n
> 	compiling with gcc 3.4.6/4.1.2
> 	different HZ
> 	s/asm/asm volatile/g at percpu asm code and PDA asm code
> 	turning on and off varying CONFIG_DEBUG_ options
> 	CONFIG_DEBUG_PREEMPT
> 	softlockup on/off
> 	making x86_64 cpu_idle() same as 32-bit one wrt rcu_pending et al
> 	sched_setaffinity() in __synchronize_sched doesn't fail
> 
> Probably forgot something, but not a single thing that can remove the
> bug in SMP=y case.
> 
> Using SMP percpu stuff for UP case miserably failed because of some hard
> hang due to incomplete patch, but I still leave this for doomsday.
> 
> I'm going to try 32-bit setup and reading rcupreempt disassembly with
> microscope.

Good point!!!  Would either you or Nick be willing to send me either
the vmlinux or a disassembly of the relevant portions?

							Thanx, Paul

> [1]
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
> stepping	: 11
> cpu MHz		: 800.000
> cache size	: 4096 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
> bogomips	: 4791.74
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
> stepping	: 11
> cpu MHz		: 800.000
> cache size	: 4096 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
> bogomips	: 4787.76
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> -----------------------------------------------------------------------------
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
> stepping	: 2
> cpu MHz		: 2135.041
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips	: 4272.61
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
> stepping	: 2
> cpu MHz		: 2135.041
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
> bogomips	: 4270.14
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
