Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXIXH54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXIXH54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXIXH5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:57:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbXIXH5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:57:46 -0400
Date: Mon, 24 Sep 2007 00:57:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH getrusage: return ru_maxrss
Message-Id: <20070924005709.6a151794.akpm@linux-foundation.org>
In-Reply-To: <1190311039.13070.19.camel@peace.smo.corp.google.com>
References: <1190311039.13070.19.camel@peace.smo.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 10:57:19 -0700 Frank Mayhar <fmayhar@google.com> wrote:

> Properly support the ru_maxrss field of the rusage structure returned by
> getrusage().  This patch includes documentation both of the getrusage()
> implementation in general and of the ru_maxrss implementation
> specifically.  This implementation matches that of FreeBSD, which is the
> only other OS of which I'm aware that implements this field.
> 
> Like a number of other folks, we recently had a need for a non-/proc way
> of getting the RSS of a process and happened on getrusage().  Unlike the
> rest, though, we fixed the system call to do what we want.  I wrote a
> wrong implementation and submitted it while I was sick; this time I took
> my time and I think I got it right.
> 
> A test program that has been run against a number of systems (of which
> only FreeBSD and Linux 2.6 with this patch applied passed) is also
> available at
> 	http://www.exit.com/Archives/Linux/
> 

Nice patch, but the Vaio always wins ;)

It boots OK, but when I ssh into the machine:

