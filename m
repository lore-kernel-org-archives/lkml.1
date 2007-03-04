Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXCDREQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXCDREQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXCDREQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:04:16 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2234 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXCDREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:04:09 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc2-mm1
Date: Sun, 4 Mar 2007 18:06:01 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070304033445.cff1148f.akpm@linux-foundation.org> <200703041301.09121.m.kozlowski@tuxland.pl>
In-Reply-To: <200703041301.09121.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5xv6FG5Xb4jc7P+"
Message-Id: <200703041806.01621.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5xv6FG5Xb4jc7P+
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> I'll dig some more and try to catch some data.

Ok. I started the system and it froze after approx. 5 min. of uptime.

Scenario:

- I logged into kde
- started aterm
- insmod netconsole ... blah blah
- started azureus (downloading 1 torrent)
- started firefox (pandora.com -> flash playing music)
- started aterm
- started kmail

-> fool around a bit and ... whoops -> system is frozen

Symptoms:
- I left the computer running frozen for 5~10 minutes just in case it suddenly 'regain consciousness'
- num lock, caps lock do not make the leds on/off (looks like dead keyboard)
- unable to switch to console
- I issued sysrq-p, sysrq-t, the computer still looks dead but surprise! netconsole worked and I managed
  to capture some data, no oops though
- sysrq-s does not work -> only "SysRq : Emergency Sync" gets printed ("Emergency Sync complete" does
  not appear)
- hard drive I/O is dead (led not blinking when sysrq-s or whatever)
- computer is totaly unresponsive and issuing sysrq looks like playing with dead computer
- the only thing to at this stage is is hard reset

Almost each time the frozen system looks a bit different. So not sure where to look exactly. Sometimes
the keyboard 'works' and I can switch to console, sometimes the box looks totally dead, sometimes it
loops some short fragment of music and makes weird sounds, sometimes azureus still works (wifi traffic led
is blinking), sometimes CPU is eaten up, sometimes not. The common denominator could be no hard drive I/O
activity.

I read Michal P. report and it might be that we hit the same bug here.

Below you'll find the output and current config attached.

--------

Loglevel set to 7
SysRq : Show Regs

