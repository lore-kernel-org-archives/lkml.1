Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbXLTW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbXLTW5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbXLTW53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:57:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbXLTW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:57:28 -0500
Date: Thu, 20 Dec 2007 14:56:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071220145621.90ffb08a.akpm@linux-foundation.org>
In-Reply-To: <20071220145415.f737e7f3.akpm@linux-foundation.org>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 14:54:15 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

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

btw, I think we should track this as a regression, please.  It may not
strictly be a regression: the same problem might happen under 2.6.23,
although reports are only agaisnt 2.6.24-rc.

But things which impact our ability to get clean oops reports are critical
problems.


