Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYFPVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYFPVVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYFPVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:21:37 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:58694 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbYFPVVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:21:36 -0400
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20080616174948.GB7788@linux-os.sc.intel.com>
References: <4852B19E.4010202@trash.net>
	 <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com>
	 <20080613224711.GA15084@linux-os.sc.intel.com>
	 <1213611339.2495.11.camel@odie.local>
	 <20080616174948.GB7788@linux-os.sc.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 16 Jun 2008 23:21:23 +0200
Message-Id: <1213651283.2495.46.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

man, 16 06 2008 kl. 10:49 -0700, skrev Suresh Siddha:
> On Mon, Jun 16, 2008 at 03:15:39AM -0700, Simon Holm Thøgersen wrote:
> > fre, 13 06 2008 kl. 15:47 -0700, skrev Suresh Siddha:
> > > On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
> > > > On Fri, Jun 13, 2008 at 7:42 PM, Patrick McHardy <kaber@trash.net> wrote:
> > > > > I get this oops once a day, its apparently triggered by something
> > > > > run by cron, but the process is a different one each time.
> > > > >
> > > > > Kernel is -git from yesterday shortly before the -rc6 release
> > > > > (last commit is the usb-2.6 merge, the x86 patches are missing),
> > > > > .config is attached.
> > > > >
> > > > > I'll retry with current -git, but the patches that have gone in
> > > > > since I last updated don't look related.
> > > > >
> > > >
> > > > Thanks for the report.
> > > >
> > > > >
> > > > > [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
> > > > > 000001ff
> > > > > [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
> > > > > [62060.043009] *pde = 00000000
> > > > > [62060.043009] Oops: 0002 [#1] PREEMPT
> > >
> > > Patrick, Do you see any other error messages before this BUG stmt? Can you
> > > please provide the complete kernel log till the point of failure?
> > >
> > Suresh, I'm pretty sure this is the same problem that I reported two
> > weeks ago [1]. I suggested that you tried running lguest and reproduced
> > the problem locally, but I did not hear back from you. Now Patrick is
> > reporting the same problem and is also indicating that the problem is
> > correlated with his use of lguest, so I'd really like you to follow up
> > on this.
> 
> I am on this and did try reproducing with lguest last week but couldn't
> reproduce the issue with the initrd image. May be I need a full blown
> disk image.

Okay, I wasn't always able to reproduce it either using that image.
Maybe forcing﻿ CPU frequency to the maximum and/or adding compile load
on the host help, but I'm not sure.
> 
> > At least for me, with this patch applied on top of -rc4 or -rc6+ the
> > problem still triggered after running an lguest guest for less than 30
> > seconds (the guest didn't even finish the boot of an image of Ubuntu
> > with no X-server).
> 
> Please post the oops you captured.
> 
It is similar to the one I posted in the top of [1] earlier. The trace
is different from Patrick's and the last two I posted in [1], but there
has been a strong correlation between these three types of traces so I'm
pretty sure they are different symptoms of the same bug. I could be
wrong of course. The different traces are provoked by enabling and
disabling different debugging options, and this trace is just easier to
trigger and capture the full trace of.

BUG: sleeping function called from invalid context at mm/slab.c:3052
in_atomic():1, irqs_disabled():0
Pid: 2449, comm: lguest Not tainted
2.6.26-rc6-debug-preempt-sleeping-spinlocks-00111-g318d65c #109
 [<c01147b9>] __might_sleep+0xe4/0xeb
 [<c0160b75>] kmem_cache_alloc+0x22/0xb4
 [<c01084a9>] init_fpu+0xb0/0x14d
 [<c0104770>] math_state_restore+0x26/0x5d
 [<c01045b3>] device_not_available+0x43/0x48
 [<c011007b>] ? handle_vm86_fault+0x213/0x6b8
 [<c01029ad>] ? __switch_to+0x23/0x119
 [<c02cc98e>] schedule+0x230/0x2b3
 [<c02cceac>] ? schedule_timeout+0x16/0x89
 [<c016f38a>] ? __pollwait+0xaa/0xb0
 [<c01689ac>] ? pipe_poll+0x29/0x89
 [<c016edee>] ? do_select+0x478/0x4cd
 [<c016f2e0>] ? __pollwait+0x0/0xb0
 [<c01166d4>] ? default_wake_function+0x0/0xd
 [<c01166d4>] ? default_wake_function+0x0/0xd
 [<c01166d4>] ? default_wake_function+0x0/0xd
 [<c01166d4>] ? default_wake_function+0x0/0xd
 [<c01166d4>] ? default_wake_function+0x0/0xd
 [<c012f6dc>] ? getnstimeofday+0x37/0xbb
 [<c012d9d8>] ? ktime_get_ts+0x40/0x44
 [<c012d9ef>] ? ktime_get+0x13/0x2f
 [<c01f1acd>] ? rb_insert_color+0x55/0xbc
 [<c01217e2>] ? lock_timer_base+0x3d/0x79
 [<c01f361b>] ? delay_tsc+0x8e/0xab
 [<c0250953>] ? ide_dma_intr+0x0/0x79
 [<c01f353d>] ? __delay+0x9/0xb
 [<c01f3556>] ? __const_udelay+0x17/0x19
 [<c024c6ef>] ? ide_execute_command+0x7b/0x95
 [<c025009a>] ? ide_dma_start+0x24/0x36
 [<c024f7b3>] ? do_rw_taskfile+0x1be/0x1cf
 [<c0251c12>] ? ide_do_rw_disk+0x19a/0x1dd
 [<c01f3556>] ? __const_udelay+0x17/0x19
 [<c024ae46>] ? ide_do_request+0x838/0x875
 [<c024a239>] ? ide_end_request+0x7d/0x99
 [<c024ee23>] ? task_end_request+0x43/0x55
 [<c016f02c>] ? core_sys_select+0x1e9/0x2c7
 [<c0146ca0>] ? find_lock_page+0xa1/0xbb
 [<c0148b9e>] ? filemap_fault+0x21c/0x382
 [<c0146b3e>] ? unlock_page+0x24/0x27
 [<c0151fe7>] ? __do_fault+0x30f/0x347
 [<c0153eae>] ? handle_mm_fault+0x291/0x65a
 [<c016f41f>] ? sys_select+0x8f/0x143
 [<c02cfb91>] ? do_page_fault+0x365/0x63f
 [<c0103a6f>] ? sysenter_past_esp+0x78/0xb1
 [<c02c0000>] ? fn_hash_flush+0xe6/0x165
 =======================
BUG: sleeping function called from invalid context at mm/slab.c:3052
in_atomic():1, irqs_disabled():0
Pid: 2449, comm: lguest Not tainted
2.6.26-rc6-debug-preempt-sleeping-spinlocks-00111-g318d65c #109
 [<c01147b9>] __might_sleep+0xe4/0xeb
 [<c0160b75>] kmem_cache_alloc+0x22/0xb4
 [<c012f6dc>] ? getnstimeofday+0x37/0xbb
 [<c01084a9>] init_fpu+0xb0/0x14d
 [<c0104770>] math_state_restore+0x26/0x5d
 [<c01045b3>] device_not_available+0x43/0x48
 [<c0110000>] ? handle_vm86_fault+0x198/0x6b8
 [<c01029ad>] ? __switch_to+0x23/0x119
 [<c02cc98e>] schedule+0x230/0x2b3
 [<c0169231>] ? pipe_wait+0x53/0x72
 [<c012a917>] ? autoremove_wake_function+0x0/0x30
 [<c016990d>] ? pipe_read+0x29a/0x302
 [<c012d876>] ? hrtimer_start+0xcc/0xf8
 [<c0115f7a>] ? hrtick_set+0xcc/0x140
 [<c01636a8>] ? do_sync_read+0xba/0xf8
 [<c012a917>] ? autoremove_wake_function+0x0/0x30
 [<c0163eb0>] ? default_llseek+0xa7/0xb5
 [<c01635ee>] ? do_sync_read+0x0/0xf8
 [<c0163d8d>] ? vfs_read+0x8a/0x106
 [<c01640d2>] ? sys_read+0x3b/0x60
 [<c0103a6f>] ? sysenter_past_esp+0x78/0xb1
 =======================

> > If you or anybody else would like to use the same guest image I use
> > please just ask and I'll make it available somehow.
> 
> Can you please upload it some where? I will also try with another guest
> image meanwhile.
> 
[access provided to Suresh in private email]


Simon

