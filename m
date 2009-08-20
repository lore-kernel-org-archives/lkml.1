Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZHTJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZHTJXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZHTJXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:23:18 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:47851 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZHTJXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DHjk2tnb1mwIzLVLekxE8oWTI6Qj+e6Rq99XLNuOlKXCpsHQgJNKmOBzF2jfsS4BDj
         wB+vdgBWTVq9dWpaSpULKN+DIeVV7KwQs/hQNOHTXrtiLCSIUOzdbYkFPz7S6jRRC3gV
         isUANtRo9dI0w3XQEMiTFShE4QKp1b5hrIVAA=
MIME-Version: 1.0
In-Reply-To: <m1ocqbgcsi.fsf@fess.ebiederm.org>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	 <m1skfnggrb.fsf@fess.ebiederm.org>
	 <7b6bb4a50908200010h1c60d007p4fa017fd97c87c19@mail.gmail.com>
	 <m1ocqbgcsi.fsf@fess.ebiederm.org>
Date: Thu, 20 Aug 2009 17:23:18 +0800
Message-ID: <7b6bb4a50908200223r2fd66e62sf659561bcf097c46@mail.gmail.com>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer 
	dereference at 0000000000000008
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got following on 2.6.31-rc5 and rc6 .....

------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:287!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/irq
CPU 2
Modules linked in: fuse sco bridge stp llc bnep l2cap bluetooth sunrpc
ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6
dm_multipath uinput radeon snd_hda_codec_analog ttm drm snd_hda_intel
i2c_algo_bit i2c_i801 snd_hda_codec snd_hwdep snd_pcm wmi dcdbas
i2c_core ppdev parport_pc parport snd_timer e1000e snd soundcore
snd_page_alloc iTCO_wdt iTCO_vendor_support pcspkr serio_raw
ata_generic pata_acpi [last unloaded: speedstep_lib]
Pid: 17, comm: events/2 Not tainted 2.6.31-rc5 #51 OptiPlex 760
RIP: 0010:[<ffffffff81060941>]  [<ffffffff81060941>] worker_thread+0x1bc/0x31d
RSP: 0000:ffff88022ec61de0  EFLAGS: 00010286
RAX: ffff88021200d238 RBX: ffff88003598ec00 RCX: 000000000000009f
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88022edf22f0
RBP: ffff88022ec61eb0 R08: 0000000000000000 R09: ffff88003598ec00
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021200d230
R13: ffff88003598ec40 R14: 0000000000000000 R15: ffff88003598ec50
FS:  0000000000000000(0000) GS:ffff8800357b8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000001af7aa8 CR3: 00000001fd0d3000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/2 (pid: 17, threadinfo ffff88022ec60000, task ffff88022edf22f0)
Stack:
 ffffffff81060945 ffffffff81415f34 ffff88022ec61e00 ffff88022ec61e20
<0> ffff88022ec61e20 ffffffff810739bb ffff88021200d238 ffff88022edf22f0
<0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81060945>] ? worker_thread+0x1c0/0x31d
 [<ffffffff81415f34>] ? thread_return+0x3e/0xaf
 [<ffffffff810739bb>] ? lock_release_holdtime+0x2c/0x11d
 [<ffffffff8106549e>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81060785>] ? worker_thread+0x0/0x31d
 [<ffffffff8106513c>] kthread+0x8a/0x92
 [<ffffffff81012d4a>] child_rip+0xa/0x20
 [<ffffffff810126d0>] ? restore_args+0x0/0x30
 [<ffffffff810650b2>] ? kthread+0x0/0x92
 [<ffffffff81012d40>] ? child_rip+0x0/0x20
Code: 08 48 89 31 48 89 52 08 48 89 12 48 89 85 60 ff ff ff e8 66 74
3b 00 48 8b 85 60 ff ff ff 48 8b 50 f8 48 83 e2 fc 48 39 d3 74 04 <0f>
0b eb fe f0 80 60 f8 fe 48 8b bb a8 00 00 00 45 31 c9 31 c9
RIP  [<ffffffff81060941>] worker_thread+0x1bc/0x31d
 RSP <ffff88022ec61de0>
---[ end trace 4d8a59030f36f167 ]---



On Thu, Aug 20, 2009 at 3:33 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Xiaotian Feng <xtfeng@gmail.com> writes:
>
> > On Thu, Aug 20, 2009 at 2:07 PM, Eric W. Biederman <ebiederm@xmission.com>
> > wrote:
> >
> >
> >     ebiederm@xmission.com (Eric W. Biederman) writes:
> >
> >     > I'm not certain who I should route this too, but I just had 2.6.31-rc6
> >     > fall over on me.  I don't know how reproducible this will be but
> >     > I have a full crash dump if someone is interested in looking into this.
> >
> >     Looks like I was wrong.  This is appears trivial to reproduce,
> >     I have just reproduced it two more times in a row.  I think
> >     the problem is pty related.
> >
> >     I was looking into a change in behavior on 2.6.31-rc6 where
> >     data was being lost, and it appears one variant of my test program
> >     kills the kernel.
> >
> >     The following program run as an unprivileged user causes a kernel
> >     panic in about a minute:
> >
> >     aka
> >
> >     while :; do ./KernelTtyTest ; done
> >
> >
> > oops.... It panics my x86_64 machine.....
>
> I guess I forgot to mention that detail.  Thanks for confirming this
> bug isn't just me.
>
> Eric
