Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYHSJ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYHSJ7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYHSJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:59:16 -0400
Received: from smtp1.extricom.com ([212.235.24.249]:57369 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755964AbYHSJ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:59:13 -0400
Message-ID: <48AA98E4.6060606@extricom.com>
Date: Tue, 19 Aug 2008 12:56:52 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <20080818184158.GA1798@Krystal>
In-Reply-To: <20080818184158.GA1798@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Can you check if, at some point during the system execution (starting
> from boot), 0xdd5b1d58 is an address where a module is loaded ? (the
> module can be later unloaded, what I wonder is if this address would
> appear to have had a loaded+unloaded module).
>
> Actually, could you try to compile your kernel without "MODULE_UNLOAD" ?
>
> Mathieu
>   
No modules...

~ # uname -a
Linux 2.6.27-rc2 #6 Tue Aug 19 12:33:34 IDT 2008 ppc unknown
~ # gunzip /proc/config.gz -c | grep UNLOAD
# CONFIG_MODULE_UNLOAD is not set
~ # gunzip /proc/config.gz -c | grep FTRACE
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
~ # gunzip /proc/config.gz -c | grep MARKERS
CONFIG_MARKERS=y
~ # lsmod
Module                  Size  Used by
~ # while [ 1 ] ; do find / > /dev/null ; echo .  ; done
.
Oops: Exception in kernel mode, sig: 11 [#1]
Exsw1600
Modules linked in:
NIP: c00bb724 LR: c00bb724 CTR: 00000000
REGS: d8b59c50 TRAP: 0700   Not tainted  (2.6.27-rc2)
MSR: 00029000 <EE,ME>  CR: 24082282  XER: 20000000
TASK = dbc68de0[1712] 'find' THREAD: d8b58000
GPR00: 00000000 d8b59d00 dbc68de0 dd801180 d8b59d68 d8b59d58 dd8019db 
100234ec
GPR08: c0800000 00019330 0000ffff d8b59d20 24000288 100ad874 100936f8 
1008a1d0
GPR16: 10083f80 d8b59e2c d8b59d68 fffffff4 c0380000 d8b59d60 d8b59d58 
dd802084
GPR24: ddc69500 dd802018 d8b59d68 c0380000 dd801180 d8b59d68 00000000 
d8b59d00
NIP [c00bb724] d_lookup+0x40/0x90
LR [c00bb724] d_lookup+0x40/0x90
Call Trace:
[d8b59d00] [d8b59d58] 0xd8b59d58 (unreliable)
[d8b59d20] [c00ae7c8] do_lookup+0xe8/0x220
[d8b59d50] [c00b0684] __link_path_walk+0x5a4/0xd54
[d8b59dc0] [c00b0e8c] path_walk+0x58/0xe0
[d8b59df0] [c00b0ffc] do_path_lookup+0x78/0x13c
[d8b59e20] [c00b1cf8] user_path_at+0x64/0xac
[d8b59e90] [c00a8c98] vfs_lstat_fd+0x34/0x74
[d8b59ec0] [c00a8d6c] vfs_lstat+0x30/0x48
[d8b59ed0] [c00a8db4] sys_lstat64+0x30/0x5c
[d8b59f40] [c0010554] ret_from_syscall+0x0/0x3c
Instruction dump:
7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db32a0
73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b32a0
---[ end trace 7766edd310cd3442 ]---

