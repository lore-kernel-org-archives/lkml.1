Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYGTJnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYGTJnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYGTJnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:43:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:35898 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYGTJnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:43:14 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 05:43:14 EDT
Subject: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree for
	July 17: early crash on x86-64)
From: Thomas Meyer <thomas@m3y3r.de>
To: James Morris <jmorris@namei.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Al Viro <viro@zeniv.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au>
References: <20080718012842.690b8346.sfr@canb.auug.org.au>
	 <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com>
	 <20080719035231.GU28946@ZenIV.linux.org.uk>
	 <200807192042.06988.rjw@sisk.pl>
	 <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 11:42:53 +0200
Message-Id: <1216546973.3217.6.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 20.07.2008, 05:54 +1000 schrieb James Morris:
> On Sat, 19 Jul 2008, Rafael J. Wysocki wrote:
> 
> > > vfs-next/net-next conflict; apply the patch below on top of the
> merge.
> > 
> > That helped, thanks.
> > 
> > But next it ran into the BUG_ON() in line 883 of
> security/selinux/avc.c .
> > Disabling selinux made the kernel boot, finally.
> 
> Ugh, that's not supposed to happen.  Where was this in the boot?  Do
> you 
> have a console log?
> 

[    3.845808] ------------[ cut here ]------------
[    3.845858] kernel BUG at security/selinux/avc.c:883!
[    3.845910] invalid opcode: 0000 [#1] SMP 
[    3.846004] last sysfs file: 
[    3.846004] Modules linked in:
[    3.846004] 
[    3.846004] Pid: 1, comm: swapper Not tainted (2.6.26-next-20080718 #17)
[    3.846004] EIP: 0060:[<c04d31cb>] EFLAGS: 00010246 CPU: 0
[    3.846066] EIP is at avc_has_perm_noaudit+0x19/0x359
[    3.846116] EAX: 00000001 EBX: 00000006 ECX: 00000006 EDX: 00000003
[    3.846168] ESI: f7803280 EDI: f781ee28 EBP: f781ee0c ESP: f781edb8
[    3.846220]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.846272] Process swapper (pid: 1, ti=f781e000 task=f7830000 task.ti=f781e000)
[    3.846324] Stack: f781ee0c 0006ee18 00000003 00000001 f781edd4 00100000 f7803280 00000001 
[    3.846608]        00000000 f7410f68 f7410f78 f7825000 f781ee10 c0491bcb f781ee64 f7402088 
[    3.846892]        00000004 019ff37b 00000006 f7803280 f781ee28 f781ee48 c04d3e38 00000000 
[    3.847181] Call Trace:
[    3.847280]  [<c0491bcb>] ? __d_lookup+0x9e/0xda
[    3.847379]  [<c04d3e38>] ? avc_has_perm+0x22/0x43
[    3.847476]  [<c0492269>] ? dput+0x34/0xf7
[    3.847574]  [<c04d52d8>] ? inode_has_perm+0x5b/0x65
[    3.847673]  [<c04d5694>] ? selinux_inode_permission+0xff/0x108
[    3.847771]  [<c04d10ca>] ? security_inode_permission+0x1e/0x20
[    3.847870]  [<c04885f4>] ? permission+0xc9/0xdd
[    3.847968]  [<c048862a>] ? vfs_permission+0x10/0x12
[    3.848070]  [<c0481552>] ? sys_faccessat+0xb7/0x149
[    3.848172]  [<c04bd680>] ? sysfs_create_file+0x20/0x22
[    3.848270]  [<c043445b>] ? flush_cpu_workqueue+0x2a/0x66
[    3.848368]  [<c078ae5b>] ? pci_mmcfg_insert_resources+0xc1/0xe8
[    3.848467]  [<c04815f4>] ? sys_access+0x10/0x12
[    3.848565]  [<c0767421>] ? kernel_init+0x22b/0x24f
[    3.848664]  [<c078d4d9>] ? tcp_congestion_default+0x0/0xf
[    3.848763]  [<c0423a0d>] ? schedule_tail+0x1a/0x49
[    3.848861]  [<c04037f2>] ? ret_from_fork+0x6/0x1c
[    3.848959]  [<c07671f6>] ? kernel_init+0x0/0x24f
[    3.849063]  [<c07671f6>] ? kernel_init+0x0/0x24f
[    3.849161]  [<c04044ef>] ? kernel_thread_helper+0x7/0x10
[    3.849260]  =======================
[    3.849310] Code: c0 b8 e8 6c 7a c0 03 04 95 40 ee 75 c0 ff 40 14 c9 c3 55 89 e5 57 56 53 83 ec 48 83 7d 08 00 89 45 b8 89 55 b4 66 89 4d b2 75 04 <0f> 0b eb fe 64 8b 15 04 50 7a c0 b8 e8 6c 7a c0 0f b7 4d b2 03 
[    3.850916] EIP: [<c04d31cb>] avc_has_perm_noaudit+0x19/0x359 SS:ESP 0068:f781edb8
[    3.851057] ---[ end trace 357a5e75e9b6bc6a ]---
[    3.851106] Kernel panic - not syncing: Attempted to kill init!
[    3.851159] Pid: 1, comm: swapper Tainted: G      D   2.6.26-next-20080718 #17
[    3.851237]  [<c063b0bd>] ? printk+0xf/0x12
[    3.851336]  [<c063b007>] panic+0x39/0xe0
[    3.851410]  [<c0429588>] do_exit+0x5b/0x6d1
[    3.851486]  [<c040436c>] ? apic_timer_interrupt+0x28/0x30
[    3.851585]  [<c063b0bd>] ? printk+0xf/0x12
[    3.851682]  [<c042688d>] ? oops_exit+0x23/0x28
[    3.851786]  [<c0404c1d>] die+0x12b/0x133
[    3.851859]  [<c063dad2>] do_trap+0x8a/0xa3
[    3.851934]  [<c0404fc5>] ? do_invalid_op+0x0/0x76
[    3.852039]  [<c0405031>] do_invalid_op+0x6c/0x76
[    3.852114]  [<c04d31cb>] ? avc_has_perm_noaudit+0x19/0x359
[    3.852212]  [<c0439c2c>] ? hrtimer_start+0x126/0x140
[    3.852312]  [<c063d41a>] error_code+0x72/0x78
[    3.852387]  [<c04d31cb>] ? avc_has_perm_noaudit+0x19/0x359
[    3.852486]  [<c0491bcb>] ? __d_lookup+0x9e/0xda
[    3.852584]  [<c04d3e38>] avc_has_perm+0x22/0x43
[    3.852659]  [<c0492269>] ? dput+0x34/0xf7
[    3.852757]  [<c04d52d8>] inode_has_perm+0x5b/0x65
[    3.852836]  [<c04d5694>] selinux_inode_permission+0xff/0x108
[    3.852912]  [<c04d10ca>] security_inode_permission+0x1e/0x20
[    3.852989]  [<c04885f4>] permission+0xc9/0xdd
[    3.853070]  [<c048862a>] vfs_permission+0x10/0x12
[    3.853149]  [<c0481552>] sys_faccessat+0xb7/0x149
[    3.853227]  [<c04bd680>] ? sysfs_create_file+0x20/0x22
[    3.853328]  [<c043445b>] ? flush_cpu_workqueue+0x2a/0x66
[    3.853431]  [<c078ae5b>] ? pci_mmcfg_insert_resources+0xc1/0xe8
[    3.853532]  [<c04815f4>] sys_access+0x10/0x12
[    3.853609]  [<c0767421>] kernel_init+0x22b/0x24f
[    3.853688]  [<c078d4d9>] ? tcp_congestion_default+0x0/0xf
[    3.853797]  [<c0423a0d>] ? schedule_tail+0x1a/0x49
[    3.853896]  [<c04037f2>] ? ret_from_fork+0x6/0x1c
[    3.853996]  [<c07671f6>] ? kernel_init+0x0/0x24f
[    3.854099]  [<c07671f6>] ? kernel_init+0x0/0x24f
[    3.854198]  [<c04044ef>] kernel_thread_helper+0x7/0x10
[    3.854276]  =======================



