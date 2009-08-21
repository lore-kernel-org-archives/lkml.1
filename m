Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbZHUAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbZHUAB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZHUAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:01:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:4496 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZHUABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AmHZfPP2cJJ3/GGshmVN4LwQ6B9t9F6pQl+yedrfMTB4LVEBVXUWh4dyElzy8qypJk
         ILqUr7Ai/IQMdS16MTtLNQsdq411BTGTwStIiflgjB2D+l9+Aa+uGvWTLtJuMyyNdnuM
         u2atzlqTG78HXd5TJFLUaFvDC3RciQ8Cfkb4s=
Date: Fri, 21 Aug 2009 02:01:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [TOOL] kprobestest : Kprobe stress test tool
Message-ID: <20090821000108.GC6078@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <4A847E30.9050903@redhat.com> <20090820184331.GA6078@nowhere> <4A8DA7CE.2040702@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <4A8DA7CE.2040702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2009 at 03:45:18PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> On Thu, Aug 13, 2009 at 04:57:20PM -0400, Masami Hiramatsu wrote:
>>> This script tests kprobes to probe on all symbols in the kernel and finds
>>> symbols which must be blacklisted.
>>>
>>>
>>> Usage
>>> -----
>>>    kprobestest [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]
>>>       Run stress test. If SYMLIST file is specified, use it as
>>>       an initial symbol list (This is useful for verifying white list
>>>       after diagnosing all symbols).
>>>
>>>    kprobestest cleanup
>>>       Cleanup all lists
>>>
>>>
>>> How to Work
>>> -----------
>>> This tool list up all symbols in the kernel via /proc/kallsyms, and sorts
>>> it into groups (each of them including 64 symbols in default). And then,
>>> it tests each group by using kprobe-tracer. If a kernel crash occurred,
>>> that group is moved into 'failed' dir. If the group passed the test, this
>>> script moves it into 'passed' dir and saves kprobe_profile into
>>> 'passed/profiles/'.
>>> After testing all groups, all 'failed' groups are merged and sorted into
>>> smaller groups (divided by 4, in default). And those are tested again.
>>> This loop will be repeated until all group has just 1 symbol.
>>>
>>> Finally, the script sorts all 'passed' symbols into 'tested', 'untested',
>>> and 'missed' based on profiles.
>>>
>>>
>>> Note
>>> ----
>>>   - This script just gives us some clues to the blacklisted functions.
>>>     In some cases, a combination of probe points will cause a problem, but
>>>     each of them doesn't cause the problem alone.
>>>
>>> Thank you,
>>>
>>
>>
>> This script makes my x86-64 dual core easily and hardly locking-up
>> on the 1st batch of symbols to test.
>> I have one sym list in the failed and unset directories:
>>
>> int_very_careful
>> int_signal
>> int_restore_rest
>> stub_clone
>> stub_fork
>> stub_vfork
>> stub_sigaltstack
>> stub_iopl
>> ptregscall_common
>> stub_execve
>> stub_rt_sigreturn
>> irq_entries_start
>> common_interrupt
>> ret_from_intr
>> exit_intr
>> retint_with_reschedule
>> retint_check
>> retint_swapgs
>> retint_restore_args
>> restore_args
>> irq_return
>> retint_careful
>> retint_signal
>> retint_kernel
>> irq_move_cleanup_interrupt
>> reboot_interrupt
>> apic_timer_interrupt
>> generic_interrupt
>> invalidate_interrupt0
>> invalidate_interrupt1
>> invalidate_interrupt2
>> invalidate_interrupt3
>> invalidate_interrupt4
>> invalidate_interrupt5
>> invalidate_interrupt6
>> invalidate_interrupt7
>> threshold_interrupt
>> thermal_interrupt
>> mce_self_interrupt
>> call_function_single_interrupt
>> call_function_interrupt
>> reschedule_interrupt
>> error_interrupt
>> spurious_interrupt
>> perf_pending_interrupt
>> divide_error
>> overflow
>> bounds
>> invalid_op
>> device_not_available
>> double_fault
>> coprocessor_segment_overrun
>> invalid_TSS
>> segment_not_present
>> spurious_interrupt_bug
>> coprocessor_error
>> alignment_check
>> simd_coprocessor_error
>> native_load_gs_index
>> gs_change
>> kernel_thread
>> child_rip
>> kernel_execve
>> call_softirq
>>
>>
>> I don't have a crash log because I was running with X.
>> But it also happened with other batch of symbols.
>
> Thank you for reporting, here, I also have a result
> tested on KVM@x86-64.
>
> native_read_tscp
> native_read_msr_safe
> native_read_msr_amd_safe
> native_write_msr_safe
> vmalloc_fault
> spurious_fault
> search_exception_tables
> notify_die
> trace_hardirqs_off_caller
> ident_complete
> lock_acquire
> lock_release
> bad_address
> secondary_startup_64
> stack_start
> bad_address
> restore_args
> irq_return
> restore
> trace_hardirqs_off_thunk
> init_level4_pgt
> level3_ident_pgt
> level3_kernel_pgt
> level2_fixmap_pgt
> _text
> startup_64
> level1_fixmap_pgt
> level2_ident_pgt
> level2_kernel_pgt
> level2_spare_pgt
> native_get_debugreg
> native_set_debugreg
> native_set_iopl_mask
> native_load_sp0
> debug_show_all_locks
> debug_check_no_locks_held
> valid_state
> mark_lock
> mark_held_locks
> lockdep_trace_alloc
> trace_softirqs_on
> trace_hardirqs_on_caller
> __down_write
> __down_read
> trace_hardirqs_on_thunk
> lockdep_sys_exit_thunk
>
> Most of them can be fixed just by adding __kprobes.
> Some of them which are already in the another section, kprobes
> should check the symbols are in the section.