Pid: 12322, comm:          firefox-bin
EIP: 0073:[<afaae772>] CPU: 0
EIP is at 0xafaae772
 ESP: 007b:ab1b9190 EFLAGS: 00200202    Not tainted  (2.6.21-rc2-mm1 #5)
EAX: 00000001 EBX: afb7a12c ECX: 00000001 EDX: 00000001
ESI: 08b832e4 EDI: 00000001 EBP: ab1b91c8 DS: 007b ES: 007b FS: 0000
CR0: 8005003b CR2: 094f8000 CR3: 0aee9000 CR4: 000006d0
 [<c01045c4>] show_trace_log_lvl+0x1a/0x30
 [<c0104d60>] show_trace+0x12/0x14
 [<c01029cc>] show_regs+0x182/0x189
 [<c029d658>] sysrq_handle_showregs+0x12/0x14
 [<c029d54c>] __handle_sysrq+0x7b/0x115
 [<c029d606>] handle_sysrq+0x20/0x24
 [<c0298290>] kbd_event+0x3a7/0x5b7
 [<c0332441>] input_event+0xc5/0x471
 [<c0336062>] atkbd_interrupt+0x1a7/0x595
 [<c032f048>] serio_interrupt+0x35/0x6f
 [<c032fe8a>] i8042_interrupt+0x10a/0x23d
 [<c0140ade>] handle_IRQ_event+0x28/0x54
 [<c0141fd7>] handle_level_irq+0x6e/0xe7
 [<c0105dba>] do_IRQ+0x3d/0x83
 [<c010413b>] common_interrupt+0x23/0x28
 =======================
SysRq : Show State

                         free                        sibling
  task             PC    stack   pid father child younger older
ksoftirqd/0   S 00000001     0     2      1             3       (L-TLB)
       ddf05fb8 00000086 00000000 00000001 c03ec444 ddf05f8c ddf05f98 0000000a
       ddf00a60 1c344f14 0000006d 000011da ddf00b5c c011abec 00000246 ddf03eec
       00000000 fffffffc ddf03eec 00000000 ddf05fc0 c011b123 ddf05fe0 c0126af5
Call Trace:
 [<c011b123>] ksoftirqd+0xf2/0x11f
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
watchdog/0    S 00000001     0     3      1             4     2 (L-TLB)
       ddf07fb4 00000082 00000000 00000001 c03ec444 c03ef2be 00000001 00000001
       ddf00030 984e795b 000000d1 0000034b ddf0012c 00001ba9 00000000 0000007d
       ddf07fc0 fffffffc ddf03ef0 00000000 ddf07fc0 c014082c 00000063 ddf07fe0
Call Trace:
 [<c014082c>] watchdog+0x45/0x79
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
khelper       S 00000001     0     5      1             6     4 (L-TLB)
       ddf0df7c 00000092 00000001 00000001 c1432bf0 c0126de7 00000046 00000009
       ddf08aa0 98f247ae 00000096 00005250 ddf08b9c c1432bf0 ddf0df7c c0126de7
       00000001 c1432bc0 c1432bf0 ddf0dfa0 ddf0dfc0 c0124805 c1432be8 ddf03ecc
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kthread       S 00000001     0     6      1    48    1046     5 (L-TLB)
       ddf0ff7c 00000092 00000001 00000001 c1432b70 c0126de7 00000046 00000004
       ddf08070 65553ef9 00000008 00000c2a ddf0816c c1432b70 ddf0ff7c c0126de7
       00000001 c1432b40 c1432b70 ddf0ffa0 ddf0ffc0 c0124805 c1432b68 ddf03ecc
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kacpid        S 00000001     0    49      6           144    48 (L-TLB)
       c14cdf7c 00000092 00000001 00000001 ddf34370 c0126de7 00000046 0000000a
       c14cb4d0 d5bdffa2 00000006 015f759e c14cb5cc ddf34370 c14cdf7c c0126de7
       00000001 ddf34340 ddf34370 c14cdfa0 c14cdfc0 c0124805 ddf34368 ddf03e90
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
ksuspend_usbd S 00000001     0   144      6           147    49 (L-TLB)
       c145bf7c 00000092 00000001 00000001 ddf415f0 c0126de7 00000046 00000001
       c146e030 2f097ffe 00000003 00000bb6 c146e12c ddf415f0 c145bf7c c0126de7
       00000001 ddf415c0 ddf415f0 c145bfa0 c145bfc0 c0124805 ddf415e8 ddf03ec0
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
khubd         S 00000001     0   147      6           149   144 (L-TLB)
       c1461f28 00000086 00000001 00000001 c0512780 c0126de7 00000046 0000000a
       c1466130 2e1fc97f 00000004 0000295f c146622c c0512780 c1461f28 c0126de7
       00000001 c1461f94 00000000 dddf4000 c1461fc0 c030aaf5 c1461faa c05630dc
Call Trace:
 [<c030aaf5>] hub_thread+0x725/0xb3a
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kseriod       S 00000001     0   149      6           160   147 (L-TLB)
       c1469f84 00000086 00000001 00000001 c0516740 c0126de7 00000046 00000004
       c1467590 647b5a28 00000004 00003573 c146768c c0516740 c1469f84 c0126de7
       00000001 c0516728 c17638c0 c17638c0 c1469fc0 c032f517 00000001 ddf01490
Call Trace:
 [<c032f517>] serio_thread+0xc3/0x32c
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
khpsbpkt      S 00000001     0   160      6           165   149 (L-TLB)
       c1483fb8 00000086 00000000 00000001 00000001 c079e62c c0381762 0000000a
       c147eae0 8eb7625b 00000003 0000078b c147ebdc c079e620 00000000 c1483fb8
       c0381762 fffffffc ddf03ef4 00000000 c1483fc0 c02f0baa c1483fe0 c0126af5
Call Trace:
 [<c02f0baa>] hpsbpkt_thread+0x92/0xa1
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
knodemgrd_0   S C04AF7F6     0   165      6           173   160 (L-TLB)
       dde25f48 00000082 c144df00 c04af7f6 c04af7fe c171a8e8 dde25f18 0000000a
       c14caaa0 8eba7384 00000003 0000807b c14cab9c c1470120 00000000 c171a900
       c144df00 00000001 00000000 c1490000 dde25fc0 c02f5fcb c04bed64 c04af804
Call Trace:
 [<c02f5fcb>] nodemgr_host_thread+0x3e2/0xb06
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
pdflush       S C1476580     0   174      6           175   173 (L-TLB)
       dde0df98 00000086 00000000 c1476580 c1476070 c04faf7c dde0df8c 0000000a
       c1476070 fb7161cb 00000064 00001f2f c147616c 00000046 c04faf60 ddf03ef8
       c04faf60 dde0dfb0 ddf03ef8 00000000 dde0dfc0 c014dcb6 c147616c c1476070
Call Trace:
 [<c014dcb6>] pdflush+0x91/0x19b
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kswapd0       S 00000001     0   175      6           176   174 (L-TLB)
       dde7bf30 00000096 00000001 00000001 c04faecc c0126de7 00000046 0000000a
       c1476aa0 b5a4f5ad 0000009d 0004fa0b c1476b9c 00026369 00000000 c0126de7
       00000001 00000001 00000000 ffffffff dde7bfc0 c0151c8a 00000000 00000000
Call Trace:
 [<c0151c8a>] kswapd+0x3ea/0x40c
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
aio/0         S 00000001     0   177      6           840   176 (L-TLB)
       dde75f7c 00000092 00000001 00000001 ddf14bf0 c0126de7 00000046 00000001
       c145eb20 35ffbaa6 00000003 00000ad3 c145ec1c ddf14bf0 dde75f7c c0126de7
       00000001 ddf14bc0 ddf14bf0 dde75fa0 dde75fc0 c0124805 ddf14be8 ddf03ec0
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kpsmoused     S 00000001     0   840      6           845   177 (L-TLB)
       c174bf7c 00000092 00000001 00000001 c16eed70 c0126de7 00000046 00000001
       c14ca070 3a42390f 00000004 00000bde c14ca16c 000006ca 00000000 c0126de7
       00000001 c16eed40 c16eed70 c174bfa0 c174bfc0 c0124805 c16eed68 ddf03ec4
Call Trace:
 [<c0124805>] worker_thread+0x100/0x155
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kedac         S C011E00D     0   845      6           865   840 (L-TLB)
       c1711f70 00000096 00000000 c011e00d 00000046 c05846c0 00000296 0000000a
       ddd19490 b33e3434 000000d1 00000609 ddd1958c c011e00d 0008f2ee 00000000
       00000296 c1711f80 0008f2ee 00000000 c1711fa0 c03ed069 c0518478 00000000
Call Trace:
 [<c03ed069>] schedule_timeout+0x44/0xa4
 [<c03ed0f5>] schedule_timeout_interruptible+0x15/0x20
 [<c033f0d4>] edac_kernel_thread+0xcf/0x10e
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
kjournald     D C13C2F2C     0   865      6          2580   845 (L-TLB)
       c1649e78 00000082 c147e0b0 c13c2f2c c1649e64 00000046 00000000 0000000a
       c147e0b0 d7346ed3 0000009e 000134eb c147e1ac 00000286 c13c2f10 c1649e74
       c03ef2be 00000000 c1649ec4 00000000 c1649e84 c03ec87e c1649ebc c1649e8c
Call Trace:
 [<c03ec87e>] io_schedule+0x42/0x59
 [<c0184915>] sleep_on_buffer+0x8/0xc
 [<c03ed217>] __wait_on_bit+0x47/0x6c
 [<c03ed297>] out_of_line_wait_on_bit+0x5b/0x64
 [<c01848a8>] __wait_on_buffer+0x27/0x2d
 [<c01b4228>] journal_commit_transaction+0x707/0x127f
 [<c01b868b>] kjournald+0xac/0x1ed
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
udevd         S DC479550     0  1046      1          7465     6 (NOTLB)
       dd321b28 00000086 dc479a60 dc479550 dd808b30 dd321b18 00000046 00000008
       dc479550 822562e9 0000006c 0006113e dc47964c 00000000 dd808af0 00000000
       dd321b3c 00000008 00000000 00000000 dd321b58 c03ed08f 00000000 dd808af0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
pccardd       S DCF1EB20     0  2580      6          2622   865 (L-TLB)
       dc03bf80 00000096 dcf1f030 dcf1eb20 dcf1ca60 dc03bf70 00000046 00000003
       dcf1eb20 5f4a3164 00000008 00001b62 dcf1ec1c dcf1ca44 00000296 dcf1ca44
       dc03bf80 dcf1c828 00000000 dcf1ca44 dc03bfc0 de86fd2b dca97cf4 00000003
Call Trace:
 [<de86fd2b>] pccardd+0x119/0x23d [pcmcia_core]
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
pccardd       S C1466B60     0  2622      6                2580 (L-TLB)
       dca3df80 00000096 c1467070 c1466b60 dcf1c260 dca3df70 00000046 0000000a
       c1466b60 b636b14d 00000069 04fb46b7 c1466c5c 017812a6 00000000 dcf1c244
       dca3df80 dcf1c028 00000000 dcf1c244 dca3dfc0 de86fd2b dca97cf4 00000004
Call Trace:
 [<de86fd2b>] pccardd+0x119/0x23d [pcmcia_core]
 [<c0126af5>] kthread+0xa2/0xc9
 [<c010422b>] kernel_thread_helper+0x7/0x1c
 =======================
acpid         S C0126E8C     0  7535      1          8087  7479 (NOTLB)
       dd11dbe8 00000082 dd1e6698 c0126e8c 00000046 dd1e6698 00000296 00000007
       ddd594d0 3be9257d 00000015 0002fd5e ddd595cc c0126e8c 00000001 00000000
       dd11dc50 00000000 dd11dea8 ffffffff dd11dc18 c03ed08f dd11dc50 dca621c0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171180>] do_sys_poll+0x33f/0x46e
 [<c01712f0>] sys_poll+0x41/0x43
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
cardmgr       S 00000000     0  8087      1          8212  7535 (NOTLB)
       dc02bb28 00000086 00000046 00000000 00000001 00000001 dcf1c294 00000009
       ddd58aa0 252fdd31 0000006d 000063a0 ddd58b9c c03ef2be dc02bc00 dcf1c294
       dc02bb2c 00000005 00000000 00000000 dc02bb58 c03ed08f c0171e6f dcf1c294
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kdm           S 00000001     0  8212      1  8215    8357  8087 (NOTLB)
       dd353b28 00000086 00000001 00000001 ddecb800 c0126e8c 00000046 0000000a
       c1676030 bffc1450 00000054 00006948 c167612c ddecb800 dd353b24 c0126e8c
       00000006 00000011 00000000 00000000 dd353b58 c03ed08f c14f9880 dd353bd0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kdm           S C1720640     0  8216   8212  8384          8215 (NOTLB)
       dcd09f1c 00000096 00000000 c1720640 c1720130 c0526a18 dcd09f10 00000007
       c1720130 9a09fe09 00000027 000095e5 c172022c 00000246 c0526a00 dc856070
       c17201d4 fffffff6 dc856070 00000001 dcd09f88 c01187e2 00000000 bf9386fc
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S DC84F9C8     0  8357      1          8358  8212 (NOTLB)
       dc543ebc 00000096 c05c957c dc84f9c8 dc84f9a0 00000001 00000140 00000007
       dc84f490 28513886 00000016 000caad8 dc84f58c 00000046 00000000 00000001
       00000001 db869380 dd61b800 00000001 dc543eec c03ed08f dd61b9dc dc543ed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S DDD18F98     0  8358      1          8359  8357 (NOTLB)
       dbcc7ebc 00000096 c05c957c ddd18f98 ddd18f70 00000001 00000140 00000007
       ddd18a60 285b691d 00000016 000a3097 ddd18b5c 00000046 00000000 00000001
       00000001 db876980 dc8ab800 00000001 dbcc7eec c03ed08f dc8ab9dc dbcc7ed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S DC478628     0  8359      1          8360  8358 (NOTLB)
       dbcc5ebc 00000096 c05c957c dc478628 dc478600 00000001 00000140 00000007
       dc4780f0 2865b6b4 00000016 000a4d97 dc4781ec 00000046 00000000 00000001
       00000001 dc6ff280 dc8ab000 00000001 dbcc5eec c03ed08f dc8ab1dc dbcc5ed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S DDDC9A88     0  8360      1          8361  8359 (NOTLB)
       dad4debc 00000096 c05c957c dddc9a88 dddc9a60 00000001 00000140 00000007
       dddc9550 28700ae6 00000016 000a5432 dddc964c 00000046 00000000 00000001
       00000001 db869a80 dced6800 00000001 dad4deec c03ed08f dced69dc dad4ded8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S C1721AC8     0  8361      1          8362  8360 (NOTLB)
       dc369ebc 00000096 c05c957c c1721ac8 c1721aa0 00000001 00000140 00000007
       c1721590 287a249b 00000016 000a19b5 c172168c 00000046 00000000 00000001
       00000001 db869980 dced6000 00000001 dc369eec c03ed08f dced61dc dc369ed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
