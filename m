Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXJIUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXJIUIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJIUIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:08:42 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:60345 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXJIUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:08:36 -0400
Date: Tue, 9 Oct 2007 22:08:26 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Strange system hangs
In-Reply-To: <200709290614.02918.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710092158080.29165@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
 <200709290614.02918.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-732856416-1191960506=:29165"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-732856416-1191960506=:29165
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 29 Sep 2007, Nick Piggin wrote:

> On Friday 28 September 2007 18:42, Krzysztof Oledzki wrote:
>> Hello,
>>
>> I am experiencing weird system hangs. Once about 2-5 weeks system freeze=
s
>> and stops accepting remote connections, so it is no longer possible to
>> connect to most important services: smtp (postfix), www (squid) or even
>> ssh. Such connection is accepted but then it hangs.
>>
>> What is strange, that previously established ssh session is usable. It i=
s
>> possible to work on such system until you do something stupid like "less
>> /var/log/all.log". Using strace I found that process blocks on:
>
> Is this a regression? If so, what's the most recent kernel that didn't sh=
ow
> the problem?
>
> The symptoms could be consistent with some place doing a
> balance_dirty_pages while holding a lock that is required for IO, but I c=
an't
> see a smoking gun (you've got contention on i_mutex, but that should be
> OK).
>
> Can you see if there is any memory under writeback that isn't being
> completed (sysrq+M),

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd=
:  47
CPU    1: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd=
:  54
Active:340169 inactive:117325 dirty:48579 writeback:0 unstable:0
  free:25266 slab:28357 mapped:3109 pagetables:816 bounce:0
DMA free:8784kB min:512kB low:640kB high:768kB active:0kB inactive:72kB pre=
sent:16256kB pages_scanned:36 all_unreclaimable? no
lowmem_reserve[]: 0 2015
Normal free:92280kB min:65016kB low:81268kB high:97524kB active:1360676kB i=
nactive:469228kB present:2064260kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
DMA: 12*4kB 6*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2=
048kB 2*4096kB =3D 8784kB
Normal: 2724*4kB 1863*8kB 95*16kB 0*32kB 1*64kB 3*128kB 0*256kB 0*512kB 1*1=
024kB 1*2048kB 15*4096kB =3D 92280kB
Swap cache: add 6396, delete 6331, find 3048/3691, race 0+0
Free swap  =3D 2927260kB
Total swap =3D 2927608kB
Free swap:       2927260kB
524224 pages of RAM
0 pages of HIGHMEM
6345 reserved pages
302073 pages shared
65 pages swap cached
48579 pages dirty
0 pages writeback
3109 pages mapped
28357 pages slab
816 pages pagetables
--------------------------


> also a list the locks held after the hang might be
> helpful (compile in lockdep and sysrq+D)

SysRq : Show Locks Held
Showing all locks held in the system:
1 lock held by syslogd/2163:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by freshclam/2864:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by named/2925:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by crond/3027:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by squid/3559:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by zabbix_agentd/3701:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by agetty/3753:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3754:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3755:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3756:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3758:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3759:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3760:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by bash/3851:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by bash/3866:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by bash/3888:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by bash/6622:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/27417:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by bash/9224:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by amavisd/15049:
  #0:  (&mm->mmap_sem){----}, at: [<781196ad>] do_page_fault+0x152/0x535
1 lock held by amavisd/15169:
  #0:  (&mm->mmap_sem){----}, at: [<781196ad>] do_page_fault+0x152/0x535
1 lock held by sadc/16498:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by mkpir/16842:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by fetch_mail_stat/16843:
  #0:  (&inode->i_mutex){--..}, at: [<78164ae6>] generic_file_llseek+0x29/0=
xa0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


> Is anything currently running? (sysrq+P

SysRq : Show Regs

Pid: 0, comm:              swapper
EIP: 0060:[<781021a6>] CPU: 0
EIP is at mwait_idle_with_hints+0x3b/0x3f
  EFLAGS: 00000246    Not tainted  (2.6.22.9 #1)
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 7855a008 EBP: 00000002 DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: 6ff2e000 CR3: 7db52000 CR4: 000006d0
  [<78102257>] mwait_idle+0x0/0xf
  [<78102391>] cpu_idle+0x99/0xc6
  [<78561907>] start_kernel+0x2dc/0x2e4
  [<7856117b>] unknown_bootoption+0x0/0x202
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> and even a full sysrq+T task list
> could be useful).

fault_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 9A8AFEC8     0 27417      1 (NOTLB)
        9a8afedc 00000086 00000002 9a8afec8 9a8afec4 00000000 00000000 0000=
0000
        00000009 00000001 81ab0070 f7fbe030 d7259500 00007d9a 00000000 81ab=
017c
        7a022980 f6e6b2c0 0836b8d5 00000003 00000000 00000000 7fffffff f718=
4000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bash          S 00000000     0  9224  27386 (NOTLB)
        bae9bedc 00000086 00000000 00000000 f531248c f7cb8130 00000000 0000=
0000
        0000000a 00000000 f7cb8130 f7c740b0 fe89f040 0001ab8a 00000000 f7cb=
823c
        7a01a980 f7cb7540 f7cb8668 f7cb8130 00000000 00000000 7fffffff f531=
2000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scache        S AEB09D0C     0 29135      1 (NOTLB)
        aeb09d20 00200092 00000002 aeb09d0c aeb09d08 00000000 00000000 f6f2=
bf54
        0000000a 00000001 a2cd4030 f7fbe030 c853d980 0001f475 00000000 a2cd=
413c
        7a022980 eb12ad00 20c7bfd6 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pdflush       S A30BDF9C     0  8843      2 (L-TLB)
        a30bdfb0 00000092 00000002 a30bdf9c a30bdf98 00000000 00000292 daae=
e560
        0000000a 00000000 daaee030 785143e0 abd01e80 0001f615 00000000 daae=
e13c
        7a01a980 ea38bcc0 20e3014d 00000003 00000000 00000000 a30bdfc8 7814=
e33a
Call Trace:
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e3e8>] pdflush+0xae/0x1a6
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pdflush       S F7E2AB20     0 13129      2 (L-TLB)
        b41bbfb0 00000092 7851c174 f7e2ab20 00000001 786b80f0 b41bbf60 f7e2=