You mean the blacklist?

I also fear that putting bad kprobed functions into the kprobe
section or into the blacklist may hide some kprobe internal bugs.

Doing so is indeed mandatory for functions that trigger tracing
recursion of things like that, but what if kprobe has an internal
bug that only triggers while probe a certain class of function.

Ie: it would be nice to identify the reason of the crash for
each culprit in these lists.

That may even help to find the others in advance.

Also kprobes seems to be a very fragile feature (that's what
this selftest unearthes at least for me).
And it really needs a recursion detection that stops every kprobing
while reaching a given threshold of recursion. Something
that would dump the stack and the falling kprobe structure.

That would avoid such hard lockups and also help to identify
the dangerous symbols to probe.



>> The problem is that I don't have any serial line in this
>> box then I can't catch any crash log.
>> My K7 testbox also died in my arms this afternoon.
>>
>> But I still have two other testboxes (one P2 and one P3),
>> hopefully I could reproduce the problem in these boxes
>> in which I can connect a serial line.
>
> Thank you for helping me to find it!
>
>> I've pushed your patches in the following git tree:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/fgrederic/random-tracing.git \
>> 	tracing/kprobes
>>
>> So you can send patches on top of this one.
>
> Great! I've found another trivial bugs, so I'll fix those on it.

Cool :)

Btw, here is the result of your stress test in a PIII (attaching the log
and the config).

Thanks.

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ttyS0.log"

OK

[   27.142635] Testing event sys_exit_statfs64: OK

[   27.187959] Testing event sys_enter_fstatfs: OK

[   27.226978] Testing event sys_exit_fstatfs: OK

[   27.270002] Testing event sys_enter_fstatfs64: OK

[   27.314587] Testing event sys_exit_fstatfs64: OK

[   27.359533] Testing event sys_enter_truncate: OK

[   27.402682] Testing event sys_exit_truncate: OK

[   27.445919] Testing event sys_enter_ftruncate: OK

[   27.488763] Testing event sys_exit_ftruncate: OK

[   27.530554] Testing event sys_enter_faccessat: OK

[   27.574843] Testing event sys_exit_faccessat: OK

[   27.616588] Testing event sys_enter_access: OK

[   27.657646] Testing event sys_exit_access: OK

[   27.699855] Testing event sys_enter_chdir: OK

[   27.741573] Testing event sys_exit_chdir: OK

[   27.782602] Testing event sys_enter_fchdir: OK

[   27.825604] Testing event sys_exit_fchdir: OK

[   27.867749] Testing event sys_enter_chroot: OK

[   27.909595] Testing event sys_exit_chroot: OK

[   27.951918] Testing event sys_enter_fchmod: OK

[   27.995038] Testing event sys_exit_fchmod: OK

[   28.037746] Testing event sys_enter_fchmodat: OK

[   28.082875] Testing event sys_exit_fchmodat: OK

[   28.129681] Testing event sys_enter_chmod: OK

[   28.170936] Testing event sys_exit_chmod: OK

[   28.212776] Testing event sys_enter_chown: OK

[   28.254988] Testing event sys_exit_chown: OK

[   28.297914] Testing event sys_enter_fchownat: OK

[   28.342243] Testing event sys_exit_fchownat: OK

[   28.386476] Testing event sys_enter_lchown: OK

[   28.430595] Testing event sys_exit_lchown: OK

[   28.475580] Testing event sys_enter_fchown: OK

[   28.521269] Testing event sys_exit_fchown: OK

[   28.564734] Testing event sys_enter_open: OK

[   28.604247] Testing event sys_exit_open: OK

[   28.645710] Testing event sys_enter_openat: OK

[   28.688794] Testing event sys_exit_openat: OK

[   28.733025] Testing event sys_enter_creat: OK

[   28.775947] Testing event sys_exit_creat: OK

[   28.816721] Testing event sys_enter_close: OK

[   28.861706] Testing event sys_exit_close: OK

[   28.902667] Testing event sys_enter_vhangup: OK

[   28.942483] Testing event sys_exit_vhangup: OK

[   28.987654] Testing event sys_enter_swapoff: OK

[   29.031911] Testing event sys_exit_swapoff: OK

[   29.071700] Testing event sys_enter_swapon: OK

[   29.115824] Testing event sys_exit_swapon: OK

[   29.159915] Testing event sys_enter_msync: OK

[   29.202985] Testing event sys_exit_msync: OK

[   29.246718] Testing event sys_enter_mremap: OK

[   29.285550] Testing event sys_exit_mremap: OK

[   29.327651] Testing event sys_enter_mprotect: OK

[   29.368910] Testing event sys_exit_mprotect: OK

[   29.410794] Testing event sys_enter_brk: OK

[   29.452636] Testing event sys_exit_brk: OK

[   29.492673] Testing event sys_enter_munmap: OK

[   29.533907] Testing event sys_exit_munmap: OK