agetty        S C1477A08     0  8362      1          8413  8361 (NOTLB)
       dad3bebc 00000096 c05c957c c1477a08 c14779e0 00000001 00000140 00000007
       c14774d0 288490cd 00000016 000a6c32 c14775cc 00000046 00000000 00000001
       00000001 db876d80 dc79a800 00000001 dad3beec c03ed08f dc79a9dc dad3bed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
startkde      S DC856580     0  8384   8216  8448               (NOTLB)
       c178df1c 00000096 00000000 dc856580 dc856070 c0526a18 c178df10 00000006
       dc856070 acbb332c 00000029 00018a9b dc85616c 00000246 c0526a00 dc84ea60
       dc856114 fffffff6 dc84ea60 00000001 c178df88 c01187e2 00000000 bfcf5708
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
dbus-launch   S C0126E8C     0  8412      1          8439  8413 (NOTLB)
       d9b2bb28 00000086 db4bc398 c0126e8c 00000046 db4bc398 00000292 00000007
       c145e0f0 afa5e1fd 0000002c 0000d4d0 c145e1ec c0126e8c 00000000 00000000
       d9b2bbd0 00000005 00000000 00000000 d9b2bb58 c03ed08f d9b2bbd0 da594dc0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
dbus-daemon   S C0126E8C     0  8413      1          8412  8362 (NOTLB)
       da0b5be8 00000082 db4bcc98 c0126e8c 00000046 db4bcc98 00000296 00000002
       c146f490 e21c66c0 00000027 0008db09 c146f58c c0126e8c 00000001 00000000
       da0b5c50 00000000 da0b5ea8 ffffffff da0b5c18 c03ed08f da0b5c50 da0191c0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171180>] do_sys_poll+0x33f/0x46e
 [<c01712f0>] sys_poll+0x41/0x43
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
start_kdeinit S 00000001     0  8435      1          8436  8443 (NOTLB)
       da021e2c 00000092 00000001 00000001 c03ed832 00000046 dc545a00 00000007
       ddd18030 6b547721 00000090 0001cbab ddd1812c 00000289 00000000 dc545a00
       da021e34 dc545a00 da021e34 00000000 da021e50 c016b469 00000000 ddd18030
