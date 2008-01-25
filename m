Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbYAYXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbYAYXNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761584AbYAYXMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:12:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:53475 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382AbYAYXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V3gnqvBvES/r22SWIICr26Xhax2P7Csqh14sLMjJ5x/vb/3AfezJVAQDTcvXZCc+bJRPT22wGIxsysrL5Q0oQYXpeorHSWRQM5MolA1VSwggNrifZjodZkVCpeazz03X9GjwHRiXW7HpbTUyeUXfZDFVyk4mg+PpXCchqq6I4Ik=
Message-ID: <86802c440801251512j2de50420ud50c31f03b141362@mail.gmail.com>
Date: Fri, 25 Jan 2008 15:12:29 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080125224711.GA6323@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
	 <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu>
	 <20080125224711.GA6323@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 2:47 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
> >
> > * Greg KH <gregkh@suse.de> wrote:
> >
> > > On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> > > > current linus tree + x86.git
> > > >
> > > > got
> > > >
> > > > Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> > > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > > > IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
> > >
> > > Does this happen on just Linus's tree?
> > >
> > > Can you send me a .config file for this?
> > >
> > > What is threshold_init()?  Is it something new in the x86.git tree?
> >
> > no. A quick grep shows that it is in a file that _your_ changes in
> > Linus' latest have touched:
> >
> >   arch/x86/kernel/cpu/mcheck/mce_amd_64.c
>
> Ok, those are pretty much just search/and/replace type changes, but I
> have been running x86-64 boxes with these changes in place.
>
> That's why I'm interested if Linus's tree right now shows this problem,
> and if I can get a .config of the offending kernel to try to reproduce
> it and fix it myself.

Calling initcall 0xffffffff80ba1dee: threshold_init_device+0x0/0x3f()
Unable to handle kernel NULL pointer dereference at 0000000000000040 RIP:
 [<ffffffff8045d2e8>] kobject_uevent_env+0x2a/0x3dd
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g99f1c97d-dirty #1
RIP: 0010:[<ffffffff8045d2e8>]  [<ffffffff8045d2e8>]
kobject_uevent_env+0x2a/0x3dd
RSP: 0000:ffff81042643db50  EFLAGS: 00010286
RAX: 0000000000000018 RBX: 0000000000000000 RCX: 00000000c0000410
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
RBP: 0000000000000018 R08: ffff810824960dc0 R09: 0000000024960dc0
R10: ffffc200025299d0 R11: ffff810824960dc0 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffffffff80b4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81042643c000, task ffff81082643a000)
Stack:  ffff810824960dc0 00000000802c7ffe ffffffff809a28be ffffffff80a96f10
 ffff810824960eb0 0000000000000000 ffff810824960dc0 ffff8108265120c0
 0000000000000004 ffffffff802c7b93 0000000024960dc0 00000000c000040f
Call Trace:
 [<ffffffff802c7b93>] sysfs_add_file+0x5b/0x81
 [<ffffffff80215fcb>] allocate_threshold_blocks+0x184/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80216236>] threshold_create_device+0x23f/0x32e
 [<ffffffff8023fede>] __mod_timer+0xc3/0xd3
 [<ffffffff80ba1e04>] threshold_init_device+0x16/0x3f
 [<ffffffff80b9963a>] kernel_init+0x175/0x2e1
 [<ffffffff8020cd48>] child_rip+0xa/0x12
 [<ffffffff80b994c5>] kernel_init+0x0/0x2e1
 [<ffffffff8020cd3e>] child_rip+0x0/0x12


Code: 4c 8b 70 28 4d 85 f6 75 14 48 8b 40 20 48 85 c0 75 ee 41 bd
RIP  [<ffffffff8045d2e8>] kobject_uevent_env+0x2a/0x3dd
 RSP <ffff81042643db50>
CR2: 0000000000000040
---[ end trace 778e504de7e3b1e3 ]---
Kernel panic - not syncing: Attempted to kill init!