[   29.576043] Testing event sys_enter_mlock: OK

[   29.619275] Testing event sys_exit_mlock: OK

[   29.659011] Testing event sys_enter_munlock: OK

[   29.703559] Testing event sys_exit_munlock: OK

[   29.744707] Testing event sys_enter_mlockall: OK

[   29.787751] Testing event sys_exit_mlockall: OK

[   29.831013] Testing event sys_enter_munlockall: OK

[   29.875831] Testing event sys_exit_munlockall: OK

[   29.919530] Testing event sys_enter_mincore: OK

[   29.962029] Testing event sys_exit_mincore: OK

[   30.004544] Testing event sys_enter_madvise: OK

[   30.049746] Testing event sys_exit_madvise: OK

[   30.093578] Testing event sys_enter_remap_file_pages: OK

[   30.139478] Testing event sys_exit_remap_file_pages: OK

[   30.185559] Testing event kmalloc: OK

[   30.226750] Testing event kmem_cache_alloc: OK

[   30.272564] Testing event kmalloc_node: OK

[   30.314626] Testing event kmem_cache_alloc_node: OK

[   30.358878] Testing event kfree: OK

[   30.401862] Testing event kmem_cache_free: OK

[   30.440475] Testing event sys_enter_perf_counter_open: OK

[   30.481611] Testing event sys_exit_perf_counter_open: OK

[   30.526549] Testing event module_load: OK

[   30.569608] Testing event module_free: OK

[   30.612622] Testing event module_get: OK

[   30.652680] Testing event module_put: OK

[   30.695980] Testing event module_request: OK

[   30.737422] Testing event sys_enter_init_module: OK

[   30.779527] Testing event sys_exit_init_module: OK

[   30.822585] Testing event sys_enter_chown16: OK

[   30.867471] Testing event sys_exit_chown16: OK

[   30.905476] Testing event sys_enter_lchown16: OK

[   30.948682] Testing event sys_exit_lchown16: OK

[   30.990618] Testing event sys_enter_fchown16: OK

[   31.030808] Testing event sys_exit_fchown16: OK

[   31.072602] Testing event sys_enter_setregid16: OK

[   31.115728] Testing event sys_exit_setregid16: OK

[   31.160673] Testing event sys_enter_setgid16: OK

[   31.204548] Testing event sys_exit_setgid16: OK

[   31.249937] Testing event sys_enter_setreuid16: OK

[   31.294525] Testing event sys_exit_setreuid16: OK

[   31.336709] Testing event sys_enter_setuid16: OK

[   31.381560] Testing event sys_exit_setuid16: OK

[   31.423488] Testing event sys_enter_setresuid16: OK

[   31.467585] Testing event sys_exit_setresuid16: OK

[   31.509617] Testing event sys_enter_getresuid16: OK

[   31.555232] Testing event sys_exit_getresuid16: OK

[   31.596500] Testing event sys_enter_setresgid16: OK

[   31.641843] Testing event sys_exit_setresgid16: OK

[   31.685586] Testing event sys_enter_getresgid16: OK

[   31.730683] Testing event sys_exit_getresgid16: OK

[   31.770459] Testing event sys_enter_setfsuid16: OK

[   31.813967] Testing event sys_exit_setfsuid16: OK

[   31.853727] Testing event sys_enter_setfsgid16: OK

[   31.898479] Testing event sys_exit_setfsgid16: OK

[   31.941642] Testing event sys_enter_getgroups16: OK

[   31.983491] Testing event sys_exit_getgroups16: OK

[   32.028007] Testing event sys_enter_setgroups16: OK

[   32.072628] Testing event sys_exit_setgroups16: OK

[   32.116613] Testing event sys_enter_getuid16: OK

[   32.159635] Testing event sys_exit_getuid16: OK

[   32.197544] Testing event sys_enter_geteuid16: OK

[   32.240036] Testing event sys_exit_geteuid16: OK

[   32.278560] Testing event sys_enter_getgid16: OK

[   32.320993] Testing event sys_exit_getgid16: OK

[   32.361697] Testing event sys_enter_getegid16: 

[   32.378936] CPA self-test:

[   32.477878] OK

[   32.491991] Testing event sys_exit_getegid16: OK

[   32.602717] Testing event sys_enter_set_robust_list: OK

[   32.743597] Testing event sys_exit_set_robust_list: 

[   32.839559]  4k 81920 large 0 gb 0 x 81920[c0000000-d3fff000] miss 0

[   32.915256] OK

[   32.930583] Testing event sys_enter_get_robust_list: OK

[   33.045951] Testing event sys_exit_get_robust_list: OK

[   33.204580] Testing event sys_enter_futex: OK

[   33.345703] Testing event sys_exit_futex: OK

[   33.476568] Testing event lock_acquire: OK

[   33.628625] Testing event lock_release: OK

[   33.768783] Testing event sys_enter_getgroups: OK

[   33.918751] Testing event sys_exit_getgroups: 

[   34.017003]  4k 81920 large 0 gb 0 x 81920[c0000000-d3fff000] miss 0

[   34.065503] OK

[   34.081834] Testing event sys_enter_setgroups: OK

[   34.212768] Testing event sys_exit_setgroups: OK

[   34.356672] Testing event sys_enter_nanosleep: OK

[   34.487031] Testing event sys_exit_nanosleep: OK

