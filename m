Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYE0FcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYE0FcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYE0Fbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:31:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:13681 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYE0Fbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=w0A+uppz/DWjKGygfIovJCyrTvjpylVVRig9XD25iJuvpaBuzSL7lva39jLQCqdtQBhjytTWccIqGjB0b9Z35KEHSCBDlyBk2SX1w/1iN/Cv4QT2CZoyCxzV9mY7pbhg5WOPeiVCv+VvrL/hJ3SqyirQlEUeWap3Cgk/dM/gLWk=
Date: Tue, 27 May 2008 09:27:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>, torvalds@osdl.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080527052740.GB28301@martell.zuzino.mipt.ru>
References: <20080427225553.GA4848@martell.zuzino.mipt.ru> <20080428050145.af036c4f.akpm@linux-foundation.org> <20080428120412.GY12774@kernel.dk> <20080428195509.GA5247@martell.zuzino.mipt.ru> <20080429062116.GA5059@martell.zuzino.mipt.ru> <20080429090604.GK12774@kernel.dk> <20080430221250.GA10150@martell.zuzino.mipt.ru> <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510103719.GA4967@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 02:37:19PM +0400, Alexey Dobriyan wrote:
> > > > > @@ -41,8 +41,8 @@ int put_io_context(struct io_context *ioc)
> > > > >  		rcu_read_lock();
> > > > >  		if (ioc->aic && ioc->aic->dtor)
> > > > >  			ioc->aic->dtor(ioc->aic);
> > > > > -		rcu_read_unlock();
> > > > >  		cfq_dtor(ioc);
> > > > > +		rcu_read_unlock();
> > > > >  
> > > > >  		kmem_cache_free(iocontext_cachep, ioc);
> > > > >  		return 1;
> > > > 
> > > > This helps in sense that 3 times bulk cross-compiles finish to the end.
> > > > You'll hear me if another such oops will resurface.
> > > 
> > > Still looking good?
> > 
> > Yup!
> 
> And this with patch in mainline, again with PREEMPT_RCU.

Ping, this happened again with 2.6.26-rc4 and PREEMPT_RCU.

> general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU 0 
> Modules linked in: ext2 nls_utf8 cifs nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
> Pid: 26971, comm: fixdep Not tainted 2.6.26-rc1-28a4acb48586dc21d2d14a75a7aab7be78b7c83b #4
> RIP: 0010:[<ffffffff80304b30>]  [<ffffffff80304b30>] __call_for_each_cic+0x20/0x50
> RSP: 0018:ffff810104335e58  EFLAGS: 00010202
> RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
> RDX: 0000000000002827 RSI: 0000000000000000 RDI: ffff810105a62280
> RBP: ffff810104335e78 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff8101715bde40
> R13: ffffffff80304ba0 R14: ffff81017fcc0000 R15: ffff810105a623e8
> FS:  00002b50c7e566f0(0000) GS:ffffffff805c6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00002b4d7f8b9b80 CR3: 0000000000201000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process fixdep (pid: 26971, threadinfo ffff810104334000, task ffff810105a62280)
> Stack:  ffff810104335e88 ffff8101715bde40 0000000000000010 ffff810105a62380
>  ffff810104335e88 ffffffff80304b70 ffff810104335ea8 ffffffff8030000b
>  ffff810105a62380 ffff8101715bde40 ffff810104335ec8 ffffffff803000df
> Call Trace:
>  [<ffffffff80304b70>] cfq_free_io_context+0x10/0x20
>  [<ffffffff8030000b>] put_io_context+0x7b/0x90
>  [<ffffffff803000df>] exit_io_context+0x8f/0xb0
>  [<ffffffff80236533>] do_exit+0x543/0x770
>  [<ffffffff802367a1>] do_group_exit+0x41/0xb0
>  [<ffffffff80236822>] sys_exit_group+0x12/0x20
>  [<ffffffff8020b60b>] system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 49 89 f5 41 54 49 89 fc 53 48 83 ec 08 48 8b 47 68 48 85 c0 74 1f 48 89 c3 90 <48> 8b 03 48 8d 73 88 4c 89 e7 0f 18 08 41 ff d5 48 8b 03 48 85 
> RIP  [<ffffffff80304b30>] __call_for_each_cic+0x20/0x50
>  RSP <ffff810104335e58>
> ---[ end trace ff773ec56ab2930e ]---
> Fixing recursive fault but reboot is needed!

