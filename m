Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXCWPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXCWPpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992466AbXCWPpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:45:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:47729 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992469AbXCWPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ioRWFy+YxEIlz8ywkZg5P5d4b53DmCfsw59o+mwBDZvK1GxvpUpIqwUJpBhRaoNt+3ymqHhN+lrYg1Nxk8tGKBUQbWywoCe/ULsAMxuMOoh3kYdUeoqWDqOZs9w3bX9g96vNmMEvxhLDhXm3wytTp8LHLJzrBmQosMOUnNEVwig=
Message-ID: <2fe399760703230845s4f652df0v9fd57e1aa7943e4e@mail.gmail.com>
Date: Fri, 23 Mar 2007 08:45:16 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Opps in 2.6.21-rc4 nfsd
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <20070323152913.GH752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2fe399760703221224g40fc44ddof41d1fcd442612d5@mail.gmail.com>
	 <20070323152913.GH752@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian et al,

Under 2.6.20.2+3 I get a similar crash and more frequently.  At least
under 2.6.21rc4 I only get this about once every two hours under heavy
nfs testing.

Let me know if I can provide more debugging or more information.

Thanks,
Phy

On 3/23/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, Mar 22, 2007 at 12:24:12PM -0700, Phy Prabab wrote:
> > Hello,
> >
> > I have a recent oopps on a small file server I have running.  The
> > machine in question is a dual, dual core AMD Opteron 2.2GHz w/4G RAM,
> > 3Ware 9650SE (14 drive RAID 10), using XFS, LVM2 (latest), exported
> > via knfsd.  Kernel is 2.6.21-rc4 64b.  Here is the bt:
> >
> > Mar 22 12:09:01 rcfs05 kernel: Modules linked in:
> > Mar 22 12:09:01 rcfs05 kernel: Pid: 3102, comm: nfsd Not tainted
> > 2.6.21-rc4-smp #3
> > Mar 22 12:09:01 rcfs05 kernel: RIP: 0010:[<ffffffff80350613>]
> > [<ffffffff80350613>] fh_compose+0x3e3/0x4d0
> > Mar 22 12:09:01 rcfs05 kernel: RSP: 0018:ffff8101197fdd70  EFLAGS: 00010297
> > Mar 22 12:09:01 rcfs05 kernel: RAX: 0000000000000006 RBX:
> > 000000000ee00004 RCX: 0000000000000000
> > Mar 22 12:09:01 rcfs05 kernel: RDX: 0000000000000018 RSI:
> > ffff81011975a940 RDI: 0000000000000080
> > Mar 22 12:09:01 rcfs05 kernel: RBP: 0000000000000001 R08:
> > 00000000ffffffff R09: 00002ba24f06ca50
> > Mar 22 12:09:01 rcfs05 kernel: R10: ffff81011975a808 R11:
> > ffffffff8022f500 R12: ffff81011975a938
> > Mar 22 12:09:01 rcfs05 kernel: R13: 0000000000000006 R14:
> > ffff81010eaab0c0 R15: ffff8100cc714940
> > Mar 22 12:09:01 rcfs05 kernel: FS:  00002b020c71b6d0(0000)
> > GS:ffff81011dcf56c0(0000) knlGS:0000000000000000
> > Mar 22 12:09:01 rcfs05 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > 000000008005003b
> > Mar 22 12:09:01 rcfs05 kernel: CR2: 0000000000000000 CR3:
> > 00000001173d1000 CR4: 00000000000006e0
> > Mar 22 12:09:01 rcfs05 kernel: Process nfsd (pid: 3102, threadinfo
> > ffff8101197fc000, task ffff81011b7ef020)
> > Mar 22 12:09:01 rcfs05 kernel: Stack:  ffff81010fa7b868
> > ffffffff80239d8a 0000000000000286 ffff810111aee5e8
> > Mar 22 12:09:01 rcfs05 kernel:  ffff810105af2890 ffff81011975a808
> > ffff810105af2890 000000000eaab0c0
> > Mar 22 12:09:01 rcfs05 kernel:  ffff810105af2890 ffff81011975a808
> > ffff810105af2890 000000000000000a
> > Mar 22 12:09:01 rcfs05 kernel: Call Trace:
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff80239d8a>]
> > __lookup_hash+0x7a/0x160
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff803547a5>] nfsd_lookup+0x435/0x4d0
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff8035aaa8>]
> > nfsd3_proc_lookup+0xe8/0x110
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff8034d69d>]
> > nfsd_dispatch+0xfd/0x1f0
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff80608094>] svc_process+0x3e4/0x730
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff8026bbf2>] __down_read+0x12/0xa2
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff8034dd00>] nfsd+0x1a0/0x2d0
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff80264f38>] child_rip+0xa/0x12
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff8034db60>] nfsd+0x0/0x2d0
> > Mar 22 12:09:01 rcfs05 kernel:  [<ffffffff80264f2e>] child_rip+0x0/0x12
> > Mar 22 12:09:01 rcfs05 kernel:
> > Mar 22 12:09:01 rcfs05 kernel:
> > Mar 22 12:09:01 rcfs05 kernel: Code: 48 8b 01 ba 10 00 00 00 bf 10 00
> > 00 00 48 89 06 48 8b 41 08
> > Mar 22 12:09:01 rcfs05 kernel: RIP  [<ffffffff80350613>]
> > fh_compose+0x3e3/0x4d0
> > Mar 22 12:09:01 rcfs05 kernel:  RSP <ffff8101197fdd70>
> > Mar 22 12:09:01 rcfs05 kernel: CR2: 0000000000000000
> >
> > Once this oops happens, the machine is still usable, however NFS
> > crawls to a halt (in fact one of the machines with a mount point of
> > this machine, failed to respond anymore - I assume that thread is the
> > one that ooops'ed).
> >
> > Any more information or debugging, please let me know.
>
>
> Does it work with kernel 2.6.20?
>
>
> > TIA!
> > Phy
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