[   34.633952] Testing event sys_enter_timer_create: OK

[   34.776960] Testing event sys_exit_timer_create: OK

[   34.929789] Testing event sys_enter_timer_gettime: 

[   35.020362]  4k 81920 large 0 gb 0 x 81920[c0000000-d3fff000] miss 0

[   35.069388] OK

[   35.085868] Testing event sys_exit_timer_gettime: 

[   35.104999] ok.

[   35.150611] OK

[   35.167607] Testing event sys_enter_timer_getoverrun: OK

[   35.211843] Testing event sys_exit_timer_getoverrun: OK

[   35.259749] Testing event sys_enter_timer_settime: OK

[   35.304004] Testing event sys_exit_timer_settime: OK

[   35.352782] Testing event sys_enter_timer_delete: OK

[   35.398524] Testing event sys_exit_timer_delete: OK

[   35.446671] Testing event sys_enter_clock_settime: OK

[   35.492958] Testing event sys_exit_clock_settime: OK

[   35.537986] Testing event sys_enter_clock_gettime: OK

[   35.582921] Testing event sys_exit_clock_gettime: OK

[   35.626984] Testing event sys_enter_clock_getres: OK

[   35.674875] Testing event sys_exit_clock_getres: OK

[   35.720896] Testing event sys_enter_clock_nanosleep: OK

[   35.770898] Testing event sys_exit_clock_nanosleep: OK

[   35.817258] Testing event workqueue_insertion: OK

[   35.858622] Testing event workqueue_execution: OK

[   35.901190] Testing event workqueue_creation: OK

[   35.944711] Testing event workqueue_destruction: OK

[   35.986782] Testing event sys_enter_setpriority: OK

[   36.029502] Testing event sys_exit_setpriority: OK

[   36.070499] Testing event sys_enter_getpriority: OK

[   36.115951] Testing event sys_exit_getpriority: OK

[   36.160676] Testing event sys_enter_reboot: OK

[   36.206615] Testing event sys_exit_reboot: OK

[   36.250623] Testing event sys_enter_setregid: OK

[   36.296580] Testing event sys_exit_setregid: OK

[   36.342940] Testing event sys_enter_setgid: OK

[   36.387749] Testing event sys_exit_setgid: OK

[   36.432591] Testing event sys_enter_setreuid: OK

[   36.471886] Testing event sys_exit_setreuid: OK

[   36.518195] Testing event sys_enter_setuid: OK

[   36.561632] Testing event sys_exit_setuid: OK

[   36.604637] Testing event sys_enter_setresuid: OK

[   36.647584] Testing event sys_exit_setresuid: OK

[   36.689557] Testing event sys_enter_getresuid: OK

[   36.732857] Testing event sys_exit_getresuid: OK

[   36.777527] Testing event sys_enter_setresgid: OK

[   36.821695] Testing event sys_exit_setresgid: OK

[   36.868427] Testing event sys_enter_getresgid: OK

[   36.910726] Testing event sys_exit_getresgid: OK

[   36.956472] Testing event sys_enter_setfsuid: OK

[   36.998531] Testing event sys_exit_setfsuid: OK

[   37.038516] Testing event sys_enter_setfsgid: OK

[   37.082588] Testing event sys_exit_setfsgid: OK

[   37.128669] Testing event sys_enter_times: OK

[   37.169589] Testing event sys_exit_times: OK

[   37.210609] Testing event sys_enter_setpgid: OK

[   37.256432] Testing event sys_exit_setpgid: OK

[   37.295733] Testing event sys_enter_getpgid: OK

[   37.338647] Testing event sys_exit_getpgid: OK

[   37.382030] Testing event sys_enter_getpgrp: OK

[   37.423976] Testing event sys_exit_getpgrp: OK

[   37.467543] Testing event sys_enter_getsid: OK

[   37.506690] Testing event sys_exit_getsid: OK

[   37.548901] Testing event sys_enter_setsid: OK

[   37.593792] Testing event sys_exit_setsid: OK

[   37.635765] Testing event sys_enter_newuname: OK

[   37.679644] Testing event sys_exit_newuname: OK

[   37.717989] Testing event sys_enter_sethostname: OK

[   37.759599] Testing event sys_exit_sethostname: OK

[   37.803889] Testing event sys_enter_setdomainname: OK

[   37.846864] Testing event sys_exit_setdomainname: OK

[   37.888711] Testing event sys_enter_getrlimit: OK

[   37.933635] Testing event sys_exit_getrlimit: OK

[   37.978495] Testing event sys_enter_old_getrlimit: OK

[   38.018849] Testing event sys_exit_old_getrlimit: OK

[   38.060570] Testing event sys_enter_setrlimit: OK

[   38.104630] Testing event sys_exit_setrlimit: OK

[   38.147586] Testing event sys_enter_getrusage: OK

[   38.191245] Testing event sys_exit_getrusage: OK

[   38.234666] Testing event sys_enter_umask: OK

[   38.275547] Testing event sys_exit_umask: OK

[   38.319949] Testing event sys_enter_prctl: OK

[   38.362446] Testing event sys_exit_prctl: OK

[   38.405921] Testing event sys_enter_getcpu: OK

[   38.450592] Testing event sys_exit_getcpu: OK

[   38.491572] Testing event sys_enter_restart_syscall: OK

[   38.536583] Testing event sys_exit_restart_syscall: OK