b050
        0000000a 00000001 f7e2ab20 eb1bd510 8245efc0 0001f3f1 00000000 f7e2=
ac2c
        7a022980 eb12aa80 7814e33a 00000046 7851c160 7814e33a b41bbfc8 7814=
e33a
Call Trace:
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e3e8>] pdflush+0xae/0x1a6
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D0A83B4C     0 14300      1 (NOTLB)
        d0a83b60 00200096 00000002 d0a83b4c d0a83b48 00000000 7840d6e3 785c=
de80
        00000007 00000000 d5a75590 785143e0 13b0b200 0001f60f 00000000 d5a7=
569c
        7a01a980 eba4fd40 20e292aa 00000003 00000000 00000000 d0a83b70 20e7=
2688
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7812cada>] process_timeout+0x0/0x5
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<78120686>] run_rebalance_domains+0x74/0x3ae
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783a3bd7>] tcp_recvmsg+0x63f/0x74b
  [<7840d1f4>] _spin_lock_bh+0x38/0x43
  [<783a3bd7>] tcp_recvmsg+0x63f/0x74b
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816f30a>] sys_select+0xa0/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 00000000     0 14884   2790 (NOTLB)
        a5367e44 00000086 00000000 00000000 7813e7a9 00000000 00000000 f333=
3940
        0000000a 00000001 c670eae0 ac2a7510 f3d5ec00 0001f3f9 000f4240 c670=
ebec
        7a022980 f457a300 c670f010 c670eae0 781299b4 a5367ea0 7fffffff 7fff=
ffff
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 931D3B4C     0 14931   2790 (NOTLB)
        931d3b60 00000096 00000002 931d3b4c 931d3b48 00000000 00000000 0000=
0000
        0000000a 00000000 ce58e070 785143e0 f3d5ec00 0001f3f9 00000000 ce58=
e17c
        7a01a980 e3809ac0 20bfa251 00000003 00000000 00000000 7fffffff 931d=
3f9c
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<783734b9>] sk_reset_timer+0xc/0x16
  [<783aa645>] tcp_rcv_established+0x5c5/0x628
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<783b133f>] tcp_v4_rcv+0x3de/0x787
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<7839949e>] ip_local_deliver+0x1aa/0x1c8
  [<78398c10>] ip_local_deliver_finish+0x0/0x14c
  [<783992bb>] ip_rcv+0x498/0x4d1
  [<7839896c>] ip_rcv_finish+0x0/0x2a4
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c73c>] process_backlog+0xef/0xfa
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c9d8>] net_rx_action+0x162/0x18f
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781298c7>] local_bh_enable+0x110/0x130
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7839dedc>] ip_output+0x270/0x2ac
  [<7839c7d5>] ip_finish_output+0x0/0x212
  [<7839d5e6>] ip_queue_xmit+0x316/0x35b
  [<7839b270>] dst_output+0x0/0x7
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<7816f340>] sys_select+0xd6/0x188
  [<78103e68>] restore_nocheck+0x12/0x15
  [<7811955b>] do_page_fault+0x0/0x535
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       D 00000000     0 15049   2790 (NOTLB)
        f5de5e2c 00000082 00000000 00000000 7813e7a9 e9568030 7840d6e3 785c=
de80
        00000009 00000000 e9568030 f7ca0070 6e5cce80 0001f616 00000000 e956=
813c
        7a01a980 826e4580 785cde80 7812ccc1 00000000 00000292 f5de5e3c 20e3=
0e6e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78152ded>] do_wp_page+0x3c4/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<78138305>] down_read_trylock+0x47/0x4e
  [<7811976d>] do_page_fault+0x212/0x535
  [<7811955b>] do_page_fault+0x0/0x535
  [<7840d96a>] error_code+0x72/0x78
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       D 00000000     0 15169   2790 (NOTLB)
        c217de2c 00000082 00000000 00000000 7813e7a9 bf1fcb20 7840d6e3 785c=
de80
        00000009 00000000 bf1fcb20 daaeea60 6e5cce80 0001f616 00000000 bf1f=
cc2c
        7a01a980 e9a420c0 785cde80 7812ccc1 00000000 00000292 c217de3c 20e3=
0e6e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78152ded>] do_wp_page+0x3c4/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<78138305>] down_read_trylock+0x47/0x4e
  [<7811976d>] do_page_fault+0x212/0x535
  [<7811955b>] do_page_fault+0x0/0x535
  [<7840d96a>] error_code+0x72/0x78
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S 00000122     0 15322   3559 (NOTLB)
        e7b47dd8 00000082 00000000 00000122 00000000 00000000 00000000 ec92=
5cac
        0000000a 00000001 c05340f0 eb1bd510 31a413c0 0001f3d9 00000000 c053=
41fc
        7a022980 b0c607c0 c0534620 c05340f0 00000000 c05340f0 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S F660FDC4     0 15323   3559 (NOTLB)
        f660fdd8 00000082 00000002 f660fdc4 f660fdc0 00000000 00000000 cbcc=
89ac
        00000007 00000000 f7ca14d0 785143e0 c9f296c0 0001efd2 00000000 f7ca=
15dc
        7a01a980 b0c602c0 2079f567 00000003 00000000 00000000 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78165177>] __fput+0x10a/0x134
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S 00000122     0 15324   3559 (NOTLB)
        ea80fdd8 00000082 00000000 00000122 00000000 00000000 00000000 a2fe=
36ac
        00000006 00000001 f7f46b60 f7ca14d0 b8d75100 0001efd2 00000000 f7f4=
