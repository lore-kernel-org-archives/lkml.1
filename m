Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbXLTXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbXLTXFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXLTXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:05:22 -0500
Received: from pat.uio.no ([129.240.10.15]:37698 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXLTXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:05:21 -0500
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071220145415.f737e7f3.akpm@linux-foundation.org>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	 <20071220145415.f737e7f3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 18:04:23 -0500
Message-Id: <1198191864.31865.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=5.0, autolearn=disabled, AWL=-0.260)
X-UiO-Scanned: EABB6DBCA5111FFD5464E4E40E85E9FD9ABDA006
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 39 total 5853128 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 14:54 -0800, Andrew Morton wrote:
> On Thu, 20 Dec 2007 17:40:47 -0500
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > I just got the following interesting behaviour. Never mind why the
> > original Oops (I was testing some experimental RPC patches), but there
> > appears to be a BUG_ON() triggered inside the dump() call.
> > 
> > Oops occurred with a build based on this afternoon's git tree from Linus
> > (v2.6.24-rc5-317-gfaa4877)...
> > 
> > Cheers
> >   Trond
> > ---------
> > 
> > BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> > printing eip: f8bcc8b3 *pde = 00000000 
> > BUG: using smp_processor_id() in preemptible [00000001] code: mount.nfs4/2970
> > caller is die+0x59/0x202
> > Pid: 2970, comm: mount.nfs4 Not tainted 2.6.24-rc5-ga747a088 #1
> >  [<c0405170>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0405a76>] show_trace+0x12/0x14
> >  [<c0405dc6>] dump_stack+0x6c/0x72
> >  [<c04e4cd8>] debug_smp_processor_id+0xa0/0xb4
> >  [<c0405462>] die+0x59/0x202
> >  [<c05b3e7d>] do_page_fault+0x557/0x63e
> >  [<c05b252a>] error_code+0x72/0x78
> >  [<f8bd821c>] rpcb_create+0x7c/0x84 [sunrpc]
> >  [<f8bd8552>] rpcb_register+0x127/0x18c [sunrpc]
> >  [<f8bd31d2>] svc_register+0xcf/0x14c [sunrpc]
> >  [<f8bd399f>] __svc_create+0x19a/0x1b3 [sunrpc]
> >  [<f8bd3b21>] svc_create+0x13/0x15 [sunrpc]
> >  [<f8c74beb>] nfs_callback_up+0x71/0x126 [nfs]
> >  [<f8c53cfe>] nfs_get_client+0x14e/0x3a2 [nfs]
> >  [<f8c53f88>] nfs4_set_client+0x36/0x14f [nfs]
> >  [<f8c54739>] nfs4_create_server+0x8e/0x36c [nfs]
> >  [<f8c5c6f1>] nfs4_get_sb+0x2ef/0x3f3 [nfs]
> >  [<c0477e40>] vfs_kern_mount+0x7d/0xf1
> >  [<c0477f02>] do_kern_mount+0x37/0xbd
> >  [<c048a6fb>] do_mount+0x5c3/0x61d
> >  [<c048a7c4>] sys_mount+0x6f/0xa9
> >  [<c04040b2>] sysenter_past_esp+0x5f/0xa5
> >  =======================
> 
> Yes - I don't know why the smp_processor_id() test has suddenly started
> triggering in there.
> 
> I have a sledgehammer fix (below) which Ingo went all complicated about and
> I assumed he had it in hand, but I can't see any patches anywhere?
> 
> I'd expect the kernel to spit that warning and then proceed with the usual
> oops report - that's what it did in Miles Lane's case.  But it seems in
> your case that the whole oops report simply vanished?

No. I found what I assume is the remainder of the original a couple of
pages further down...

Trond

