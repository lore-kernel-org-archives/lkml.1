Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbYG1SxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbYG1SxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYG1Sw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:52:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbYG1Sw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cFMuQSgdxKPceIToCQeS+1ttQCHEg/5LlYpSISjRjJ1Aq/RJ5NDc9F2n4KRWRZsjsr
         4wU8PVFFbbkz5tFLAmeVYCnGTeh73ljq03N9+fC7390Zgs+zsdJoMRpJDuILRh4kwnlE
         goqoYtdft8DP3npxgOesUXAm4MrnTtopDsjWc=
Date: Mon, 28 Jul 2008 22:53:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, torvalds@osdl.org
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-$sha1: RIP gup_pte_range+0x54/0x120
Message-ID: <20080728185316.GA19479@martell.zuzino.mipt.ru>
References: <20080728184947.GA5041@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728184947.GA5041@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:49:47PM +0400, Alexey Dobriyan wrote:
> Version: 2.6.26-837b41b5de356aa67abb2cadb5eef3efc7776f91
> Core2 Duo, x86_64, 4 GB of RAM.
> 
> Kernel is "tainted" with ZFS driver, but it can so little, and
> probability of screwup is very little too. :-)
> 
> 
> Long LTP session finally ended with
> 
> BUG: unable to handle kernel paging request at ffff88012b60c000
> IP: [<ffffffff80223ff4>] gup_pte_range+0x54/0x120
> PGD 202063 PUD a067 PMD 17cedc163 PTE 800000012b60c160
> Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU 0 
> Modules linked in: zfs iptable_raw xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 ip_tables x_tables nf_conntrack_irc nf_conntrack fuse usblp uhci_hcd ehci_hcd usbcore sr_mod cdrom [last unloaded: zfs]
> Pid: 16863, comm: vmsplice01 Tainted: G        W 2.6.26-zfs #2
> RIP: 0010:[<ffffffff80223ff4>]  [<ffffffff80223ff4>] gup_pte_range+0x54/0x120
> RSP: 0018:ffff88012ff57c68  EFLAGS: 00010096
> RAX: 0000000000000008 RBX: 00007fff4a800000 RCX: 0000000000000001
> RDX: ffffe200040b5f00 RSI: 00007fff4a800310 RDI: ffff88012b60c000
> RBP: ffff88012ff57c78 R08: 0000000000000005 R09: ffff88012ff57cec
> R10: 0000000000000024 R11: 0000000000000205 R12: ffff88012ff57e58
> R13: 00007fff4a807310 R14: 00007fff4a80730f R15: ffff88012ff57e58
> FS:  00007fbb4280b6f0(0000) GS:ffffffff805dec40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88012b60c000 CR3: 000000017e294000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process vmsplice01 (pid: 16863, threadinfo ffff88012ff56000, task ffff88015f9db360)
> Stack:  00007fff4a800000 ffff88010e6cf298 ffff88012ff57d18 ffffffff802243cb
>  0000000000000002 ffff88015f9db360 0000000004f23a08 00007fff4a7f7310
>  ffff88017d582880 00007fff4a807310 00007fff4a807310 ffff88017e2947f8
> Call Trace:
>  [<ffffffff802243cb>] get_user_pages_fast+0x1db/0x300
>  [<ffffffff802b1bfd>] sys_vmsplice+0x32d/0x420
>  [<ffffffff80262acd>] ? unlock_page+0x2d/0x40
>  [<ffffffff80275d78>] ? __do_fault+0x1c8/0x450
>  [<ffffffff8030e20c>] ? __up_read+0x4c/0xb0
>  [<ffffffff802495c6>] ? up_read+0x26/0x30
>  [<ffffffff802b0780>] ? spd_release_page+0x0/0x20
>  [<ffffffff80463f0d>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b

Very reproducible and ZFS driver doesn't matter:

	# vmsplice01 from LTP 20080630
	# while true; do ./vmsplice01; done