Call Trace:
 [<c016b469>] pipe_wait+0x6d/0x8e
 [<c016ba3f>] pipe_read+0xc4/0x3a0
 [<c01657dd>] do_sync_read+0xe2/0x118
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kdeinit       S C0126E8C     0  8436      1  8441    8450  8435 (NOTLB)
       da0abb28 00200086 d8890c98 c0126e8c 00200046 d8890c98 00200292 00000007
       dc8574d0 6db19a1b 00000090 00016521 dc8575cc c0126e8c 00000004 00000000
       da0abbd0 0000000b 00000000 00000000 da0abb58 c03ed08f da0abbd0 d8d24ac0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
dcopserver    S C0126E8C     0  8439      1          8443  8412 (NOTLB)
       d8ee3b28 00200086 d03acc98 c0126e8c 00200046 d03acc98 00200292 00000008
       c1497490 020cc7f3 0000009b 0000d84f c149758c c0126e8c 00000012 00000000
       d8ee3bd0 00000018 00000000 00000000 d8ee3b58 c03ed08f d8ee3bd0 db861380
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
ksmserver     S C0126E8C     0  8450      1          8453  8436 (NOTLB)
       da02fb28 00200086 d35ed698 c0126e8c 00200046 d35ed698 00200292 0000000a
       dcf1f550 db206a0a 0000009a 00011cd2 dcf1f64c 005ecae9 00000000 00000000
       da02fbd0 00000017 00000000 00000000 da02fb58 c03ed08f da02fbd0 d92b0780
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_file      S 00000001     0  8456   8436          8457  8451 (NOTLB)
       d7cf9b28 00200086 00000000 00000001 c03ec444 d7de2698 00200292 0000000a
       d7e3f490 1b28c585 0000007c 00000846 d7e3f58c c0126e8c 00000000 00000000
       d7cf9bd0 00000004 00000000 00000000 d7cf9b58 c03ed08f d7cf9bd0 da2566c0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kaccess       S 00000001     0  8462      1          8465  8455 (NOTLB)
       d7f9db28 00200086 00000001 00000001 dcf5aa00 c0126e8c 00200046 0000000a
       d68c2aa0 7ca81836 0000009d 0000b2f1 d68c2b9c 0002997c 00000000 c0126e8c
       00000004 0000000b 00000000 00000000 d7f9db58 c03ed08f db85ce80 d7f9dbd0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kmix          S 00000000     0  8465      1          9369  8462 (NOTLB)
       da24bb28 00200086 00200046 00000000 00000001 00000001 dc42d3d8 0000000a
       d68c2070 db22c95a 0000009a 00014d83 d68c216c 005f68a0 00000000 dc42d3d8
       da24bb2c 0000000e 00000000 00000000 da24bb58 c03ed08f c0171e6f dc42d3d8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kadu          S DCF1E600     0  8467   8436          9525  8466 (NOTLB)
       d62b5e40 00200096 c05c957c dcf1e600 00000001 00000000 00000000 00000007
       dcf1e0f0 4a4a033b 00000087 0006da9d dcf1e1ec 00200046 00000000 00000001
       00000001 c077fb70 00000000 dcf1e0f0 d62b5e70 c03ed08f d62b5ef0 d62b5e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