6c6c
        7a022980 ea38b540 f7f47090 f7f46b60 00000000 f7f46b60 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78165177>] __fput+0x10a/0x134
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
unlinkd       S CBEF3E44     0 15325   3559 (NOTLB)
        cbef3e58 00000086 00000002 cbef3e44 cbef3e40 00000000 e13d8c3c e769=
ea60
        00000007 00000000 e769ea60 785143e0 7fd85180 0001f3f9 000f4240 e769=
eb6c
        7a01a980 e3809d40 20bf9ab8 00000003 00000000 00000000 db5f7600 e13d=
8b78
Call Trace:
  [<7816943d>] pipe_wait+0x53/0x73
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78169b7d>] pipe_read+0x2af/0x321
  [<78174b7c>] file_update_time+0x22/0x6a
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<78164176>] do_sync_read+0x0/0x10a
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A1053D0C     0 15570      1 (NOTLB)
        a1053d20 00200092 00000002 a1053d0c a1053d08 00000000 00000000 f6f2=
bf54
        0000000a 00000001 c670e0b0 f7fbe030 3a020200 0001f403 000f4240 c670=
e1bc
        7a022980 b0c60540 20c03deb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A199DD0C     0 15949      1 (NOTLB)
        a199dd20 00200092 00000002 a199dd0c a199dd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 81ab14d0 785143e0 f85451c0 0001f405 00000000 81ab=
15dc
        7a01a980 db566cc0 20c06bf2 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 86493D0C     0 16128      1 (NOTLB)
        86493d20 00200092 00000002 86493d0c 86493d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 e769f490 785143e0 636dde40 0001f401 00000000 e769=
f59c
        7a01a980 f6b9f300 20c01f12 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 00000000     0 16169   2790 (NOTLB)
        ae5bfe44 00000086 00000000 00000000 7813e7a9 00000000 00000000 f333=
3940
        0000000a 00000000 e769e030 f7ca0070 b5ba4380 0001f3f9 00000000 e769=
e13c
        7a01a980 f6c8f340 e769e560 e769e030 781299b4 fffffe00 7fffffff 7fff=
ffff
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A984DD0C     0 16395      1 (NOTLB)
        a984dd20 00200092 00000002 a984dd0c a984dd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 c0535550 785143e0 a06b9a00 0001f409 00000000 c053=
565c
        7a01a980 eba4f5c0 20c0a94a 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
lmtp          S 9FEDBD0C     0 16454      1 (NOTLB)
        9fedbd20 00200092 00000002 9fedbd0c 9fedbd08 00000000 00000000 f6f2=
bf54
        00000003 00000001 7a1dc030 f7fbe030 ce9997c0 0001f43f 00000000 7a1d=
c13c
        7a022980 f457a080 20c43648 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sadc          D 00000000     0 16498      1 (NOTLB)
        9bb11cc4 00000082 00000000 00000000 7813e7a9 e9d8d4d0 7840d6e3 785c=
de80
        00000007 00000000 e9d8d4d0 f7f47590 6e5cce80 0001f616 00000000 e9d8=
d5dc
        7a01a980 f71d5300 785cde80 7812ccc1 00000000 00000296 9bb11cd4 20e3=
0e6e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<7814cb18>] free_hot_cold_page+0x13b/0x167
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
lmtp          S DAAEF490     0 16638      1 (NOTLB)
        a92dfd20 00200092 00000002 daaef490 daaefa10 00000000 00000000 f6f2=
bf54
        00000007 00000001 daaef490 86709550 a41a1380 0001f43f 00000000 daae=
f59c
        7a022980 eb12a800 daaef9c0 daaef490 00000000 daaef490 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A4427D0C     0 16714      1 (NOTLB)
        a4427d20 00200092 00000002 a4427d0c a4427d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9a946b20 785143e0 49bed3c0 0001f404 00000000 9a94=
6c2c
        7a01a980 b0c60a40 20c04fba 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S DABA3D0C     0 16716      1 (NOTLB)
        daba3d20 00200092 00000002 daba3d0c daba3d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 d5a74130 785143e0 0aeb9080 0001f403 00000000 d5a7=
423c
        7a01a980 f6c8fac0 20c03ad5 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 7813E99C     0 16720      1 (NOTLB)
        e2ebbd20 00200092 00000000 7813e99c 00200046 00000000 00000000 f6f2=
bf54
        00000007 00000001 ec8e34d0 f7cb0b20 05d792c0 0001f3fd 00000000 ec8e=
35dc
        7a022980 e9c8cd00 ec8e3a00 ec8e34d0 00000000 ec8e34d0 7fffffff 7fff=
ffff
Call Trace:
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 841A3D0C     0 16754      1 (NOTLB)
        841a3d20 00200092 00000002 841a3d0c 841a3d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 f7d09490 785143e0 5c6753c0 0001f405 00000000 f7d0=
959c
        7a01a980 9169aa80 20c061ba 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 99069D0C     0 16755      1 (NOTLB)
        99069d20 00200092 00000002 99069d0c 99069d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9a9460f0 785143e0 5a34bf80 0001f409 00000000 9a94=
61fc
        7a01a980 826e4300 20c0a4b2 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C6AF7D0C     0 16756      1 (NOTLB)
        c6af7d20 00200092 00000002 c6af7d0c c6af7d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 a2cd5490 785143e0 3d1cf640 0001f406 00000000 a2cd=
559c
        7a01a980 826e4800 20c07072 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S BF57BD0C     0 16757      1 (NOTLB)
        bf57bd20 00200092 00000002 bf57bd0c bf57bd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 ecbbc0b0 785143e0 d3205700 0001f400 00000000 ecbb=
c1bc
        7a01a980 826e4080 20c015a0 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35 [<783cc80c>] unix_dgram_se=
ndmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9B7E9D0C     0 16758      1 (NOTLB)
        9b7e9d20 00200092 00000002 9b7e9d0c 9b7e9d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 f7fb4130 785143e0 8e156240 0001f414 00000000 f7fb=
423c
        7a01a980 e9c8ca80 20c160a3 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9766BD0C     0 16759      1 (NOTLB)
        9766bd20 00200092 00000002 9766bd0c 9766bd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 f7fb4b60 785143e0 a07adc40 0001f409 00000000 f7fb=
4c6c
        7a01a980 eba4fac0 20c0a94a 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B31D9D0C     0 16760      1 (NOTLB)
        b31d9d20 00200092 00000002 b31d9d0c b31d9d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 bf1fc0f0 785143e0 5aaed180 0001f409 00000000 bf1f=
c1fc
        7a01a980 eb12a300 20c0a4ba 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783b2c0d>] ip4_datagram_connect+0x2ad/0x308
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 836E9D0C     0 16761      1 (NOTLB)
        836e9d20 00200092 00000002 836e9d0c 836e9d08 00000000 00000000 f6f2=
bf54
        00000003 00000000 f7e220b0 785143e0 efd80140 0001f437 00000000 f7e2=
21bc
        7a01a980 f5aa9840 20c3b241 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
cleanup       S E9507090     0 16793      1 (NOTLB)
        c546bb60 00200096 e9506b60 e9507090 7a1d2014 e9506b60 7840d6e3 7a1d=
2000
        0000000a 00000001 e9506b60 ec8e34d0 05d792c0 0001f3fd 00000000 e950=
6c6c
        7a022980 b0c60040 7a1d2000 7812ccc1 00000000 00200282 c546bb70 20f6=
c453
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7817f013>] __find_get_block+0x7c/0x158
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7817f013>] __find_get_block+0x7c/0x158
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7817ede9>] __find_get_block_slow+0x114/0x125
  [<7817ed2f>] __find_get_block_slow+0x5a/0x125
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7817f0cc>] __find_get_block+0x135/0x158
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7817f0e5>] __find_get_block+0x14e/0x158
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<783cdb0e>] unix_stream_sendmsg+0x22f/0x2f7
  [<7840d33a>] _read_lock+0x33/0x3e
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<78370f09>] sock_aio_write+0xcb/0xd7
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816f30a>] sys_select+0xa0/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
mkpir         D 00000000     0 16842   3027 (NOTLB)
        98303cc4 00000082 00000000 00000000 7813e7a9 daaeea60 7840d6e3 785c=
de80
        00000007 00000000 daaeea60 e9d8d4d0 6e5cce80 0001f616 00000000 daae=
eb6c
        7a01a980 f457ad00 785cde80 7812ccc1 00000000 00000296 98303cd4 20e3=
0e6e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781649e7>] vfs_read+0xcf/0x10a
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
fetch_mail_st D C7A0FF14     0 16843   3500 (NOTLB)
        c7a0ff28 00200086 00000002 c7a0ff14 c7a0ff10 00000000 00000000 9185=
284c
        00000008 00000001 f1c9d4d0 f7fbe030 f9ec5080 0001f3fd 004c4b40 f1c9=
d5dc
        7a022980 f457aa80 20bfe5cc 00000003 00000000 00000000 c7a0ff40 9185=
2814
Call Trace:
  [<7840bf07>] __mutex_lock_slowpath+0x14d/0x267
  [<78164ae6>] generic_file_llseek+0x29/0xa0
  [<78164ae6>] generic_file_llseek+0x29/0xa0
  [<78164abd>] generic_file_llseek+0x0/0xa0
  [<78163e17>] vfs_llseek+0x36/0x3a
  [<78164d25>] sys_llseek+0x43/0x85
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 7FC8BD0C     0 16844      1 (NOTLB)
        7fc8bd20 00200012 00000002 7fc8bd0c 7fc8bd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 f7cc0030 785143e0 e674adc0 0001f409 00000000 f7cc=
013c
        7a01a980 b0c60cc0 20c0ade1 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 00000080     0 16845      1 (NOTLB)
        d95d9d20 00200092 00000001 00000080 7a0233e0 00000002 00000000 f6f2=
bf54
        00000009 00000001 f7cd9550 f7cb0b20 17271c00 0001f40a 000f4240 f7cd=
965c
        7a022980 f6b9f800 20c0b10f 00000003 00000000 00000080 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S F601BD0C     0 16846      1 (NOTLB)
        f601bd20 00200092 00000002 f601bd0c f601bd08 00000000 00000000 f6f2=
bf54
        00000009 00000000 f7cc94d0 785143e0 17fcbb80 0001f40a 000f4240 f7cc=
95dc
        7a01a980 f6e7e300 20c0b11e 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9E3A7D0C     0 16847      1 (NOTLB)
        9e3a7d20 00200092 00000002 9e3a7d0c 9e3a7d08 00000000 00000000 f6f2=
bf54
        00000009 00000001 f7cd8b20 f7fbe030 18c318c0 0001f40a 00000000 f7cd=
8c2c
        7a022980 e38090c0 20c0b12b 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 95655D0C     0 16848      1 (NOTLB)
        95655d20 00200092 00000002 95655d0c 95655d08 00000000 00000000 f6f2=
bf54
        00000009 00000001 ac2a60b0 f7fbe030 19a7fa80 0001f40a 00000000 ac2a=
61bc
        7a022980 f6c8f0c0 20c0b13a 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C5229D0C     0 16849      1 (NOTLB)
        c5229d20 00200092 00000002 c5229d0c c5229d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 e9fc3510 785143e0 1a7d9a00 0001f40a 00000000 e9fc=
361c
        7a01a980 f6e7e800 20c0b149 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 840DFD0C     0 16850      1 (NOTLB)
        840dfd20 00200092 00000002 840dfd0c 840dfd08 00000000 00000000 f6f2=
bf54
        00000008 00000001 e9d8caa0 f7fbe030 1b533980 0001f40a 00000000 e9d8=