[   56.310698] sonypi: ioport 0x1080 busy, using sony-laptop? if not use check_ioport=0
[   56.314186] sonypi: failed to request ioports
[   56.317362] sonypi: probe of sonypi failed with error -16
[   57.017983] ipw2200: Radio Frequency Kill Switch is On:
[   57.017985] Kill switch must be turned off for wireless networking to work.
[   57.124331] ipw2200: Failed to send WEP_KEY: Aborted due to RF kill switch.
[   57.242396] ipw2200: Failed to send WEP_KEY: Command timed out.
[   60.343396] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000009c
[   60.343573] printing eip: c012ba9c *pde = 00000000 
[   60.343680] Oops: 0000 [#1] PREEMPT 
[   60.343763] last sysfs file: /devices/system/cpu/cpu0/cpufreq/scaling_setspeed
[   60.343894] Modules linked in: ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq sbs sbshc nvram ohci1394 ieee1394 ehci_hcd uhci_hcd sg joydev snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ieee80211 sr_mod cdrom snd_pcm ieee80211_crypt snd_timer i2c_i801 i2c_core snd pcspkr soundcore piix snd_page_alloc battery button ac generic ext3 jbd ide_disk ide_core
[   60.345225] 
[   60.345258] Pid: 2503, comm: zsh Not tainted (2.6.23-rc7-mm1 #9)
[   60.345367] EIP: 0060:[<c012ba9c>] EFLAGS: 00010046 CPU: 0
[   60.345472] EIP is at getrusage+0x181/0x21f
[   60.345551] EAX: 00000000 EBX: 00000000 ECX: c2370ec0 EDX: 00000000
[   60.345665] ESI: c2370ec0 EDI: 00000002 EBP: c3cc3f1c ESP: c3cc3ec0
[   60.345779]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   60.345878] Process zsh (pid: 2503, ti=c3cc2000 task=c3cc0e00 task.ti=c3cc2000)
[   60.346009] last branch before last exception/interrupt
[   60.346112]  from c012ba9c (getrusage+0x181/0x21f)
[   60.346210]  to c0325f70 (__kprobes_text_start+0x0/0x8)
[   60.346317] Stack: bfc698f4 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
[   60.346539]        00000000 00000159 00000000 00000000 00000100 00000000 00000000 00000000 
[   60.346759]        00000000 00000001 00000001 00000296 00000000 c341ca40 c2370ec0 c3cc3fa0 
[   60.346981] Call Trace:
[   60.347036]  [<c0104f55>] show_trace_log_lvl+0x1a/0x2f
[   60.347141]  [<c0105007>] show_stack_log_lvl+0x9d/0xa5
[   60.347245]  [<c010513d>] show_registers+0x12e/0x26a
[   60.347346]  [<c010537f>] die+0x106/0x1ec
[   60.347430]  [<c0118b30>] do_page_fault+0x483/0x56b
[   60.347529]  [<c0325fe2>] error_code+0x6a/0x70
[   60.347620]  [<c012347c>] do_wait+0x5ae/0x9fa
[   60.347712]  [<c01238f8>] sys_wait4+0x30/0x32
[   60.347933]  [<c0103f92>] syscall_call+0x7/0xb
[   60.348024]  =======================
[   60.348091] Code: 81 5c 0c 00 00 8b 91 60 0c 00 00 0f ac d0 09 01 45 d8 c1 ea 09 8b 89 20 01 00 00 81 e9 20 01 00 00 39 f1 75 94 8b 86 b4 00 00 00 <8b> 90 9c 00 00 00 03 90 98 00 00 00 39 90 a0 00 00 00 73 06 89 
[   60.348909] EIP: [<c012ba9c>] getrusage+0x181/0x21f SS:ESP 0068:c3cc3ec0
[   60.349049] note: zsh[2503] exited with preempt_count 2
[   60.349218] BUG: scheduling while atomic: zsh/2503/0x10000003
[   60.349323] INFO: lockdep is turned off.
[   60.349397]  [<c0104f55>] show_trace_log_lvl+0x1a/0x2f
[   60.349501]  [<c01059db>] show_trace+0x12/0x14
[   60.349592]  [<c0105afa>] dump_stack+0x15/0x17
[   60.354070]  [<c011b257>] __schedule_bug+0x65/0x6c
[   60.358647]  [<c0322ede>] __sched_text_start+0x5e/0x30d
[   60.363137]  [<c011b27f>] __cond_resched+0x21/0x3b
[   60.367704]  [<c0323815>] cond_resched+0x26/0x31
[   60.372158]  [<c016237b>] unmap_vmas+0x36c/0x44a
[   60.376555]  [<c0164be8>] exit_mmap+0x68/0xf0
[   60.380895]  [<c011f106>] mmput+0x34/0x93
[   60.385293]  [<c0122763>] exit_mm+0xb7/0xbc
[   60.389543]  [<c0123b95>] do_exit+0x212/0x6ea
[   60.393717]  [<c010545d>] die+0x1e4/0x1ec
[   60.397868]  [<c0118b30>] do_page_fault+0x483/0x56b
[   60.402058]  [<c0325fe2>] error_code+0x6a/0x70
[   60.406018]  [<c012347c>] do_wait+0x5ae/0x9fa
[   60.409780]  [<c01238f8>] sys_wait4+0x30/0x32
[   60.413375]  [<c0103f92>] syscall_call+0x7/0xb
[   60.416877]  =======================
[   60.524087] BUG: scheduling while atomic: zsh/2503/0x10000003
[   60.527489] INFO: lockdep is turned off.
[   60.530845]  [<c0104f55>] show_trace_log_lvl+0x1a/0x2f
[   60.534230]  [<c01059db>] show_trace+0x12/0x14
[   60.537543]  [<c0105afa>] dump_stack+0x15/0x17
[   60.540851]  [<c011b257>] __schedule_bug+0x65/0x6c
[   60.544142]  [<c0322ede>] __sched_text_start+0x5e/0x30d
[   60.547391]  [<c011b27f>] __cond_resched+0x21/0x3b
[   60.550589]  [<c0323815>] cond_resched+0x26/0x31
[   60.553772]  [<c0122a6f>] put_files_struct+0x6b/0xa8
[   60.556932]  [<c0123bd6>] do_exit+0x253/0x6ea
[   60.560039]  [<c010545d>] die+0x1e4/0x1ec
[   60.563147]  [<c0118b30>] do_page_fault+0x483/0x56b
[   60.566273]  [<c0325fe2>] error_code+0x6a/0x70
[   60.569318]  [<c012347c>] do_wait+0x5ae/0x9fa
[   60.572357]  [<c01238f8>] sys_wait4+0x30/0x32
[   60.575411]  [<c0103f92>] syscall_call+0x7/0xb
[   60.578461]  =======================
Linux version 2.6.23-rc7-mm1 (akpm@box) (gcc version 4.1.0) #10 PREEMPT Mon Sep 24 00:51:00 PDT 2007


Distro is FC5, config is http://userweb.kernel.org/~akpm/config-sony.txt