aterm         S C0506E9C     0  8469   8455  8470    9571       (NOTLB)
       d638db28 00200086 dc84e030 c0506e9c d638db14 00200046 c0506e40 0000000a
       dc84e030 a79633f0 0000009a 00005ee9 dc84e12c 00006303 00000000 d638db24
       c03ef2be 00000008 00000000 00000000 d638db58 c03ed08f d99c0d80 d55a3800
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
bash          S D7E3EF70     0  8470   8469  9513               (NOTLB)
       d8a37f1c 00200096 00000000 d7e3ef70 d7e3ea60 c0526a18 d8a37f10 00000009
       d7e3ea60 41135832 0000004d 0002b1ab d7e3eb5c 00200246 c0526a00 d51dcae0
       d7e3eb04 fffffff6 d51dcae0 00000001 d8a37f88 c01187e2 00000000 bf836858
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
sshd          S D50CE098     0  9497      1          9531  9369 (NOTLB)
       d5355b28 00000086 00000001 d50ce098 c0126e8c 00000046 d50ce098 00000001
       d5353490 f09840dd 00000031 0006d9c2 d535358c d5355b20 c0126e8c 00000000
       00000000 00000004 00000000 00000000 d5355b58 c03ed08f d5355bd0 db4a0c80
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
su            S D51DCFF0     0  9513   8470  9516               (NOTLB)
       d51fff1c 00200096 00000000 d51dcff0 d51dcae0 c0526a18 d51fff10 00000007
       d51dcae0 4c32efaa 0000004e 00009da3 d51dcbdc 00200246 c0526a00 d52d2b20
       d51dcb84 fffffff6 d52d2b20 00000001 d51fff88 c01187e2 00000000 bf902118
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
bash          S D52D3058     0  9516   9513                     (NOTLB)
       d5325ebc 00200096 c05c957c d52d3058 d52d3030 00000001 00000140 00000009
       d52d2b20 cf81932b 00000053 000422ff d52d2c1c 00000e64 00000000 00000001
       00000001 d99c0c80 d55a3000 00000001 d5325eec c03ed08f d55a31dc d5325ed8
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0291e61>] read_chan+0x1b6/0x5b5
 [<c028e913>] tty_read+0x78/0xad
 [<c0165f8a>] vfs_read+0x89/0x11d
 [<c016633d>] sys_read+0x3d/0x64
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D6C7F9E0     0  9536   8436          9537  9535 (NOTLB)
       d4c31e40 00200096 c05c957c d6c7f9e0 00000001 00000000 00000000 0000000a
       d6c7f4d0 6bfc4643 0000009d 00008b28 d6c7f5cc 00200046 00000000 00000001
       00000001 c0780830 00000000 d6c7f4d0 d4c31e70 c03ed08f d4c31ef0 d4c31e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D51DDA20     0  9537   8436          9538  9536 (NOTLB)
       d3735e40 00200096 c05c957c d51dda20 00000001 00000000 00000000 0000000a
       d51dd510 0bf2e05b 00000098 0000fa97 d51dd60c 00200046 00000000 00000001
       00000001 c077f4b0 00000000 d51dd510 d3735e70 c03ed08f d3735ef0 d3735e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D51DC5C0     0  9538   8436          9539  9537 (NOTLB)
       d4c3be40 00200096 c05c957c d51dc5c0 00000001 00000000 00000000 00000006
       d51dc0b0 5c09a83c 00000058 00003e33 d51dc1ac 00200046 00000000 00000001
       00000001 c0781040 00000000 d51dc0b0 d4c3be70 c03ed08f d4c3bef0 d4c3be5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D6C7EFB0     0  9539   8436          9540  9538 (NOTLB)
       d361de40 00200096 c05c957c d6c7efb0 00000001 00000000 00000000 00000004
       d6c7eaa0 5c0ca261 00000058 00005bd2 d6c7eb9c 00200046 00000000 00000001
       00000001 c07804d0 00000000 d6c7eaa0 d361de70 c03ed08f d361def0 d361de5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D6C7E580     0  9540   8436          9541  9539 (NOTLB)
       d24e1e40 00200096 c05c957c d6c7e580 00000001 00000000 00000000 00000007
       d6c7e070 8917d7bf 0000009d 00002c49 d6c7e16c 00200046 00000000 00000001
       00000001 c077ee80 00000000 d6c7e070 d24e1e70 c03ed08f d24e1ef0 d24e1e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S D0B44FB0     0  9558   8436          9559  9557 (NOTLB)
       d0b47e40 00200096 c05c957c d0b44fb0 00000001 00000000 00000000 00000005
       d0b44aa0 02acd95e 0000005a 0001a759 d0b44b9c 00200046 00000000 00000001
       00000001 c07802c0 00000000 d0b44aa0 d0b47e70 c03ed08f d0b47ef0 d0b47e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S 00000001     0  9559   8436          9561  9558 (NOTLB)
       d055fe2c 00200092 d0b44580 00000001 00000000 00000000 00000000 00000006
       d0b44070 1a289a38 0000005a 0007c05e d0b4416c 00000000 00000001 00000000
       db4a00ac db4a0080 00000000 7fffffff d055fe5c c03ed08f d055fe40 c03eeca3
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c03a4f3d>] inet_csk_accept+0x117/0x23d
 [<c03c2069>] inet_accept+0x20/0xa7
 [<c037e227>] sys_accept+0xd5/0x196
 [<c037e3cc>] sys_socketcall+0xe4/0x277
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CFCCAFF0     0  9561   8436          9562  9559 (NOTLB)
       cfe2be40 00200096 c05c957c cfccaff0 00000001 00000000 00000000 00000008
       cfccaae0 fccca04a 00000083 00013086 cfccabdc 00200046 00000000 00000001
       00000001 c0781220 00000000 cfccaae0 cfe2be70 c03ed08f cfe2bef0 cfe2be5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CFCCA5C0     0  9562   8436          9565  9561 (NOTLB)
       cfb11e40 00200096 c05c957c cfcca5c0 00000001 00000000 00000000 00000006
       cfcca0b0 0372a2cb 0000005b 00018c11 cfcca1ac 00200046 00000000 00000001
       00000001 c0781010 00000000 cfcca0b0 cfb11e70 c03ed08f cfb11ef0 cfb11e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CF390F70     0  9570   8436          9576  9569 (NOTLB)
       cf3d3e40 00200096 c05c957c cf390f70 00000001 00000000 00000000 00000003
       cf390a60 6301a6a2 0000005b 0006f0ef cf390b5c 00200046 00000000 00000001
       00000001 c0780200 00000000 cf390a60 cf3d3e70 c03ed08f cf3d3ef0 cf3d3e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S 00000001     0  9576   8436          9579  9570 (NOTLB)
       cecf1e2c 00200092 cecb0580 00000001 00000000 00000000 00000000 00000006
       cecb0070 e9c7d9e1 0000005b 0003410c cecb016c 00000000 00000001 00000000
       d166672c d1666700 00000000 7fffffff cecf1e5c c03ed08f cecf1e40 c03eeca3
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c03a4f3d>] inet_csk_accept+0x117/0x23d
 [<c03c2069>] inet_accept+0x20/0xa7
 [<c037e227>] sys_accept+0xd5/0x196
 [<c037e3cc>] sys_socketcall+0xe4/0x277
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CEFFBAA0     0  9585   8436          9586  9584 (NOTLB)
       ceffde40 00200096 c05c957c ceffbaa0 00000001 00000000 00000000 00000002
       ceffb590 f1f433ec 0000005b 00015f36 ceffb68c 0003e6af 00000000 00000001
       00000001 c077ee80 00000000 ceffb590 ceffde70 c03ed08f ceffdef0 ceffde5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CE860F70     0  9591   8436          9593  9586 (NOTLB)
       ce883e40 00200096 c05c957c ce860f70 00000001 00000000 00000000 0000000a
       ce860a60 6ff79091 0000005c 00011b6a ce860b5c 00011f34 00000000 00000001
       00000001 c077f060 00000000 ce860a60 ce883e70 c03ed08f ce883ef0 ce883e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CEB679E0     0  9593   8436          9595  9591 (NOTLB)
       ceb69e40 00200096 c05c957c ceb679e0 00000001 00000000 00000000 00000004
       ceb674d0 4beb6790 0000005d 000025ff ceb675cc 05a6a10c 00000000 00000001
       00000001 c0780c20 00000000 ceb674d0 ceb69e70 c03ed08f ceb69ef0 ceb69e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CED14FF0     0  9598   8436          9600  9595 (NOTLB)
       cef93e40 00200096 c05c957c ced14ff0 00000001 00000000 00000000 0000000a
       ced14ae0 4d541f02 0000009d 0000c77d ced14bdc 000b1535 00000000 00000001
       00000001 c077ea00 00000000 ced14ae0 cef93e70 c03ed08f cef93ef0 cef93e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CE466FF0     0  9604   8436          9605  9600 (NOTLB)
       ce5bfe40 00200096 c05c957c ce466ff0 00000001 00000000 00000000 0000000a
       ce466ae0 a207be25 0000009d 00007ca4 ce466bdc 00200046 00000000 00000001
       00000001 c077ebb0 00000000 ce466ae0 ce5bfe70 c03ed08f ce5bfef0 ce5bfe5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CEB66FB0     0  9605   8436          9606  9604 (NOTLB)
       ceb6be40 00200096 c05c957c ceb66fb0 00000001 00000000 00000000 00000003
       ceb66aa0 fdb479f3 00000083 000183c0 ceb66b9c 00200046 00000000 00000001
       00000001 c0780470 00000000 ceb66aa0 ceb6be70 c03ed08f ceb6bef0 ceb6be5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S C011E00D     0  9606   8436          9608  9605 (NOTLB)
       cd9c5e40 00200096 00000000 c011e00d 00200046 c05846c0 00200292 0000000a
       cd9c20f0 5e01f3c5 0000009b 00008a0c cd9c21ec 00015941 00000000 00000000
       00200292 cd9c5e50 000c0cce cd9c20f0 cd9c5e70 c03ed069 cd9c5ef0 cd9c5e5c
