Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0BDPla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:41:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:45707 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932866Ab0BDPl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:41:28 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/7qIMmPff7EPeD8Hlg0JB15e9/KKEik/dq5ucPrq
	CnRHYhaEhSLold
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: patch idr-fix-a-critical-misallocation-bug.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 16:41:15 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
References: <12651725962428@site> <201002040446.05068.s.L-H@gmx.de> <4B6A4576.5050401@kernel.org>
In-Reply-To: <4B6A4576.5050401@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041641.21063.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 04 February 2010, Tejun Heo wrote:
> On 02/04/2010 12:46 PM, Stefan Lippers-Hollmann wrote:
[...]
> > On Thursday 04 February 2010, Greg KH wrote:
> >> On Wed, Feb 03, 2010 at 08:21:39AM -0500, Eric Paris wrote:
> >>> On Wed, 2010-02-03 at 14:21 +0900, Tejun Heo wrote:
> >>>
> >>>>> Eric Paris located a bug in idr.  With IDR_BITS of 6, it grows to three
> >>>>> layers when id 4096 is first allocated.  When that happens, idr wraps
> >>>>> incorrectly and searches the idr array ignoring the high bits.  The
> >>>>> following test code from Eric demonstrates the bug nicely.
[...]
> >>>> Greg, can this wait a bit more, maybe until the next -stable release?
> >>>> The code there is very fragile and this has been broken forever so I
> >>>> think it would be better if we wait a bit more while it gets testing
> >>>> mainline.
> > 
> > Just as a side note, this patch as part of the 2.6.32 stable queue (before 
> > this patch was removed again) seems to break logging into KDE 4.3.4 through
> > kdm on several different systems with Intel chipsets/ graphics (kvm 
> > active). X and kdm start normally, logging in shows the ksplash, which 
> > quickly terminates the xsession and dumps back to kdm. Removing just this 
> > patch from 2.6.32 + (previous) stable queue fixes the problem for me; 
> > however 2.6.33-rc6-git3 seems to be affected as well, but freezes X, 
> > instead of "just" terminating the current X session and reverting to kdm.
> > 
> > While I have reports from several different intel chipsets, I can 
> > personally reproduce it on an Intel D945GCLF2 mainboard:
> 
> Does this patch make any difference?

Unfortunately I don't see any change, applied to queue-2.6.32 and on top of
idr-fix-a-critical-misallocation-bug.patch, KDE 4.3.4 still terminates and 
dumps me back to kdm. Applied on top of 2.6.33-rc6-git4 it still continues 
to freeze X during ksplash and spews the same oops message as before:

[drm:i915_gem_do_execbuffer] *ERROR* Invalid object handle 1073741824 at index 19                
BUG: unable to handle kernel paging request at ffffffff00000080                                  
IP: [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]                              
PGD 14c0067 PUD 0                                                                                
Oops: 0000 [#1] PREEMPT SMP                                                                      
last sysfs file: /sys/devices/virtual/sound/timer/uevent                                         
CPU 2                                                                                            
Pid: 1857, comm: Xorg Tainted: G        W  2.6.33-rc6-sidux-amd64 #1 D945GCLF2/                  
RIP: 0010:[<ffffffffa00951af>]  [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]  
RSP: 0018:ffff880037659bf8  EFLAGS: 00010286                                                     
RAX: ffff88007e3a68c0 RBX: 00000000fffffff7 RCX: 000000000000001e                                
RDX: ffffffff00000000 RSI: ffffffffa0042710 RDI: ffff88007d6d9cc0                                
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000020                                
R10: 0000000000000000 R11: 000000000000006e R12: ffff88007e3a6800                                
R13: ffff880037659d18 R14: ffff88007e3a6800 R15: ffff880037659d18                                
FS:  00007f5b63f24790(0000) GS:ffff880001900000(0000) knlGS:0000000000000000                     
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                
CR2: ffffffff00000080 CR3: 000000007e3b6000 CR4: 00000000000006e0                                
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                
Process Xorg (pid: 1857, threadinfo ffff880037658000, task ffff8800376a86e0)                     
Stack:                                                                                           
 ffff88007c6d2ec0 0000000000000000 ffff88007c6d3158 ffffffff813513ab                             
<0> ffff88007f002dc0 ffff880000000040 fffffff57f35a800 ffff88007e025000                          
<0> 0000000000001000 ffff880037659d48 ffff88007e3a6800 ffff88007e026800                          
Call Trace:                                                                                      
 [<ffffffff813513ab>] ? unix_stream_recvmsg+0x28b/0x620
 [<ffffffff811e5976>] ? idr_get_new_above_int+0x16/0x90
 [<ffffffffa00961b0>] ? i915_gem_execbuffer+0x210/0x410 [i915]
 [<ffffffffa00904d5>] ? i915_gem_sw_finish_ioctl+0x95/0xd0 [i915]
 [<ffffffffa0040958>] ? drm_ioctl+0x308/0x440 [drm]
 [<ffffffffa0095fa0>] ? i915_gem_execbuffer+0x0/0x410 [i915]
 [<ffffffff8111ef2f>] ? do_sync_read+0xbf/0x100
 [<ffffffff81071924>] ? bit_waitqueue+0x14/0xc0
 [<ffffffff8112eed5>] ? vfs_ioctl+0x35/0xd0
 [<ffffffff8112f098>] ? do_vfs_ioctl+0x88/0x570
 [<ffffffff810566b3>] ? do_setitimer+0x1c3/0x240
 [<ffffffff8112f600>] ? sys_ioctl+0x80/0xa0
 [<ffffffff8100a002>] ? system_call_fastpath+0x16/0x1b
Code: eb 48 8b 74 24 68 44 8b 4e 08 45 85 c9 74 4a 4c 8b 64 24 50 31 ed 49 89 f5 0f 1f 00 48 63 c5 49 8d 04 c4 48 8b 10 48 85 d2 74 25 <48> 8b 92 80 00 00 00 c7 82 a0 00 00 00 00 00 00 00 48 8b 38 48
RIP  [<ffffffffa00951af>] i915_gem_do_execbuffer+0x79f/0x1370 [i915]
 RSP <ffff880037659bf8>
CR2: ffffffff00000080
---[ end trace 465d589b5d608009 ]---

Reverting 859ddf09743a8cc680af33f7259ccd0fd36bfe9d "idr: fix a critical 
misallocation bug" however fixes the problem on 2.6.33-rc6-git4 (and 
queue-2.6.32), KDE 4.3.4 starts up correctly and the oops is gone.

> diff --git a/lib/idr.c b/lib/idr.c
> index ba7d37c..a96c604 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
>  	id = *starting_id;
>   restart:
>  	p = idp->top;
> -	l = p->layer;
> +	l = idp->layers;
> +	pa[l--] = NULL;
>  	while (1) {
>  		/*
>  		 * We run around this while until we reach the leaf node...

Regards
	Stefan Lippers-Hollmann