[   38.576624] Testing event sys_enter_rt_sigprocmask: OK

[   38.619313] Testing event sys_exit_rt_sigprocmask: OK

[   38.662598] Testing event sys_enter_rt_sigpending: OK

[   38.705483] Testing event sys_exit_rt_sigpending: OK

[   38.745517] Testing event sys_enter_rt_sigtimedwait: OK

[   38.791583] Testing event sys_exit_rt_sigtimedwait: OK

[   38.835411] Testing event sys_enter_kill: OK

[   38.879690] Testing event sys_exit_kill: OK

[   38.918644] Testing event sys_enter_tgkill: OK

[   38.958704] Testing event sys_exit_tgkill: OK

[   39.002616] Testing event sys_enter_tkill: OK

[   39.047554] Testing event sys_exit_tkill: OK

[   39.090608] Testing event sys_enter_rt_sigqueueinfo: OK

[   39.132678] Testing event sys_exit_rt_sigqueueinfo: OK

[   39.173778] Testing event sys_enter_rt_tgsigqueueinfo: OK

[   39.220678] Testing event sys_exit_rt_tgsigqueueinfo: OK

[   39.267470] Testing event sys_enter_sigpending: OK

[   39.308412] Testing event sys_exit_sigpending: OK

[   39.351565] Testing event sys_enter_sigprocmask: OK

[   39.396604] Testing event sys_exit_sigprocmask: OK

[   39.436656] Testing event sys_enter_rt_sigaction: OK

[   39.476483] Testing event sys_exit_rt_sigaction: OK

[   39.519540] Testing event sys_enter_sgetmask: OK

[   39.561663] Testing event sys_exit_sgetmask: OK

[   39.606633] Testing event sys_enter_ssetmask: OK

[   39.649576] Testing event sys_exit_ssetmask: OK

[   39.692684] Testing event sys_enter_signal: OK

[   39.734519] Testing event sys_exit_signal: OK

[   39.780667] Testing event sys_enter_pause: OK

[   39.821613] Testing event sys_exit_pause: OK

[   39.862797] Testing event sys_enter_rt_sigsuspend: OK

[   39.908471] Testing event sys_exit_rt_sigsuspend: OK

[   39.952872] Testing event sys_enter_alarm: OK

[   39.996716] Testing event sys_exit_alarm: OK

[   40.042637] Testing event sys_enter_getpid: OK

[   40.081628] Testing event sys_exit_getpid: OK

[   40.125611] Testing event sys_enter_getppid: OK

[   40.170580] Testing event sys_exit_getppid: OK

[   40.213456] Testing event sys_enter_getuid: OK

[   40.256414] Testing event sys_exit_getuid: OK

[   40.298851] Testing event sys_enter_geteuid: OK

[   40.339461] Testing event sys_exit_geteuid: OK

[   40.381834] Testing event sys_enter_getgid: OK

[   40.426461] Testing event sys_exit_getgid: OK

[   40.469706] Testing event sys_enter_getegid: OK

[   40.514558] Testing event sys_exit_getegid: OK

[   40.555865] Testing event sys_enter_gettid: OK

[   40.601801] Testing event sys_exit_gettid: OK

[   40.644944] Testing event sys_enter_sysinfo: OK

[   40.689016] Testing event sys_exit_sysinfo: OK

[   40.728574] Testing event sys_enter_ptrace: OK

[   40.769825] Testing event sys_exit_ptrace: OK

[   40.809680] Testing event sys_enter_capget: OK

[   40.848842] Testing event sys_exit_capget: OK

[   40.889825] Testing event sys_enter_capset: OK

[   40.932001] Testing event sys_exit_capset: OK

[   40.975689] Testing event sys_enter_sysctl: OK

[   41.016711] Testing event sys_exit_sysctl: OK

[   41.060690] Testing event irq_handler_entry: OK

[   41.101488] Testing event irq_handler_exit: OK

[   41.142010] Testing event softirq_entry: OK

[   41.177944] Testing event softirq_exit: OK

[   41.221677] Testing event sys_enter_time: OK

[   41.262912] Testing event sys_exit_time: OK

[   41.307704] Testing event sys_enter_stime: OK

[   41.350475] Testing event sys_exit_stime: OK

[   41.392771] Testing event sys_enter_gettimeofday: OK

[   41.433808] Testing event sys_exit_gettimeofday: OK

[   41.476034] Testing event sys_enter_settimeofday: OK

[   41.515006] Testing event sys_exit_settimeofday: OK

[   41.557600] Testing event sys_enter_adjtimex: OK

[   41.597886] Testing event sys_exit_adjtimex: OK

[   41.638864] Testing event sys_enter_getitimer: OK

[   41.681640] Testing event sys_exit_getitimer: OK

[   41.724422] Testing event sys_enter_setitimer: OK

[   41.765938] Testing event sys_exit_setitimer: OK

[   41.808676] Testing event sys_enter_exit: OK

[   41.851598] Testing event sys_exit_exit: OK

[   41.894570] Testing event sys_enter_exit_group: OK

[   41.938560] Testing event sys_exit_exit_group: OK

[   41.984729] Testing event sys_enter_waitid: OK

[   42.031670] Testing event sys_exit_waitid: OK

[   42.075672] Testing event sys_enter_wait4: OK

[   42.119622] Testing event sys_exit_wait4: OK