Call Trace:
 [<c03ed069>] schedule_timeout+0x44/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CDAE1AA0     0  9608   8436          9609  9606 (NOTLB)
       cdae3e40 00200096 c05c957c cdae1aa0 00000001 00000000 00000000 00000008
       cdae1590 5441f608 00000090 00009d39 cdae168c 00200046 00000000 00000001
       00000001 c0780290 00000000 cdae1590 cdae3e70 c03ed08f cdae3ef0 cdae3e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CDAE1070     0  9609   8436          9610  9608 (NOTLB)
       cdae5e40 00200096 c05c957c cdae1070 00000001 00000000 00000000 0000000a
       cdae0b60 ff5559e4 0000005e 0000ce00 cdae0c5c 00200046 00000000 00000001
       00000001 c0780980 00000000 cdae0b60 cdae5e70 c03ed08f cdae5ef0 cdae5e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CD7339A0     0  9611   8436          9616  9610 (NOTLB)
       cd735e40 00200096 c05c957c cd7339a0 00000001 00000000 00000000 0000000a
       cd733490 f1af9e28 00000083 0000b734 cd73358c 00000872 00000000 00000001
       00000001 c0780830 00000000 cd733490 cd735e70 c03ed08f cd735ef0 cd735e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CCEA0580     0  9616   8436         10190  9611 (NOTLB)
       ccb3de40 00200096 c05c957c ccea0580 00000001 00000000 00000000 0000000a
       ccea0070 b528fa27 0000009d 00003f77 ccea016c 00200046 00000000 00000001
       00000001 c0780c50 00000000 ccea0070 ccb3de70 c03ed08f ccb3def0 ccb3de5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CEFFB070     0 10191   8436         12076 10190 (NOTLB)
       c2f8fe40 00200096 c05c957c ceffb070 00000001 00000000 00000000 00000007
       ceffab60 2259964d 0000009c 00031cb3 ceffac5c 00200046 00000000 00000001
       00000001 c0780e00 00000000 ceffab60 c2f8fe70 c03ed08f c2f8fef0 c2f8fe5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CF6F7A60     0 12239   8436         12240 12238 (NOTLB)
       d1ae5e40 00200096 c05c957c cf6f7a60 00000001 00000000 00000000 0000000a
       cf6f7550 fb9a2355 0000009b 0003f470 cf6f764c 00000fed 00000000 00000001
       00000001 c0780320 00000000 cf6f7550 d1ae5e70 c03ed08f d1ae5ef0 d1ae5e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CF6F7030     0 12240   8436         12241 12239 (NOTLB)
       d1ad5e40 00200096 c05c957c cf6f7030 00000001 00000000 00000000 00000001
       cf6f6b20 a8878d7b 0000009c 0001c6a6 cf6f6c1c 00200046 00000000 00000001
       00000001 c077e880 00000000 cf6f6b20 d1ad5e70 c03ed08f d1ad5ef0 d1ad5e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S CD9C3030     0 12241   8436         12242 12240 (NOTLB)
       ce863e40 00200096 c05c957c cd9c3030 00000001 00000000 00000000 00000005
       cd9c2b20 a885c6d5 0000009c 000217c2 cd9c2c1c 00088a61 00000000 00000001
       00000001 c07804d0 00000000 cd9c2b20 ce863e70 c03ed08f ce863ef0 ce863e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S C2F93030     0 12242   8436         12243 12241 (NOTLB)
       d964be40 00200096 c05c957c c2f93030 00000001 00000000 00000000 0000000a
       c2f92b20 7ba1e50b 0000009b 0008456b c2f92c1c 00069224 00000000 00000001
       00000001 c0780920 00000000 c2f92b20 d964be70 c03ed08f d964bef0 d964be5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
java          S C2F93A60     0 12243   8436         12244 12242 (NOTLB)
       ccea3e40 00200096 c05c957c c2f93a60 00000001 00000000 00000000 0000000a
       c2f93550 4a2e8661 0000009d 0003f58d c2f9364c 00000fd3 00000000 00000001
       00000001 c077e550 00000000 c2f93550 ccea3e70 c03ed08f ccea3ef0 ccea3e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kmail         S D2500FF0     0  9542      1          9543  9529 (NOTLB)
       d15abe40 00000096 c05c957c d2500ff0 00000001 00000000 00000000 00000009
       d2500ae0 060640dd 00000059 00090622 d2500bdc 00000046 00000000 00000001
       00000001 c077e520 00000000 d2500ae0 d15abe70 c03ed08f d15abef0 d15abe5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kmail         S D25005C0     0  9543      1          9544  9542 (NOTLB)
       d15ade40 00000096 c05c957c d25005c0 00000001 00000000 00000000 00000009
       d25000b0 06068b17 00000059 00004a3a d25001ac 00000046 00000000 00000001
       00000001 c077e520 00000000 d25000b0 d15ade70 c03ed08f d15adef0 d15ade5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kmail         S D15AFA60     0  9544      1          9545  9543 (NOTLB)
       d15b1e40 00000096 c05c957c d15afa60 00000001 00000000 00000000 00000009
       d15af550 0606bfed 00000059 000034d6 d15af64c 00000046 00000000 00000001
       00000001 c077e520 00000000 d15af550 d15b1e70 c03ed08f d15b1ef0 d15b1e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kmail         S D15AF030     0  9545      1         12260  9544 (NOTLB)
       d15b3e40 00000096 c05c957c d15af030 00000001 00000000 00000000 00000008
       d15aeb20 0606f3e4 00000059 000033f7 d15aec1c 00000046 00000000 00000001
       00000001 c077e520 00000000 d15aeb20 d15b3e70 c03ed08f d15b3ef0 d15b3e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