cbac
        7a022980 f5aa9d40 20c0b157 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C3D33D0C     0 16851      1 (NOTLB)
        c3d33d20 00200092 00000002 c3d33d0c c3d33d08 00000000 00000000 f6f2=
bf54
        00000008 00000001 ac2a6ae0 f7fbe030 1c381b40 0001f40a 00000000 ac2a=
6bec
        7a022980 f6c8fd40 20c0b165 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D3603D0C     0 16852      1 (NOTLB)
        d3603d20 00200092 00000002 d3603d0c d3603d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 a2cd4a60 785143e0 1d0dbac0 0001f40a 000f4240 a2cd=
4b6c
        7a01a980 dc7ae5c0 20c0b174 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S BEFAFD0C     0 16853      1 (NOTLB)
        befafd20 00200092 00000002 befafd0c befafd08 00000000 00000000 f6f2=
bf54
        00000008 00000001 d129f510 f7fbe030 1de35a40 0001f40a 000f4240 d129=
f61c
        7a022980 dc7aed40 20c0b181 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B1745D0C     0 16854      1 (NOTLB)
        b1745d20 00200092 00000002 b1745d0c b1745d08 00000000 00000000 f6f2=
bf54
        00000008 00000001 f1c9c070 f7fbe030 1ef602c0 0001f40a 00000000 f1c9=
c17c
        7a022980 f6c8f5c0 20c0b193 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C1985D0C     0 16855      1 (NOTLB)
        c1985d20 00200092 00000002 c1985d0c c1985d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 d129eae0 785143e0 1f9ddb80 0001f40a 00000000 d129=
ebec
        7a01a980 f650aa40 20c0b19f 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 84C57D0C     0 16856      1 (NOTLB)
        84c57d20 00200092 00000002 84c57d0c 84c57d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 f1c9caa0 785143e0 20737b00 0001f40a 00000000 f1c9=
cbac
        7a01a980 dc7ae0c0 20c0b1af 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B3A63D0C     0 16857      1 (NOTLB)
        b3a63d20 00200092 00000002 b3a63d0c b3a63d08 00000000 00000000 f6f2=
bf54
        00000007 00000000 ca81b490 785143e0 21491a80 0001f40a 00000000 ca81=
b59c
        7a01a980 dc7ae340 20c0b1bb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9E141D0C     0 16858      1 (NOTLB)
        9e141d20 00200092 00000002 9e141d0c 9e141d08 00000000 00000000 f6f2=
bf54
        00000007 00000000 f7cd0ae0 785143e0 221eba00 0001f40a 00000000 f7cd=
0bec
        7a01a980 e9a42ac0 20c0b1cb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A887BD0C     0 16859      1 (NOTLB)
        a887bd20 00200092 00000002 a887bd0c a887bd08 00000000 00000000 f6f2=
bf54
        00000007 00000001 ce58eaa0 f7fbe030 22f45980 0001f40a 00000000 ce58=
ebac
        7a022980 e9a425c0 20c0b1d7 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D1A11D0C     0 16860      1 (NOTLB)
        d1a11d20 00200092 00000002 d1a11d0c d1a11d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 f7cb1550 785143e0 23c9f900 0001f40a 00000000 f7cb=
165c
        7a01a980 f457a800 20c0b1e6 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 00000080     0 16861      1 (NOTLB)
        9083fd20 00200092 00000001 00000080 7a0233e0 00000002 00000000 f6f2=
bf54
        00000008 00000001 d129e0b0 f7cb0b20 249f9880 0001f40a 00000000 d129=
e1bc
        7a022980 dc7ae840 20c0b1f2 00000003 00000000 00000080 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 00000080     0 16862      1 (NOTLB)
        c5043d20 00200092 00000001 00000080 7a01b3e0 00000002 00000000 f6f2=
bf54
        00000008 00000000 ec8e2070 f7cb0b20 25847a40 0001f40a 000f4240 ec8e=
217c
        7a01a980 f457a580 20c0b201 00000003 00000000 00000080 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C8C75D0C     0 16863      1 (NOTLB)
        c8c75d20 00200092 00000002 c8c75d0c c8c75d08 00000000 00000000 f6f2=
bf54
        00000007 00000001 dc459550 f7fbe030 265a19c0 0001f40a 00000000 dc45=
965c
        7a022980 cce05d40 20c0b210 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B0931D0C     0 16864      1 (NOTLB)
        b0931d20 00200092 00000002 b0931d0c b0931d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 a13b3590 785143e0 273efb80 0001f40a 00000000 a13b=
369c
        7a01a980 f67c9040 20c0b221 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 89769D0C     0 16865      1 (NOTLB)
        89769d20 00200092 00000002 89769d0c 89769d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 a13b2130 785143e0 c7b523c0 0001f40d 00000000 a13b=
223c
        7a01a980 f6e6bcc0 20c0eefb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 991F7D0C     0 16866      1 (NOTLB)
        991f7d20 00200092 00000002 991f7d0c 991f7d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 a13b2b60 785143e0 c48cec40 0001f40e 00000000 a13b=
2c6c
        7a01a980 cce050c0 20c0ff8b 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8F65BD0C     0 16867      1 (NOTLB)
        8f65bd20 00200092 00000002 8f65bd0c 8f65bd08 00000000 00000000 f6f2=
bf54
        00000009 00000000 dc458b20 785143e0 b817d600 0001f40e 000f4240 dc45=
8c2c
        7a01a980 cce05340 20c0febb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78154205>] __handle_mm_fault+0x809/0x83b
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B6DF7D0C     0 16868      1 (NOTLB)
        b6df7d20 00200092 00000002 b6df7d0c b6df7d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 dc4580f0 785143e0 6614bd80 0001f410 00000000 dc45=
81fc
        7a01a980 cce05ac0 20c11ae8 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A15E7D0C     0 16869      1 (NOTLB)
        a15e7d20 00200092 00000002 a15e7d0c a15e7d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9a4e3490 785143e0 29398440 0001f410 00000000 9a4e=