[   42.163023] Testing event sys_enter_waitpid: OK

[   42.205463] Testing event sys_exit_waitpid: OK

[   42.249611] Testing event sys_enter_syslog: OK

[   42.290617] Testing event sys_exit_syslog: OK

[   42.330578] Testing event sys_enter_personality: OK

[   42.373670] Testing event sys_exit_personality: OK

[   42.416804] Testing event sys_enter_set_tid_address: OK

[   42.457665] Testing event sys_exit_set_tid_address: OK

[   42.502450] Testing event sys_enter_unshare: OK

[   42.545602] Testing event sys_exit_unshare: OK

[   42.589524] Testing event sched_kthread_stop: OK

[   42.628906] Testing event sched_kthread_stop_ret: OK

[   42.672632] Testing event sched_wait_task: OK

[   42.713422] Testing event sched_wakeup: OK

[   42.756409] Testing event sched_wakeup_new: OK

[   42.798609] Testing event sched_switch: OK

[   42.835783] Testing event sched_migrate_task: OK

[   42.877990] Testing event sched_process_free: OK

[   42.921636] Testing event sched_process_exit: OK

[   42.964600] Testing event sched_process_wait: OK

[   43.007034] Testing event sched_process_fork: OK

[   43.050646] Testing event sched_signal_send: OK

[   43.095681] Testing event sys_enter_nice: OK

[   43.138610] Testing event sys_exit_nice: OK

[   43.180589] Testing event sys_enter_sched_setscheduler: OK

[   43.226582] Testing event sys_exit_sched_setscheduler: OK

[   43.272515] Testing event sys_enter_sched_setparam: OK

[   43.313545] Testing event sys_exit_sched_setparam: OK

[   43.354552] Testing event sys_enter_sched_getscheduler: OK

[   43.397647] Testing event sys_exit_sched_getscheduler: OK

[   43.441854] Testing event sys_enter_sched_getparam: OK

[   43.487699] Testing event sys_exit_sched_getparam: OK

[   43.532584] Testing event sys_enter_sched_setaffinity: OK

[   43.573656] Testing event sys_exit_sched_setaffinity: OK

[   43.618658] Testing event sys_enter_sched_getaffinity: OK

[   43.663837] Testing event sys_exit_sched_getaffinity: OK

[   43.709609] Testing event sys_enter_sched_yield: OK

[   43.754992] Testing event sys_exit_sched_yield: OK

[   43.799572] Testing event sys_enter_sched_get_priority_max: OK

[   43.844644] Testing event sys_exit_sched_get_priority_max: OK

[   43.891553] Testing event sys_enter_sched_get_priority_min: OK

[   43.934920] Testing event sys_exit_sched_get_priority_min: OK

[   43.979804] Testing event sys_enter_sched_rr_get_interval: OK

[   44.023835] Testing event sys_exit_sched_rr_get_interval: OK

[   44.069557] Running tests on trace event systems:

[   44.087634] Testing event system skb: OK

[   44.132522] Testing event system block: OK

[   44.226016] Testing event system kmem: OK

[   44.294719] Testing event system module: OK

[   44.353811] Testing event system lockdep: OK

[   44.430573] Testing event system workqueue: OK

[   44.483525] Testing event system irq: OK

[   44.544753] Testing event system sched: OK

[   44.621484] Testing event system syscalls: OK

[   45.376454] Running tests on all trace events:

[   45.394816] Testing all events: OK

[   46.777366] Testing kprobe tracing: OK

[   46.821276]   Magic number: 5:984:605

[   46.828137] register_blkdev: cannot get major 3 for hd

[   46.836948] rtc_cmos 00:03: setting system clock to 2009-08-20 23:36:06 UTC (1250811366)

[   46.910568] kjournald starting.  Commit interval 5 seconds

[   46.923465] EXT3-fs: mounted filesystem with writeback data mode.

[   46.934786] VFS: Mounted root (ext3 filesystem) readonly on device 3:1.

[   46.945880] debug: unmapping init memory c0bdd000..c0c65000

[   46.956939] Write protecting the kernel text: 5628k

[   46.965405] Testing CPA: Reverting c0100000-c067f000

[   46.975670] Testing CPA: write protecting again

[   46.986605] Write protecting the kernel read-only data: 3460k

[   46.996107] Testing CPA: undo c067f000-c09e0000

[   47.005347] Testing CPA: write protecting again

[   47.922602] grep used greatest stack depth: 1824 bytes left

[   64.948752] udevd used greatest stack depth: 1676 bytes left