knotify       S 00000001     0  9531      1          9529  9497 (NOTLB)
       d35ddb28 00200086 00000000 00000001 c03ec444 c0126e8c 00200046 0000000a
       dc856aa0 020befa4 0000009b 000008ef dc856b9c d3a0d200 d35ddb24 c0126e8c
       00000004 0000000b 00000000 00000000 d35ddb58 c03ed08f db8706c0 d35ddbd0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_file      S C0126E8C     0  9565   8436          9566  9562 (NOTLB)
       cf14bb28 00200086 d03ac098 c0126e8c 00200046 d03ac098 00200292 00000007
       cf6f60f0 0ecda3c3 00000085 00002275 cf6f61ec c0126e8c 00000000 00000000
       cf14bbd0 00000004 00000000 00000000 cf14bb58 c03ed08f cf14bbd0 d41f5980
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
aterm         S C0506E9C     0  9571   8455  9572   12181  8469 (NOTLB)
       cec13b28 00200086 cf390030 c0506e9c cec13b14 00200046 c0506e40 0000000a
       cf390030 dbde350e 0000009a 00008498 cf39012c 0007cdde 00000000 cec13b24
       c03ef2be 00000008 00000000 00000000 cec13b58 c03ed08f d420f6c0 cf8ba000
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
bash          S CECB19E0     0  9572   9571  9592               (NOTLB)
       cecaff1c 00200096 00000000 cecb19e0 cecb14d0 c0526a18 cecaff10 00000009
       cecb14d0 3edaf6bb 0000005c 0002b011 cecb15cc 00200246 c0526a00 ce860030
       cecb1574 fffffff6 ce860030 00000001 cecaff88 c01187e2 00000000 bf93d968
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_pop3      S C0126E8C     0 12076   8436         12077 10191 (NOTLB)
       c8785b28 00000086 c371c698 c0126e8c 00000046 c371c698 00000292 0000000a
       c87820b0 015da769 0000009b 0000f35e c87821ac c0126e8c 00000000 00000000
       c8785bd0 00000004 00000000 00000000 c8785b58 c03ed08f c8785bd0 d92b0480
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_pop3      S C0126E8C     0 12077   8436         12081 12076 (NOTLB)
       cefb7b28 00000086 c371c398 c0126e8c 00000046 c371c398 00000292 0000000a
       cefb5550 534a399f 00000096 000115bf cefb564c c0126e8c 00000000 00000000
       cefb7bd0 00000004 00000000 00000000 cefb7b58 c03ed08f cefb7bd0 d95f6180
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_pop3      S C0126E8C     0 12081   8436         12082 12077 (NOTLB)
       c21b9b28 00000086 cbba7398 c0126e8c 00000046 cbba7398 00000292 0000000a
       c3678130 b08291ee 00000097 000105d5 c367822c c0126e8c 00000000 00000000
       c21b9bd0 00000004 00000000 00000000 c21b9b58 c03ed08f c21b9bd0 d8d137c0
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_pop3      S C0126E8C     0 12082   8436         12192 12081 (NOTLB)
       d9a69b28 00000086 d87d6c98 c0126e8c 00000046 d87d6c98 00000292 0000000a
       d9d49590 579c12f2 00000096 0000fdad d9d4968c c0126e8c 00000000 00000000
       d9a69bd0 00000004 00000000 00000000 d9a69b58 c03ed08f d9a69bd0 dd322980
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
aterm         S C0506E9C     0 12181   8455 12182          9571 (NOTLB)
       c363fb28 00200086 d9a6b4d0 c0506e9c c363fb14 00200046 c0506e40 0000000a
       d9a6b4d0 fdde1dc5 00000099 00005fd1 d9a6b5cc 00200282 c0506e80 c363fb24
       c03ef2be 00000008 00000000 00000000 c363fb58 c03ed08f d4205a80 d8015800
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
bash          S CD732F70     0 12182  12181 12193               (NOTLB)
       cd075f1c 00200096 00000000 cd732f70 cd732a60 c0526a18 cd075f10 00000008
       cd732a60 0f2cbc0e 00000079 0002b1da cd732b5c 00200246 c0526a00 c3678b60
       cd732b04 fffffff6 c3678b60 00000001 cd075f88 c01187e2 00000000 bfb0e338
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
kio_thumbnail S C0126E8C     0 12192   8436         12200 12082 (NOTLB)
       ce85fb28 00200086 d4b8b098 c0126e8c 00200046 d4b8b098 00200292 00000009
       ccea0aa0 a93fa808 0000007c 0000840f ccea0b9c c0126e8c 00000000 00000000
       ce85fbd0 0000000b 00000000 00000000 ce85fb58 c03ed08f ce85fbd0 d41f5a80
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
vim           S C0506E9C     0 12193  12182                     (NOTLB)
       c5b1fb28 00200086 c3678b60 c0506e9c c5b1fb14 00200046 c0506e40 00000007
       c3678b60 c9c23a7b 00000083 0000bda6 c3678c5c 00200282 c0506e80 c5b1fb24
       c03ef2be 00000001 00000000 00000000 c5b1fb58 c03ed08f dc8bf680 c6457800
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c0171765>] do_select+0x473/0x566
 [<c0171a04>] core_sys_select+0x1ac/0x2ec
 [<c0171f09>] sys_select+0x39/0x18f
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
mozilla-launc S CE8619A0     0 12244   8436 12253   12310 12243 (NOTLB)
       c21bbf1c 00200096 00000000 ce8619a0 ce861490 c0526a18 c21bbf10 00000006
       ce861490 c57168c2 00000090 0006afda ce86158c 00200246 c0526a00 ccea14d0
       ce861534 fffffff6 ccea14d0 00000001 c21bbf88 c01187e2 00000000 bffeec68
