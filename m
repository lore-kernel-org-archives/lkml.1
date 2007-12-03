Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbXLCAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbXLCAAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 19:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbXLCAAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 19:00:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56086 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754007AbXLCAAf (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 19:00:35 -0500
Date: Mon, 3 Dec 2007 11:00:19 +1100
From: David Chinner <dgc@sgi.com>
To: Avuton Olrich <avuton@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com, rjw@sisk.pl
Subject: Re: BUG: XFS/firefox-bin (2.6.23.8)
Message-ID: <20071203000019.GU119954183@sgi.com>
References: <3aa654a40712020902i7aa31320kc0bb89b7c1289c86@mail.gmail.com> <3aa654a40712020906v286f66fem2713a63ebf86161c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa654a40712020906v286f66fem2713a63ebf86161c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 09:06:19AM -0800, Avuton Olrich wrote:
> Adding xfs to CC
> 
> On Dec 2, 2007 9:02 AM, Avuton Olrich <avuton@gmail.com> wrote:
> > Hello,
> >
> > 2.6.23.8 just crashed here, it had been up 8 days and suspended to
> > disk many times in those 8 days. The process that crashed it was
> > firefox-3.0b1. It crashed and could not be killed (please excuse me, I
> > failed to get ps auxf output).
> >
> > All of the following information was after reboot, except, of course,
> > for the BUG.
.....

> > [ 3158.936251] BUG: unable to handle kernel NULL pointer dereference
> > at virtual address 00000000
> > [ 3158.936260]  printing eip:
> > [ 3158.936261] c013405b
> > [ 3158.936262] *pde = 00000000
> > [ 3158.936266] Oops: 0002 [#1]
> > [ 3158.936276] PREEMPT
> > [ 3158.936282] Modules linked in: cdc_acm netconsole snd_pcm_oss snd_mixer_oss
> > [ 3158.936297] CPU:    0
> > [ 3158.936298] EIP:    0060:[<c013405b>]    Not tainted VLI
> > [ 3158.936299] EFLAGS: 00210246   (2.6.23.8 #4)
> > [ 3158.936312] EIP is at current_kernel_time+0x2b/0x40

I don't think this is XFS related - there's something really screwed up
if you've crashed in current_kernel_time().

We've got suspend/resume involved, so who knows what might have gone
wrong.

Rafael, any ideas?

> > [ 3158.936316] eax: 00000000   ebx: 24a60770   ecx: 00000000   edx: 0f99c038
> > [ 3158.936320] esi: 00402000   edi: 00000007   ebp: 000081a4   esp: ee429ce0
> > [ 3158.936323] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> > [ 3158.936327] Process firefox-bin (pid: 11154, ti=ee428000
> > task=eec00540 task.ti=ee428000)
> > [ 3158.936331] Stack: f177ac00 f21128c0 00000007 000081a4 c026495a
> > 00008000 efeb4180 00000000
> > [ 3158.936348]        c023ac60 098c745c 00000000 00000001 00000004
> > ee429d30 00000000 f7c129e0
> > [ 3158.936366]        f21128c0 00000000 098c745c 00000000 f177ac00
> > f7c129e0 00000000 ee429e18
> > [ 3158.936451] Call Trace:
> > [ 3158.936455]  [<c026495a>] xfs_ichgtime+0x1a/0xa0
> > [ 3158.936465]  [<c023ac60>] xfs_ialloc+0x230/0x620
> > [ 3158.936473]  [<c0252345>] xfs_dir_ialloc+0x85/0x2d0
> > [ 3158.936483]  [<c024f0b2>] xfs_trans_reserve+0x82/0x200
> > [ 3158.936489]  [<c02585c6>] xfs_create+0x386/0x690
> > [ 3158.936494]  [<c01793b0>] dput+0x20/0x150
> > [ 3158.936501]  [<c013a3a6>] futex_wait+0x266/0x360
> > [ 3158.936507]  [<c0258240>] xfs_create+0x0/0x690
> > [ 3158.936511]  [<c026486b>] xfs_vn_mknod+0x15b/0x200
> > [ 3158.936516]  [<c0264930>] xfs_vn_create+0x0/0x10
> > [ 3158.936521]  [<c0170483>] vfs_create+0x93/0xd0
> > [ 3158.936525]  [<c017358e>] open_namei+0x53e/0x650
> > [ 3158.936530]  [<c0153802>] do_wp_page+0x312/0x4a0
> > [ 3158.936537]  [<c0166b7e>] do_filp_open+0x2e/0x60
> > [ 3158.936542]  [<c016681e>] get_unused_fd_flags+0x4e/0xe0
> > [ 3158.936546]  [<c0166bfc>] do_sys_open+0x4c/0xe0
> > [ 3158.936612]  [<c0166ccc>] sys_open+0x1c/0x20
> > [ 3158.936616]  [<c01040ee>] sysenter_past_esp+0x5f/0x85
> > [ 3158.936622]  =======================
> > [ 3158.936624] Code: 55 8b 0d 80 a4 56 c0 57 56 53 eb 06 8d 74 26 00
> > 89 d1 8b 1d b4 a4 56 c0 8b 35 b0 a4 56 c0 8b 15 80 a4 56 c0 89 c8 83
> > e1 01 31 d0 <09> c8 75 e1 89 da 89 f0 5b 5e 5f 5d c3 90 8d b4 26 00 00
> > 00 00

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
