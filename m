Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYD2F0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYD2F0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYD2FZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:25:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:36093 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYD2FZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iEjwabNSZtBZdTaFdIzrRt+LUe6K7M/NJ9slvG9DvxFiSaXVy2ldiZ/3vZn0X/fan8fVlb0Zq10GkonJ1NKHem0QI8OlljEITWdtNk9SIvMR/e89flKS63hJFXRTc434fL5oFlip3zbCsMz5ITyThUjNb3i1AC2QAXeW2gGxrTg=
Date: Tue, 29 Apr 2008 10:21:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-$sha1: RIP call_for_each_cic+0x25/0x50
Message-ID: <20080429062116.GA5059@martell.zuzino.mipt.ru>
References: <20080427225553.GA4848@martell.zuzino.mipt.ru> <20080428050145.af036c4f.akpm@linux-foundation.org> <20080428120412.GY12774@kernel.dk> <20080428195509.GA5247@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428195509.GA5247@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:55:09PM +0400, Alexey Dobriyan wrote:
> On Mon, Apr 28, 2008 at 02:04:13PM +0200, Jens Axboe wrote:
> > On Mon, Apr 28 2008, Andrew Morton wrote:
> > > On Mon, 28 Apr 2008 02:55:53 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > 
> > > > This happened while ~90 cross-compile jobs were running in parallel on
> > > > ext2/noatime partition (slowly -- much debugging was on)
> > > > 
> > > > 
> > > > general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> > > > CPU 0 
> > > > Modules linked in: ext2 nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp uhci_hcd ehci_hcd usbcore sr_mod cdrom
> > > > Pid: 16483, comm: as Not tainted 2.6.25-c3bf9bc243092c53946fd6d8ebd6dc2f4e572d48 #1
> > > > RIP: 0010:[<ffffffff80307525>]  [<ffffffff80307525>] call_for_each_cic+0x25/0x50
> > > > RSP: 0018:ffff810170811e58  EFLAGS: 00010202
> > > > RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
> > > > RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff81010ff92000
> > > > RBP: ffff810170811e78 R08: 0000000000000001 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: ffff8100010069d8 R12: ffff810138ada300
> > > > R13: ffffffff803075b0 R14: ffff81017fcd2000 R15: ffff81010ff92168
> > > > FS:  00002ac3462426f0(0000) GS:ffffffff805d0000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > CR2: 00002ab602550000 CR3: 000000013609d000 CR4: 0000000000000660
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > Process as (pid: 16483, threadinfo ffff810170810000, task ffff81010ff92000)
> > > > Stack:  ffff810170811e88 ffff810138ada300 0000000000000010 ffff81010ff92100
> > > >  ffff810170811e88 ffffffff80307580 ffff810170811ea8 ffffffff80302a55
> > > >  ffff81010ff92100 ffff810138ada300 ffff810170811ec8 ffffffff80302b1f
> > > > Call Trace:
> > > >  [<ffffffff80307580>] cfq_free_io_context+0x10/0x20
> > > >  [<ffffffff80302a55>] put_io_context+0x85/0x90
> > > >  [<ffffffff80302b1f>] exit_io_context+0x8f/0xb0
> > > >  [<ffffffff80235d19>] do_exit+0x549/0x780
> > > >  [<ffffffff80235f8e>] do_group_exit+0x3e/0xb0
> > > >  [<ffffffff80236012>] sys_exit_group+0x12/0x20
> > > >  [<ffffffff8020b6db>] system_call_after_swapgs+0x7b/0x80
> > > > 
> > > > 
> > > > Code: 84 00 00 00 00 00 55 48 89 e5 41 55 49 89 f5 41 54 49 89 fc 53 48 83 ec 08 e8 18 e1 f5 ff 49 8b 44 24 68 48 85 c0 74 1e 48 89 c3 <48> 8b 03 48 8d 73 88 4c 89 e7 0f 18 08 41 ff d5 48 8b 03 48 85 
> > > > RIP  [<ffffffff80307525>] call_for_each_cic+0x25/0x50
> > > >  RSP <ffff810170811e58>
> > > > ---[ end trace ca143223eefdc828 ]---
> > > > Fixing recursive fault but reboot is needed!
> > > cfq-iosched.c hasn't been altered (yet) so it might not be a regression.


> > It's not a regression, it's definitely in 2.6.25 as well. So that's a
> > bit scary, I've been looking over this stuff this morning but haven't
> > pin pointed anything yet.
> > 
> > Alexey, is this something that reproduces for you?
> 
> Not yet, second run of same workload went fine and I've never seen such
> oopses before.

And it oopses the very same way on the third run. as(1) again.
So if there are any debugging patches, let me know.

