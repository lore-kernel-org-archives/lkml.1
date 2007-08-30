Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXH3HLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXH3HLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbXH3HLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:11:23 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60245 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbXH3HLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:11:22 -0400
Message-ID: <46D66C2D.3010900@gmail.com>
Date: Thu, 30 Aug 2007 09:05:17 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: keith.packard@intel.com
CC: Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
Subject: Re: CFS review
References: <200708111344.42934.a1426z@gawab.com>	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>	 <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu>	 <1188361749.21502.123.camel@koto.keithp.com>	 <20070829044614.GA13225@elte.hu>	 <1188374249.21502.155.camel@koto.keithp.com>	 <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com> <46D5CF5F.6090505@gmail.com>
In-Reply-To: <46D5CF5F.6090505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2007 09:56 PM, Rene Herman wrote:

Realised the BUGs may mean the kernel DRM people could want to be in CC...

> On 08/29/2007 05:57 PM, Keith Packard wrote:
> 
>> With X server 1.3, I'm getting consistent crashes with two glxgear
>> instances running. So, if you're getting any output, it's better than my
>> situation.
> 
> Before people focuss on software rendering too much -- also with 1.3.0
> (and a Matrox Millenium G550 AGP, 32M) glxgears also works decidedly
> crummy using hardware rendering. While I can move the glxgears window
> itself, the actual spinning wheels stay in the upper-left corner of the
> screen and the movement leaves a non-repainting trace on the screen.
> Running a second instance of glxgears in addition seems to make both
> instances unkillable -- and when I just now forcefully killed X in this
> situation (the spinning wheels were covering the upper left corner of all
> my desktops) I got the below.
> 
> Kernel is 2.6.22.5-cfs-v20.5, schedule() is in the traces (but that may be
> expected anyway).
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000010
>  printing eip:
> c10ff416
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: nfsd exportfs lockd nfs_acl sunrpc nls_iso8859_1 
> nls_cp437 vfat fat nls_base
> CPU:    0
> EIP:    0060:[<c10ff416>]    Not tainted VLI
> EFLAGS: 00210246   (2.6.22.5-cfs-v20.5-local #5)
> EIP is at mga_dma_buffers+0x189/0x2e3
> eax: 00000000   ebx: efd07200   ecx: 00000001   edx: efc32c00
> esi: 00000000   edi: c12756cc   ebp: dfea44c0   esp: dddaaec0
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process glxgears (pid: 1775, ti=dddaa000 task=e9daca60 task.ti=dddaa000)
> Stack: efc32c00 00000000 00000004 e4c3bd20 c10fa54b e4c3bd20 efc32c00 
> 00000000
>        00000004 00000000 00000000 00000000 00000000 00000001 00010000 
> bfbdb8bc
>        bfbdb8b8 00000000 c10ff28d 00000029 c12756cc dfea44c0 c10f87fc 
> bfbdb844
> Call Trace:
>  [<c10fa54b>] drm_lock+0x255/0x2de
>  [<c10ff28d>] mga_dma_buffers+0x0/0x2e3
>  [<c10f87fc>] drm_ioctl+0x142/0x18a
>  [<c1005973>] do_IRQ+0x97/0xb0
>  [<c10f86ba>] drm_ioctl+0x0/0x18a
>  [<c10f86ba>] drm_ioctl+0x0/0x18a
>  [<c105b0d7>] do_ioctl+0x87/0x9f
>  [<c105b32c>] vfs_ioctl+0x23d/0x250
>  [<c11b533e>] schedule+0x2d0/0x2e6
>  [<c105b372>] sys_ioctl+0x33/0x4d
>  [<c1003d1e>] syscall_call+0x7/0xb
>  =======================
> Code: 9a 08 03 00 00 8b 73 30 74 14 c7 44 24 04 28 76 1c c1 c7 04 24 49 
> 51 23 c1 e8 b0 74 f1 ff 8b 83 d8 00 00 00 83 3d 1c 47 30 c1 00 <8b> 40 
> 10 8b a8 58 1e 00 00 8b 43 28 8b b8 64 01 00 00 74 32 8b
> EIP: [<c10ff416>] mga_dma_buffers+0x189/0x2e3 SS:ESP 0068:dddaaec0
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000010
>  printing eip:
> c10ff416
> *pde = 00000000
> Oops: 0000 [#2]
> PREEMPT
> Modules linked in: nfsd exportfs lockd nfs_acl sunrpc nls_iso8859_1 
> nls_cp437 vfat fat nls_base
> CPU:    0
> EIP:    0060:[<c10ff416>]    Not tainted VLI
> EFLAGS: 00210246   (2.6.22.5-cfs-v20.5-local #5)
> EIP is at mga_dma_buffers+0x189/0x2e3
> eax: 00000000   ebx: efd07200   ecx: 00000001   edx: efc32c00
> esi: 00000000   edi: c12756cc   ebp: dfea4780   esp: e0552ec0
> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> Process glxgears (pid: 1776, ti=e0552000 task=c19ec000 task.ti=e0552000)
> Stack: efc32c00 00000000 00000003 efc64b40 c10fa54b efc64b40 efc32c00 
> 00000000
>        00000003 00000000 00000000 00000000 00000000 00000001 00010000 
> bf8dbdcc
>        bf8dbdc8 00000000 c10ff28d 00000029 c12756cc dfea4780 c10f87fc 
> bf8dbd54
> Call Trace:
>  [<c10fa54b>] drm_lock+0x255/0x2de
>  [<c10ff28d>] mga_dma_buffers+0x0/0x2e3
>  [<c10f87fc>] drm_ioctl+0x142/0x18a
>  [<c11b53f6>] preempt_schedule+0x4e/0x5a
>  [<c10f86ba>] drm_ioctl+0x0/0x18a
>  [<c10f86ba>] drm_ioctl+0x0/0x18a
>  [<c105b0d7>] do_ioctl+0x87/0x9f
>  [<c105b32c>] vfs_ioctl+0x23d/0x250
>  [<c11b52a9>] schedule+0x23b/0x2e6
>  [<c11b533e>] schedule+0x2d0/0x2e6
>  [<c105b372>] sys_ioctl+0x33/0x4d
>  [<c1003d1e>] syscall_call+0x7/0xb
>  =======================
> Code: 9a 08 03 00 00 8b 73 30 74 14 c7 44 24 04 28 76 1c c1 c7 04 24 49 
> 51 23 c1 e8 b0 74 f1 ff 8b 83 d8 00 00 00 83 3d 1c 47 30 c1 00 <8b> 40 
> 10 8b a8 58 1e 00 00 8b 43 28 8b b8 64 01 00 00 74 32 8b
> EIP: [<c10ff416>] mga_dma_buffers+0x189/0x2e3 SS:ESP 0068:e0552ec0
> [drm:drm_release] *ERROR* Device busy: 2 0

Rene.