[  549.382067] int3: 0000 [#1] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d013 ]---

[  549.382067] int3: 0000 [#2] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d014 ]---

[  549.382067] int3: 0000 [#3] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d015 ]---

[  549.382067] int3: 0000 [#4] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d016 ]---

[  549.382067] int3: 0000 [#5] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d017 ]---

[  549.382067] int3: 0000 [#6] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d018 ]---

[  549.382067] int3: 0000 [#7] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d019 ]---

[  549.382067] int3: 0000 [#8] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d01a ]---

[  549.382067] int3: 0000 [#9] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d01b ]---

[  549.382067] int3: 0000 [#10] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067] ---[ end trace 40c90e501f96d01c ]---

[  549.382067] int3: 0000 [#11] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067]  <IRQ> 

[  549.382067] BUG: unable to handle kernel NULL pointer dereference at 00000004

[  549.382067] IP: [<c01265c2>] ret_from_intr+0x0/0x7

[  549.382067] *pdpt = 000000000eae9001 *pde = 0000000000000000 

[  549.382067] Thread overran stack, or stack corrupted

[  549.382067] Oops: 0000 [#12] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c014aa83>] no_context+0x1cc/0x20b

[  549.382067]  [<c014ac89>] __bad_area_nosemaphore+0x1c7/0x1cf

[  549.382067]  [<c06762c3>] ? preempt_schedule+0x35/0x70

[  549.382067]  [<c01e3b42>] ? start_critical_timing+0x33/0x10c

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c01e3b42>] ? start_critical_timing+0x33/0x10c

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c067875f>] ? _spin_unlock_irqrestore+0x4a/0xa2

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c067a8c3>] ? kprobe_fault_handler+0x98/0xfc

[  549.382067]  [<c014aca3>] bad_area_nosemaphore+0x12/0x15

[  549.382067]  [<c067b66b>] do_page_fault+0x30c/0x6b8

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c0678ffb>] error_code+0x63/0x68

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0120000>] ? kvm_pit_reset+0x5e/0x66

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c01265c2>] ? ret_from_intr+0x0/0x7

[  549.382067]  [<c01289f7>] dump_trace+0xe8/0x13d

[  549.382067]  [<c0129886>] show_trace_log_lvl+0x38/0x43

[  549.382067]  [<c01298a6>] show_trace+0x15/0x19

[  549.382067]  [<c0675426>] dump_stack+0x5b/0x65

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c01250ed>] ? __show_regs+0x1/0x1fd

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c0129804>] die+0x5e/0x8c

[  549.382067]  [<c06792a3>] do_trap+0xf9/0x12c

[  549.382067]  [<c067938c>] do_int3+0x5e/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c012007b>] ? kvm_create_pit+0x73/0x22f

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0230bd7>] ? __slab_alloc+0x3de/0x90f

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c023244e>] __kmalloc+0x167/0x22c

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] ? kzalloc+0x11/0x13

[  549.382067]  [<c01eaec2>] kzalloc+0x11/0x13

[  549.382067]  [<c01eaf4d>] init_preds+0x89/0xd1

[  549.382067]  [<c01edb9b>] probe_event_raw_init+0x11/0x15

[  549.382067]  [<c01e7182>] trace_add_event_call+0x5a/0x10e

[  549.382067]  [<c01ee17e>] command_trace_probe+0x5df/0x69c

[  549.382067]  [<c02126bc>] ? might_fault+0x81/0xc5

[  549.382067]  [<c03778c6>] ? __copy_from_user_ll+0x16/0xe8

[  549.382067]  [<c01ee3a4>] probes_write+0x169/0x1b3

[  549.382067]  [<c01ee23b>] ? probes_write+0x0/0x1b3

[  549.382067]  [<c023b437>] vfs_write+0x12f/0x16f

[  549.382067]  [<c023b56c>] sys_write+0x56/0x78

[  549.382067]  [<c01266a4>] sysenter_do_call+0x12/0x32

[  549.382067]  <IRQ> 

[  549.382067] BUG: unable to handle kernel NULL pointer dereference at 00000f46

[  549.382067] IP: [<c01250ec>] __show_regs+0x0/0x1fd

[  549.382067] *pdpt = 000000000eae9001 *pde = 0000000000000000 

[  549.382067] Thread overran stack, or stack corrupted

[  549.382067] Oops: 0000 [#13] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c014aa83>] no_context+0x1cc/0x20b

[  549.382067]  [<c014ac89>] __bad_area_nosemaphore+0x1c7/0x1cf

[  549.382067]  [<c037c5a1>] ? _raw_spin_unlock+0xd0/0x10a

[  549.382067]  [<c01e3b42>] ? start_critical_timing+0x33/0x10c

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c01e3b42>] ? start_critical_timing+0x33/0x10c

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c019ff31>] ? trace_hardirqs_off+0xb/0xd

[  549.382067]  [<c067875f>] ? _spin_unlock_irqrestore+0x4a/0xa2

[  549.382067]  [<c01e3c59>] ? time_hardirqs_off+0x3e/0x41

[  549.382067]  [<c067a8c3>] ? kprobe_fault_handler+0x98/0xfc

[  549.382067]  [<c014aca3>] bad_area_nosemaphore+0x12/0x15

[  549.382067]  [<c067b66b>] do_page_fault+0x30c/0x6b8

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c0678ffb>] error_code+0x63/0x68

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0120000>] ? kvm_pit_reset+0x5e/0x66

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c01250ec>] ? __show_regs+0x0/0x1fd

[  549.382067]  [<c01289f7>] dump_trace+0xe8/0x13d

[  549.382067]  [<c0129886>] show_trace_log_lvl+0x38/0x43

[  549.382067] ---[ end trace 40c90e501f96d01d ]---

