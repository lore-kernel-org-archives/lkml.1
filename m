Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbXHKRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbXHKRAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXHKRAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:00:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbXHKRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:00:44 -0400
Date: Sat, 11 Aug 2007 10:00:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       WU Fengguang <wfg@mail.ustc.edu.cn>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-Id: <20070811100015.2417788e.akpm@linux-foundation.org>
In-Reply-To: <661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com>
References: <386838491.27058@ustc.edu.cn>
	<661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 20:00:12 +0530 "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:

> On 8/11/07, Fengguang Wu <fengguang.wu@gmail.com> wrote:

hm, both people who replied to this removed Fengguang from cc.  Disagreement
between headers and MUAs, perhaps?

> > Andrew,
> >
> > I'm not sure if this patch is the right fix for the bug.  But it do
> > stops the oops message. The bug also happens in 2.6.23-rc1-mm2/2.6.23-rc2-mm2.
> > I'm running debian/sid. The .config is attached.
> >
> >
> > Unable to handle kernel NULL pointer dereference at 0000000000000138 RIP
> >  [<ffffffff81092f66>] __vm_enough_memory+0x76/0x120
> > PGD 7cd84067 PUD 7d9c3067 PMD 0
> > Oops: 0000 [2] SMP
> > CPU 1
> > Modules linked in: eeprom lm85 hwmon_vid i2c_core tun fuse kvm snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer sg snd soundcore sr_mod cdrom snd_page_alloc pcspkr evdev button raid0 usbhid sd_mod uhci_hcd ehci_hcd ata_piix ahci ohci1394 ieee1394 thermal processor fan
> > Pid: 4305, comm: khelper Tainted: G      D 2.6.23-rc2 #9
> > RIP: 0010:[<ffffffff81092f66>]  [<ffffffff81092f66>] __vm_enough_memory+0x76/0x120
> > RSP: 0000:ffff81007a3d1d30  EFLAGS: 00010206
> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000003e142
> > RDX: 00000000000004f4 RSI: 0000000000000001 RDI: 0000000000000001
> > RBP: ffff81007a3d1d40 R08: ffff81007a3d1d78 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> > R13: 0000000000000000 R14: ffff81007d0c0188 R15: ffff81007d577b18
> > FS:  0000000000000000(0000) GS:ffff81007efa11d0(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000138 CR3: 000000003799b000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process khelper (pid: 4305, threadinfo ffff81007a3d0000, task ffff81007a30acc0)
> > Stack:  0000000000000001 ffff81007d577b18 ffff81007a3d1d60 ffffffff811297ff
> >  0000000000000001 ffff810037c84bb8 ffff81007a3d1da0 ffffffff81092532
> >  ffff81007d0c0188 0000000000000000 ffff81007d577b20 0000000000000000
> > Call Trace:
> >  [<ffffffff811297ff>] cap_vm_enough_memory+0x2f/0x40
> >  [<ffffffff81092532>] insert_vm_struct+0xa2/0xb0
> >  [<ffffffff810b020e>] bprm_mm_init+0x11e/0x1b0
> >  [<ffffffff810b1b71>] do_execve+0x81/0x220
> >  [<ffffffff8104bf90>] __call_usermodehelper+0x0/0x90
> >  [<ffffffff8100abc6>] sys_execve+0x46/0xb0
> >  [<ffffffff8104bf90>] __call_usermodehelper+0x0/0x90
> >  [<ffffffff8100cf64>] kernel_execve+0x64/0xd0
> >  [<ffffffff8104bf90>] __call_usermodehelper+0x0/0x90
> >  [<ffffffff8104c384>] ____call_usermodehelper+0x174/0x190
> >  [<ffffffff8100cef8>] child_rip+0xa/0x12
> >  [<ffffffff810356f8>] schedule_tail+0x78/0x100
> >  [<ffffffff8100c60c>] restore_args+0x0/0x30
> >  [<ffffffff8104c210>] ____call_usermodehelper+0x0/0x190
> >  [<ffffffff8100ceee>] child_rip+0x0/0x12
> >
> >
> > Code: 48 8b 80 38 01 00 00 48 c1 e8 05 48 29 c1 48 39 ca 0f 8c 89
> > RIP  [<ffffffff81092f66>] __vm_enough_memory+0x76/0x120
> >  RSP <ffff81007a3d1d30>
> > CR2: 0000000000000138
> >
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  mm/mmap.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > --- linux-2.6.23-rc2-mm2.orig/mm/mmap.c
> > +++ linux-2.6.23-rc2-mm2/mm/mmap.c
> > @@ -166,7 +166,8 @@ int __vm_enough_memory(long pages, int c
> >
> >         /* Don't let a single process grow too big:
> >            leave 3% of the size of this process for other processes */
> > -       allowed -= current->mm->total_vm / 32;
> > +       if (current->mm)
> > +               allowed -= current->mm->total_vm / 32;
> >
> >         /*
> >          * cast `allowed' as a signed long because vm_committed_space
> >
> >
> 
> Shouldn't we just not stop vm accounting for kernel threads?
> 

Could be.  It'd help heaps if we knew which patch in -mm caused
this, but from a quick peek it seems to me that mainline should be
vulnerable as well.
