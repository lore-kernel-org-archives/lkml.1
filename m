Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXDGMa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXDGMa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 08:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXDGMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 08:30:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28623 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965821AbXDGMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 08:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=kUbuW9G58qRrytT9HGWjxF88LzBvi/9NP02F1HhdAGif6bjdAKSPqIut8cMfudFyJFnh0FcRMu4JKyPBtnxxQeESvNkINvJoY/w5o7KQI9AlXkOq+FbyrMOdRt21YNWN2uofm8FQTADVj+neBVEPoza5H0/mZKh//gZ3slixSc4=
Message-ID: <46178ECC.2030107@googlemail.com>
Date: Sat, 07 Apr 2007 14:30:04 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
In-Reply-To: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
> 
> It contains the following patches against 2.6.21-rc6:
> 

LTP triggered a ptrace problem.

------------[ cut here ]------------
kernel BUG at kernel/ptrace.c:1281!
invalid opcode: 0000 [#1]
PREEMPT SMP 
last sysfs file: devices/platform/w83627hf.656/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c0163566>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc6-mm1 #1)
EIP is at ptrace_do_wait+0x1eb/0x510

 l *0xc0163566
0xc0163566 is in ptrace_do_wait (kernel/ptrace.c:1281).
1276
1277            pr_debug("%d ptrace_do_wait (%d) found %d code %x (%u/%d)\n",
1278                     current->pid, tsk->pid, p->pid, exit_code,
1279                     p->exit_state, p->exit_signal);
1280
1281            NO_LOCKS;
1282
1283            /*
1284             * If there was a group exit in progress, all threads report that
1285             * status.  Most will have SIGKILL in their own exit_code.


eax: 00000001   ebx: cff43550   ecx: c04b043c   edx: 00000001
esi: fffffff6   edi: 0000000c   ebp: c96c5f10   esp: c96c5ee8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ptrace01 (pid: 8610, ti=c96c4000 task=c9554b00 task.ti=c96c4000)
Stack: 00000002 00000004 000021a3 c9554b00 cc8aa808 00000000 c96c5f10 cff43550 
       00000001 fffffff6 c96c5f80 c0127e10 00000000 bf833c78 00000000 00000134 
       00000000 00000004 000021a3 c9554b00 00000001 00000001 00000000 c9554bbc 
Call Trace:
 [<c0127e10>] do_wait+0x9d6/0xbad
 [<c0128017>] sys_wait4+0x30/0x32
 [<c0128040>] sys_waitpid+0x27/0x29
 [<c010424c>] syscall_call+0x7/0xb
 [<b7f36410>] 0xb7f36410
 =======================
INFO: lockdep is turned off.
Code: a9 9d 0b 00 85 c0 74 05 e8 87 b8 1e 00 89 e0 25 00 e0 ff ff 31 d2 83 78 14 00 0f 95 c2 b8 3c 04 4b c0 e8 86 9d 0b 00 85 c0 74 04 <0f> 0b eb fe 8b 83 5c 04 00 00 f6 40 54 08 74 03 8b 78 44 83 bb 
EIP: [<c0163566>] ptrace_do_wait+0x1eb/0x510 SS:ESP 0068:c96c5ee8
------------[ cut here ]------------
kernel BUG at kernel/ptrace.c:494!
invalid opcode: 0000 [#2]
PREEMPT SMP 
last sysfs file: devices/platform/w83627hf.656/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c0163f22>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc6-mm1 #1)
EIP is at ptrace_exit+0x29/0x21d

l *0xc0163f22
0xc0163f22 is in ptrace_exit (kernel/ptrace.c:494).
489     ptrace_exit(struct task_struct *tsk)
490     {
491             struct list_head *pos, *n;
492             int restart;
493
494             NO_LOCKS;
495
496             /*
497              * Taking the task_lock after PF_EXITING is set ensures that a
498              * child in ptrace_traceme will not put itself on our list when

eax: 00000001   ebx: 00000000   ecx: c04b1044   edx: 00000001
esi: c96c5ee8   edi: c9554b00   ebp: c96c5d78   esp: c96c5d60
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ptrace01 (pid: 8610, ti=c96c4000 task=c9554b00 task.ti=c96c4000)
Stack: ffffffff 00000000 c96c5d78 00000000 c96c5ee8 c9554b00 c96c5db8 c012820e 
       00000001 00000286 c96c5da8 c011fec8 00000001 c04a007b c96c007b c02100d8 
       ffffff10 c96c5eb0 0000000b c96c5eb0 c96c5ee8 c03f0068 c96c5de8 c0105a77 
Call Trace:
 [<c012820e>] do_exit+0x16b/0x86c
 [<c0105a77>] die+0x206/0x22c
 [<c0105b27>] do_trap+0x8a/0xa4
 [<c0105e93>] do_invalid_op+0x88/0x92
 [<c0351e89>] error_code+0x79/0x80
 [<c0163566>] ptrace_do_wait+0x1eb/0x510
 [<c0127e10>] do_wait+0x9d6/0xbad
 [<c0128017>] sys_wait4+0x30/0x32
 [<c0128040>] sys_waitpid+0x27/0x29
 [<c010424c>] syscall_call+0x7/0xb
 [<b7f36410>] 0xb7f36410
 =======================
INFO: lockdep is turned off.
Code: 5d c3 55 89 e5 57 56 53 83 ec 0c 89 c7 89 e0 25 00 e0 ff ff 31 d2 83 78 14 00 0f 95 c2 b8 44 10 4b c0 e8 ca 93 0b 00 85 c0 74 04 <0f> 0b eb fe 8d 9f b8 04 00 00 89 d8 e8 e7 d5 1e 00 8d 87 40 0a 
EIP: [<c0163f22>] ptrace_exit+0x29/0x21d SS:ESP 0068:c96c5d60
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: ptrace01/0x00000001/8610
INFO: lockdep is turned off.
 [<c01052c1>] dump_trace+0x63/0x1eb
 [<c0105463>] show_trace_log_lvl+0x1a/0x30
 [<c01060aa>] show_trace+0x12/0x14
 [<c0106147>] dump_stack+0x16/0x18
 [<c034e2e2>] __sched_text_start+0x92/0xad4
 [<c0128203>] do_exit+0x160/0x86c
 [<c0105a77>] die+0x206/0x22c
 [<c0105b27>] do_trap+0x8a/0xa4
 [<c0105e93>] do_invalid_op+0x88/0x92
 [<c0351e89>] error_code+0x79/0x80
 [<c0163f22>] ptrace_exit+0x29/0x21d
 [<c012820e>] do_exit+0x16b/0x86c
 [<c0105a77>] die+0x206/0x22c
 [<c0105b27>] do_trap+0x8a/0xa4
 [<c0105e93>] do_invalid_op+0x88/0x92
 [<c0351e89>] error_code+0x79/0x80
 [<c0163566>] ptrace_do_wait+0x1eb/0x510
 [<c0127e10>] do_wait+0x9d6/0xbad
 [<c0128017>] sys_wait4+0x30/0x32
 [<c0128040>] sys_waitpid+0x27/0x29
 [<c010424c>] syscall_call+0x7/0xb
 [<b7f36410>] 0xb7f36410
 =======================
BUG: NMI Watchdog detected LOCKUP on CPU1, eip c0351104, registers:
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c0351104>]    Not tainted VLI
EFLAGS: 00000087   (2.6.21-rc6-mm1 #1)
EIP is at __write_lock_failed+0xc/0x20

 l *0xc0351104
0xc0351104 is at include/linux/sched.h:1597.
1592            clear_tsk_thread_flag(tsk,TIF_NEED_RESCHED);
1593    }
1594
1595    static inline int signal_pending(struct task_struct *p)
1596    {
1597            return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
1598    }
1599
1600    static inline int need_resched(void)
1601    {

eax: c04ecc00   ebx: c04ecc00   ecx: c04c3f9c   edx: 00000000
esi: 00000000   edi: b7a11bd8   ebp: c9a1dea0   esp: c9a1dea0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process automount (pid: 2546, ti=c9a1c000 task=c9878a80 task.ti=c9a1c000)
Stack: c9a1deb0 c021c58c 00000000 c04ecc00 c9a1ded0 c035166e 00000000 00000002 
       c0123e8e c0122038 cade9510 cade9510 c9a1df30 c0123e8e 00000000 cade9510 
       c9a1dfb8 c021c312 c04ece80 c04ece80 c9a1dfb8 b7a114b4 003d0f00 00010000 
Call Trace:
Inexact backtrace:
 [<c0105463>] show_trace_log_lvl+0x1a/0x30
 [<c0105516>] show_stack_log_lvl+0x9d/0xac
 [<c0105712>] show_registers+0x1ed/0x34c
 [<c01061ca>] die_nmi+0x81/0xd9
 [<c0116ebe>] nmi_watchdog_tick+0x12e/0x20c
 [<c010655a>] do_nmi+0x97/0x274
 [<c0351f33>] nmi_stack_correct+0x26/0x2b
 [<c021c58c>] _raw_write_lock+0x8f/0xa7
 [<c035166e>] _write_lock_irq+0x42/0x48
 [<c0123e8e>] copy_process+0xe86/0x138b
 [<c01243e3>] do_fork+0x50/0x1c5
 [<c010223f>] sys_clone+0x33/0x39
 [<c010424c>] syscall_call+0x7/0xb
 =======================
INFO: lockdep is turned off.
Code: 89 e5 52 51 e8 e6 ce ff ff 59 5a 5d c3 90 90 55 89 e5 52 51 e8 24 cf ff ff 59 5a 5d c3 90 90 55 89 e5 f0 81 00 00 00 00 01 f3 90 <81> 38 00 00 00 01 75 f6 f0 81 28 00 00 00 01 75 e6 5d c3 90 55 

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-serialconsole.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