Call Trace:
 [<c01187e2>] do_wait+0x41f/0xa9c
 [<c0118e91>] sys_wait4+0x32/0x34
 [<c0118eba>] sys_waitpid+0x27/0x29
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
firefox-bin   S D9A6AFB0     0 12268  12244         12273 12267 (NOTLB)
       ca579e40 00200096 c05c957c d9a6afb0 00000001 00000000 00000000 00000007
       d9a6aaa0 47fa7738 00000094 000092af d9a6ab9c 00200046 00000000 00000001
       00000001 c077f8a0 00000000 d9a6aaa0 ca579e70 c03ed08f ca579ef0 ca579e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
firefox-bin   S C8B6F070     0 12273  12244         12311 12268 (NOTLB)
       c81d9e40 00200096 c05c957c c8b6f070 00000001 00000000 00000000 0000000a
       c8b6eb60 6b68fbeb 00000098 00001bac c8b6ec5c 00200046 00000000 00000001
       00000001 c077ff30 00000000 c8b6eb60 c81d9e70 c03ed08f c81d9ef0 c81d9e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================
firefox-bin   S C7526F70     0 12311  12244         12315 12273 (NOTLB)
       c8b71e40 00200096 c05c957c c7526f70 00000001 00000000 00000000 0000000a
       c7526a60 b5581b64 0000009d 00007f82 c7526b5c 00200046 00000000 00000001
       00000001 c077f360 00000000 c7526a60 c8b71e70 c03ed08f c8b71ef0 c8b71e5c
Call Trace:
 [<c03ed08f>] schedule_timeout+0x6a/0xa4
 [<c013185d>] do_futex+0x9cb/0xf36
 [<c0131e1b>] sys_futex+0x53/0xb2
 [<c0103f38>] sysenter_past_esp+0x5d/0x81
 =======================

Showing all locks held in the system:
1 lock held by agetty/8357:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by agetty/8358:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by agetty/8359:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by agetty/8360:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by agetty/8361:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by agetty/8362:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by bash/9516:
 #0:  (&tty->atomic_read_lock){....}, at: [<c03ed6f6>] mutex_lock_interruptible+0x1c/0x1f
1 lock held by firefox-bin/12253:
 #0:  (&mm->mmap_sem){....}, at: [<c0111717>] do_page_fault+0xad/0x5c6
3 locks held by firefox-bin/12322:
 #0:  (&serio->lock){....}, at: [<c032f02e>] serio_interrupt+0x1b/0x6f
 #1:  (sysrq_key_table_lock){....}, at: [<c029d4eb>] __handle_sysrq+0x1a/0x115
 #2:  (tasklist_lock){....}, at: [<c012d82e>] debug_show_all_locks+0x24/0x146

=============================================

SysRq : Emergency Sync


--Boundary-00=_5xv6FG5Xb4jc7P+
Content-Type: text/plain;
  charset="iso-8859-1";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21-rc2-mm1
# Sun Mar  4 14:14:37 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SWAP_PREFETCH=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
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
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_CLASSIC_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y

#
# Process debugging support
#
CONFIG_UTRACE=y
CONFIG_PTRACE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
# CONFIG_HPET_TIMER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_ADAPTIVE_READAHEAD=y
# CONFIG_DEBUG_READAHEAD is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_PM_STD_PARTITION="/dev/hda2"

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set

#
# APM (Advanced Power Management) BIOS Support
#
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU idle PM support
#
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK is not set
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NETFILTER_XTABLES is not set

#
# IP: Netfilter Configuration
#
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_MAC80211=m
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
CONFIG_WIRELESS_EXT=y
CONFIG_CFG80211=m
CONFIG_CFG80211_WEXT_COMPAT=y
CONFIG_NL80211=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_BLK_DEV_INITRD=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
CONFIG_BLK_DEV_IDESCSI=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=y
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_WDC_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
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
# CONFIG_IDE_ARM is not set
# CONFIG_IDE_CHIPSETS is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
CONFIG_IDEDMA_AUTO=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# PCMCIA SCSI adapter support
#
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_NINJA_SCSI is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
# CONFIG_ATA is not set

#
# Old CD-ROM drivers (not SCSI, not IDE)
#
# CONFIG_CD_NO_IDESCSI is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FW is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_IEEE1394_EXTRA_CONFIG_ROMS is not set

#
# Device Drivers
#

#
# Texas Instruments PCILynx requires I2C
#
CONFIG_IEEE1394_OHCI1394=y

#
# Protocol Drivers
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_RAWIO=y

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set

#
# Tulip family network device support
#
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_VIOC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
CONFIG_NET_RADIO=y
# CONFIG_NET_WIRELESS_RTNETLINK is not set

#
# Obsolete Wireless cards support (pre-802.11)
#
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
# CONFIG_WAVELAN is not set
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_PCMCIA_NETWAVE is not set

#
# Wireless 802.11 Frequency Hopping cards support
#
# CONFIG_PCMCIA_RAYCS is not set

#
# Wireless 802.11b ISA/PCI cards support
#
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_AIRO is not set
CONFIG_HERMES=m
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
# CONFIG_ATMEL is not set

#
# Wireless 802.11b Pcmcia/Cardbus cards support
#
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set

#
# Prism GT/Duette 802.11(a/b/g) PCI/Cardbus support
#
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_BCM43XX_MAC80211 is not set
# CONFIG_RT2X00 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ZD1211RW_MAC80211 is not set
# CONFIG_RTL818X is not set
# CONFIG_RTL8187 is not set
CONFIG_NET_WIRELESS=y

#
# PCMCIA network device support
#
# CONFIG_NET_PCMCIA is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NETPOLL_RX=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS_CS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# SPI support
#
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_AT25 is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frambuffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

#
# Logo configuration
#
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=y
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# SoC audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set
# CONFIG_USB_GTCO is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_MON=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GOTEMP is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_BLOCK=m
CONFIG_MMC_SDHCI=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_K8 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_POLL=y

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y

#
# DMA Devices
#

#
# Auxiliary Display support
#
# CONFIG_KS0108 is not set

#
# Virtualization
#
# CONFIG_KVM is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISER4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=1250
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-2"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Layered filesystems
#
# CONFIG_UNION_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp1250"
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
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
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
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
# CONFIG_NLS_UTF8 is not set

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=y
# CONFIG_PROFILE_LIKELY is not set
CONFIG_FORCED_INLINING=y
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_INTEGRITY is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FS_CAPABILITIES is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_MANAGER=m
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_CRC_ITU_T is not set
CONFIG_LIBCRC32C=m
# CONFIG_EEPROM_93CX6 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

--Boundary-00=_5xv6FG5Xb4jc7P+--