359c
        7a01a980 cce05840 20c116ec 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D4F43D0C     0 16870      1 (NOTLB)
        d4f43d20 00200092 00000002 d4f43d0c d4f43d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 9a4e2a60 785143e0 2891ab80 0001f410 00000000 9a4e=
2b6c
        7a01a980 f6e6ba40 20c116e0 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 846F5D0C     0 16871      1 (NOTLB)
        846f5d20 00200092 00000002 846f5d0c 846f5d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 df6e20f0 785143e0 15eaaac0 0001f412 00000000 df6e=
21fc
        7a01a980 9169a080 20c13735 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 88395D0C     0 16872      1 (NOTLB)
        88395d20 00200092 00000002 88395d0c 88395d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 c670f510 785143e0 f2466900 0001f412 000f4240 c670=
f61c
        7a01a980 826e4d00 20c145a7 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S CD089D0C     0 16873      1 (NOTLB)
        cd089d20 00200092 00000002 cd089d0c cd089d08 00000000 00000000 f6f2=
bf54
        00000007 00000000 9a947550 785143e0 d9d6ce40 0001f413 00000000 9a94=
765c
        7a01a980 e3809340 20c154d5 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 98913D0C     0 16874      1 (NOTLB)
        98913d20 00200092 00000002 98913d0c 98913d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 9a4e2030 785143e0 9c44f9c0 0001f414 00000000 9a4e=
213c
        7a01a980 e38095c0 20c16193 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C3685D0C     0 16875      1 (NOTLB)
        c3685d20 00200092 00000002 c3685d0c c3685d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 f5de34d0 785143e0 a6b44300 0001f416 00000000 f5de=
35dc
        7a01a980 a7484cc0 20c183ce 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B14A5D0C     0 16876      1 (NOTLB)
        b14a5d20 00200092 00000002 b14a5d0c b14a5d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 f5de2aa0 785143e0 08466680 0001f416 00000000 f5de=
2bac
        7a01a980 db566540 20c1796d 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A20E9D0C     0 16877      1 (NOTLB)
        a20e9d20 00200092 00000002 a20e9d0c a20e9d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 f5de2070 785143e0 5bc7f6c0 0001f416 00000000 f5de=
217c
        7a01a980 db566a40 20c17ee6 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8C27FD0C     0 16878      1 (NOTLB)
        8c27fd20 00200092 00000002 8c27fd0c 8c27fd08 00000000 00000000 f6f2=
bf54
        00000002 00000000 c978b510 785143e0 3832f740 0001f417 00000000 c978=
b61c
        7a01a980 db566040 20c18d56 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A2C15D0C     0 16879      1 (NOTLB)
        a2c15d20 00200092 00000002 a2c15d0c a2c15d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 c978aae0 785143e0 1e275fc0 0001f418 00000000 c978=
abec
        7a01a980 db5662c0 20c19c6b 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C70F5D0C     0 16880      1 (NOTLB)
        c70f5d20 00200092 00000002 c70f5d0c c70f5d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 c978a0b0 785143e0 2e5dc3c0 0001f418 00000000 c978=
a1bc
        7a01a980 e3809840 20c19d7b 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 99BE1D0C     0 16881      1 (NOTLB)
        99be1d20 00200092 00000002 99be1d0c 99be1d08 00000000 00000000 f6f2=
bf54
        00000008 00000000 dbd9d550 785143e0 3cbb2200 0001f418 00000000 dbd9=
d65c
        7a01a980 f7cb7040 20c19e6a 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S DBD9D058     0 16882      1 (NOTLB)
        90b79d20 00200092 00000000 dbd9d058 7813f8ca 00000000 00000000 f6f2=
bf54
        00000009 00000000 dbd9cb20 c4d33590 75d50d80 0001f418 00000000 dbd9=
cc2c
        7a01a980 f67c9a40 dbd9d050 dbd9cb20 00000000 dbd9cb20 7fffffff 7fff=
ffff
Call Trace:
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E7CFBD0C     0 16883      1 (NOTLB)
        e7cfbd20 00200092 00000002 e7cfbd0c e7cfbd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 c4d33590 785143e0 897131c0 0001f418 00000000 c4d3=
369c
        7a01a980 cce055c0 20c1a370 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B2CE9D0C     0 16884      1 (NOTLB)
        b2ce9d20 00200092 00000002 b2ce9d0c b2ce9d08 00000000 00000000 f6f2=
bf54
        00000002 00000000 c4d32130 785143e0 c8ec4dc0 0001f419 00000000 c4d3=
223c
        7a01a980 e9fb9d00 20c1b860 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 7FE3FD0C     0 16885      1 (NOTLB)
        7fe3fd20 00200012 00000002 7fe3fd0c 7fe3fd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 c4d32b60 785143e0 2a04df00 0001f41a 00000000 c4d3=
2c6c
        7a01a980 f7cb77c0 20c1bebd 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S CA9E7D0C     0 16886      1 (NOTLB)
        ca9e7d20 00200092 00000002 ca9e7d0c ca9e7d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 dbd9c0f0 785143e0 82e43980 0001f41b 00000000 dbd9=
c1fc
        7a01a980 f71d5580 20c1d559 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 94943D0C     0 16887      1 (NOTLB)
        94943d20 00200092 00000002 94943d0c 94943d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 84393490 785143e0 97673e80 0001f41f 00000000 8439=
359c
        7a01a980 da41fd40 20c219cb 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8EFF7D0C     0 16888      1 (NOTLB)
        8eff7d20 00200092 00000002 8eff7d0c 8eff7d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 84392a60 785143e0 7c0bf580 0001f420 00000000 8439=
2b6c
        7a01a980 9169ad00 20c228c7 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8B12FD0C     0 16889      1 (NOTLB)
        8b12fd20 00200092 00000002 8b12fd0c 8b12fd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 84392030 785143e0 0b7719c0 0001f426 00000000 8439=