[  549.382067] int3: 0000 [#14] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#15] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#16] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#17] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#18] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#19] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#20] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#21] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#22] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#23] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#24] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#25] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#26] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#27] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#28] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#29] PREEMPT DEBUG_PAGEALLOC<1>[  549.382067] BUG: unable to handle kernel paging request at 59ad5ec0

[  549.382067] IP: [<c01250ec>] __show_regs+0x0/0x1fd

[  549.382067] *pdpt = 000000000ead9001 *pde = 0000000000000000 

[  549.382067] Thread overran stack, or stack corrupted

[  549.382067] Oops: 0002 [#30] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c01ddc29>] ? trace_current_buffer_lock_reserve+0x15/0x17

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c014aa83>] no_context+0x1cc/0x20b

[  549.382067]  [<c014ac89>] __bad_area_nosemaphore+0x1c7/0x1cf

[  549.382067]  [<c03a15eb>] ? bit_clear+0x6c/0x75

[  549.382067]  [<c067a8c3>] ? kprobe_fault_handler+0x98/0xfc

[  549.382067]  [<c014aca3>] bad_area_nosemaphore+0x12/0x15

[  549.382067]  [<c067b66b>] do_page_fault+0x30c/0x6b8

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c0678ffb>] error_code+0x63/0x68

[  549.382067] ---[ end trace 40c90e501f96d01e ]---

[  549.382067] int3: 0000 [#31] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#32] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#33] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#34] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#35] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#36] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#37] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#38] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#39] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#40] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#41] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#42] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#43] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#44] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#45] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#46] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#47] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] BUG: unable to handle kernel paging request at 2ec01930

[  549.382067] IP: [<c01250ec>] __show_regs+0x0/0x1fd

[  549.382067] *pdpt = 000000000eae9001 *pde = 0000000000000000 

[  549.382067] Thread overran stack, or stack corrupted

[  549.382067] Oops: 0000 [#48] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] ------------[ cut here ]------------

[  549.382067] WARNING: at arch/x86/kernel/kprobes.c:499 kprobe_exceptions_notify+0x23f/0x662()

[  549.382067] Hardware name: Deskpro EN Series

[  549.382067] Modules linked in:

[  549.382067] Pid: 3910, comm: kprobestest Tainted: G        W  2.6.31-rc5-00546-g429839d #122

[  549.382067] Call Trace:

[  549.382067]  [<c0165737>] warn_slowpath_common+0x93/0xc3

[  549.382067]  [<c0165779>] warn_slowpath_null+0x12/0x15

[  549.382067]  [<c067ab66>] kprobe_exceptions_notify+0x23f/0x662

[  549.382067]  [<c01ddc29>] ? trace_current_buffer_lock_reserve+0x15/0x17

[  549.382067]  [<c067bd2a>] notifier_call_chain+0x2b/0x7a

[  549.382067]  [<c067bdbc>] __atomic_notifier_call_chain+0x43/0xa9

[  549.382067]  [<c067bd79>] ? __atomic_notifier_call_chain+0x0/0xa9

[  549.382067]  [<c067be2e>] atomic_notifier_call_chain+0xc/0xe

[  549.382067]  [<c0193823>] notify_die+0x2d/0x2f

[  549.382067]  [<c067934d>] do_int3+0x1f/0x6f

[  549.382067]  [<c067919a>] int3+0x2e/0x34

[  549.382067]  [<c067007b>] ? pcwd_isa_probe+0x34e/0x662

[  549.382067]  [<c01265bd>] ? ret_from_exception+0x1/0x6

[  549.382067]  [<c01a007b>] ? print_lock_dependencies+0xa6/0x1ab

[  549.382067]  [<c0128732>] ? show_registers+0x20/0x1fd

[  549.382067]  [<c0679bbf>] __die+0x92/0xf6

[  549.382067]  [<c014aa83>] no_context+0x1cc/0x20b

[  549.382067]  [<c014ac89>] __bad_area_nosemaphore+0x1c7/0x1cf

[  549.382067]  [<c067a8c3>] ? kprobe_fault_handler+0x98/0xfc

[  549.382067]  [<c014aca3>] bad_area_nosemaphore+0x12/0x15

[  549.382067]  [<c067b66b>] do_page_fault+0x30c/0x6b8

[  549.382067]  [<c067b35f>] ? do_page_fault+0x0/0x6b8

[  549.382067]  [<c0678ffb>] error_code+0x63/0x68

[  549.382067] ---[ end trace 40c90e501f96d01f ]---

[  549.382067] int3: 0000 [#49] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#50] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#51] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#52] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#53] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#54] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#55] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#56] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#57] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#58] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#59] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#60] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#61] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#62] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#63] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#64] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range

[  549.382067] Modules linked in:

[  549.382067] int3: 0000 [#65] PREEMPT DEBUG_PAGEALLOC

[  549.382067] last sysfs file: /sys/block/ram9/range


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc5
# Thu Aug 20 22:40:03 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_EVENT_PROFILE=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_OLD_MCE is not set
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_X86_CPU_DEBUG is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_PCI is not set
# CONFIG_B44 is not set
# CONFIG_CS89x0 is not set
# CONFIG_KS8842 is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_STUB is not set
CONFIG_SCx200_ACB=y

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_PCF8574=y
# CONFIG_PCF8575 is not set
CONFIG_SENSORS_PCA9539=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
CONFIG_EUROTECH_WDT=y
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
CONFIG_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_MATROX_MULTIHEAD=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
# CONFIG_FB_MB862XX_PCI_GDC is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=y
CONFIG_BACKLIGHT_SAHARA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_BOOT_TRACER is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
CONFIG_KVM_TRACE=y
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y

--EVF5PPMfhYS0aIcm--