213c
        7a01a980 9169a300 20c28611 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C61A9D0C     0 16890      1 (NOTLB)
        c61a9d20 00200092 00000002 c61a9d0c c61a9d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 9963f4d0 785143e0 a4f47a80 0001f42a 00000000 9963=
f5dc
        7a01a980 da41f0c0 20c2d33d 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C0EDFD0C     0 16891      1 (NOTLB)
        c0edfd20 00200092 00000002 c0edfd0c c0edfd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9963eaa0 785143e0 d4efcdc0 0001f42a 00000000 9963=
ebac
        7a01a980 da41fac0 20c2d662 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9AEC1D0C     0 16892      1 (NOTLB)
        9aec1d20 00200092 00000002 9aec1d0c 9aec1d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 a25c7510 785143e0 3c1cc480 0001f42b 00000000 a25c=
761c
        7a01a980 a1257cc0 20c2dd23 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S DC5A3D0C     0 16893      1 (NOTLB)
        dc5a3d20 00200092 00000002 dc5a3d0c dc5a3d08 00000000 00000000 f6f2=
bf54
        00000009 00000001 a25c6ae0 f7fbe030 1cc2a500 0001f42b 000f4240 a25c=
6bec
        7a022980 a1257a40 20c2db17 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D8409D0C     0 16894      1 (NOTLB)
        d8409d20 00200092 00000002 d8409d0c d8409d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9963e070 785143e0 894ce640 0001f42b 00000000 9963=
e17c
        7a01a980 da41f840 20c2e233 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E2FEBD0C     0 16895      1 (NOTLB)
        e2febd20 00200092 00000002 e2febd0c e2febd08 00000000 00000000 f6f2=
bf54
        00000009 00000000 87dc9550 785143e0 b77e7600 0001f42b 000f4240 87dc=
965c
        7a01a980 da41f5c0 20c2e53b 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D6923D0C     0 16896      1 (NOTLB)
        d6923d20 00200092 00000002 d6923d0c d6923d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 87dc8b20 785143e0 8792e4c0 0001f42c 00000000 87dc=
8c2c
        7a01a980 da41f340 20c2f2df 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C6CC1D0C     0 16897      1 (NOTLB)
        c6cc1d20 00200092 00000002 c6cc1d0c c6cc1d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 87dc80f0 785143e0 3f38b840 0001f430 00000000 87dc=
81fc
        7a01a980 a1257540 20c3313a 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S B98C7D0C     0 16898      1 (NOTLB)
        b98c7d20 00200092 00000002 b98c7d0c b98c7d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 a25c60b0 785143e0 3f75c140 0001f430 00000000 a25c=
61bc
        7a01a980 a12572c0 20c3313e 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D2203D0C     0 16899      1 (NOTLB)
        d2203d20 00200092 00000002 d2203d0c d2203d08 00000000 00000000 f6f2=
bf54
        00000007 00000000 9a747590 785143e0 07413740 0001f431 00000000 9a74=
769c
        7a01a980 a12577c0 20c33e56 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 80687D0C     0 16900      1 (NOTLB)
        80687d20 00200092 00000002 80687d0c 80687d08 00000000 00000000 f6f2=
bf54
        00000006 00000000 9a746b60 785143e0 414f46c0 0001f431 000f4240 9a74=
6c6c
        7a01a980 e9fb9a80 20c34226 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C473DD0C     0 16901      1 (NOTLB)
        c473dd20 00200092 00000002 c473dd0c c473dd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 9a746130 785143e0 c935d080 0001f432 00000000 9a74=
623c
        7a01a980 e9fb9800 20c35bd4 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S DA57DD0C     0 16902      1 (NOTLB)
        da57dd20 00200092 00000002 da57dd0c da57dd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 cd433490 785143e0 62942d00 0001f436 00000000 cd43=
359c
        7a01a980 c01f2d00 20c39835 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 83283D0C     0 16903      1 (NOTLB)
        83283d20 00200092 00000002 83283d0c 83283d08 00000000 00000000 f6f2=
bf54
        00000009 00000001 cd432030 f7fbe030 48a799c0 0001f438 00000000 cd43=
213c
        7a022980 e9fb9300 20c3b810 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E3FE1D0C     0 16904      1 (NOTLB)
        e3fe1d20 00200092 00000002 e3fe1d0c e3fe1d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 ce74d4d0 785143e0 49126980 0001f438 00000000 ce74=
d5dc
        7a01a980 9cfd0d40 20c3b817 00000001 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8F511D0C     0 16905      1 (NOTLB)
        8f511d20 00200092 00000002 8f511d0c 8f511d08 00000000 00000000 f6f2=
bf54
        00000009 00000001 ce74caa0 f7fbe030 49f74b40 0001f438 00000000 ce74=
cbac
        7a022980 a74847c0 20c3b827 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S F26E9D0C     0 16906      1 (NOTLB)
        f26e9d20 00200092 00000002 f26e9d0c f26e9d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 cd432a60 785143e0 4adc2d00 0001f438 00000000 cd43=
2b6c
        7a01a980 9cfd0ac0 20c3b838 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8A7EBD0C     0 16907      1 (NOTLB)
        8a7ebd20 00200092 00000002 8a7ebd0c 8a7ebd08 00000000 00000000 f6f2=
bf54
        00000007 00000001 ce74c070 f7fbe030 a1d4bec0 0001f43c 00000000 ce74=
c17c
        7a022980 e9fb9580 20c40104 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 912A9D0C     0 16908      1 (NOTLB)
        912a9d20 00200092 00000002 912a9d0c 912a9d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 89695510 785143e0 82018cc0 0001f43e 00000000 8969=
561c
        7a01a980 9cfd0840 20c4207d 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A1B39D0C     0 16909      1 (NOTLB)
        a1b39d20 00200092 00000002 a1b39d0c a1b39d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 89694ae0 785143e0 a8272cc0 0001f43e 00000000 8969=
4bec
        7a01a980 9cfd00c0 20c422fd 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 9A793D0C     0 16910      1 (NOTLB)
        9a793d20 00200092 00000002 9a793d0c 9a793d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 896940b0 785143e0 15c41680 0001f43f 00000000 8969=
41bc
        7a01a980 a063ccc0 20c42a2c 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E2A39D0C     0 16912      1 (NOTLB)
        e2a39d20 00200092 00000002 e2a39d0c e2a39d08 00000000 00000000 f6f2=
bf54
        00000002 00000000 867080f0 785143e0 acfca240 0001f441 00000000 8670=
81fc
        7a01a980 9cfd0340 20c455a3 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E278FD0C     0 16913      1 (NOTLB)
        e278fd20 00200092 00000002 e278fd0c e278fd08 00000000 00000000 f6f2=
bf54
        00000004 00000000 86708b20 785143e0 badfee80 0001f441 00000000 8670=
8c2c
        7a01a980 a063c540 20c4568c 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8B41DD0C     0 16914      1 (NOTLB)
        8b41dd20 00200092 00000002 8b41dd0c 8b41dd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 bf519590 785143e0 e2edd680 0001f441 000f4240 bf51=
969c
        7a01a980 a063c7c0 20c4592c 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S BCB57D0C     0 16915      1 (NOTLB)
        bcb57d20 00200092 00000002 bcb57d0c bcb57d08 00000000 00000000 f6f2=
bf54
        00000002 00000000 bf518130 785143e0 cda772c0 0001f443 00000000 bf51=
823c
        7a01a980 e33f5d00 20c47955 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S CD79FD0C     0 16916      1 (NOTLB)
        cd79fd20 00200092 00000002 cd79fd0c cd79fd08 00000000 00000000 f6f2=
bf54
        00000006 00000000 bf518b60 785143e0 3c388080 0001f444 00000000 bf51=
8c6c
        7a01a980 a7484a40 20c48096 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S ED8E7D0C     0 16917      1 (NOTLB)
        ed8e7d20 00200092 00000002 ed8e7d0c ed8e7d08 00000000 00000000 f6f2=
bf54
        00000007 00000000 b4993490 785143e0 46790380 0001f444 00000000 b499=
359c
        7a01a980 a7484540 20c48142 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S A9E2FD0C     0 16918      1 (NOTLB)
        a9e2fd20 00200092 00000002 a9e2fd0c a9e2fd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 b4992030 785143e0 d8724980 0001f445 000f4240 b499=
213c
        7a01a980 a74842c0 20c49b96 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S C3213D0C     0 16919      1 (NOTLB)
        c3213d20 00200092 00000002 c3213d0c c3213d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 b4992a60 785143e0 c9414ac0 0001f449 00000000 b499=
2b6c
        7a01a980 e6fbdd40 20c4ddb7 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S F29BDD0C     0 16920      1 (NOTLB)
        f29bdd20 00200092 00000002 f29bdd0c f29bdd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 88d9f4d0 785143e0 d1e650c0 0001f44a 00000000 88d9=
f5dc
        7a01a980 a063c2c0 20c4ef0c 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 857EBD0C     0 16921      1 (NOTLB)
        857ebd20 00200092 00000002 857ebd0c 857ebd08 00000000 00000000 f6f2=
bf54
        00000008 00000000 afcaf510 785143e0 e8405c80 0001f44a 00000000 afca=
f61c
        7a01a980 e6fbdac0 20c4f085 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S E1483D0C     0 16922      1 (NOTLB)
        e1483d20 00200092 00000002 e1483d0c e1483d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 afcaeae0 785143e0 3c978c40 0001f44b 00000000 afca=
ebec
        7a01a980 a7484040 20c4f60d 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S AAABBD0C     0 16923      1 (NOTLB)
        aaabbd20 00200092 00000002 aaabbd0c aaabbd08 00000000 00000000 f6f2=
bf54
        00000008 00000000 afcae0b0 785143e0 5127d480 0001f44b 00000000 afca=
e1bc
        7a01a980 a063ca40 20c4f764 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 8C039D0C     0 16924      1 (NOTLB)
        8c039d20 00200092 00000002 8c039d0c 8c039d08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 8a4ab550 785143e0 8479a5c0 0001f44b 00000000 8a4a=
b65c
        7a01a980 a063c040 20c4fac1 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S CB7EBD0C     0 16925      1 (NOTLB)
        cb7ebd20 00200092 00000002 cb7ebd0c cb7ebd08 00000000 00000000 f6f2=
bf54
        0000000a 00000000 8a4aab20 785143e0 3df6ffc0 0001f44c 00000000 8a4a=
ac2c
        7a01a980 88ea2cc0 20c506e8 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D105FD0C     0 16926      1 (NOTLB)
        d105fd20 00200092 00000002 d105fd0c d105fd08 00000000 00000000 f6f2=
bf54
        00000009 00000001 8a4aa0f0 f7fbe030 15da5540 0001f44d 00000000 8a4a=
a1fc
        7a022980 e33f5a80 20c5150f 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S D59B9D0C     0 16927      1 (NOTLB)
        d59b9d20 00200092 00000002 d59b9d0c d59b9d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 88d9eaa0 785143e0 a145a380 0001f44f 00000000 88d9=
ebac
        7a01a980 88ea2040 20c53fc0 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smtpd         S 93F03D0C     0 16928      1 (NOTLB)
        93f03d20 00200092 00000002 93f03d0c 93f03d08 00000000 00000000 f6f2=
bf54
        00000009 00000000 88d9e070 785143e0 a22a8540 0001f44f 00000000 88d9=
e17c
        7a01a980 e33f5300 20c53fcf 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



Best regards,

 =09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-732856416-1191960506=:29165--
