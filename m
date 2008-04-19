Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbYDSKoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbYDSKoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYDSKoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:44:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbYDSKoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:44:11 -0400
Date: Sat, 19 Apr 2008 12:43:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Message-ID: <20080419104356.GC13599@elte.hu>
References: <20080419085758.GA18612@elte.hu> <Pine.LNX.4.64.0804191208430.25553@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804191208430.25553@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> > [   47.370972]  [<c01b1a62>] kmem_cache_destroy+0xf8/0x102
> > [   47.377727]  [<c09dab7f>] scsi_put_host_cmd_pool+0x42/0x58
> > [   47.382973]  [<c09db1b4>] scsi_destroy_command_freelist+0x54/0x5c
> > [   47.386972]  [<c09db2ef>] scsi_host_dev_release+0x79/0xa9
> > [   47.394973]  [<c067ee95>] device_release+0x3e/0x54
> > [   47.398974]  [<c04e0e62>] kobject_release+0x45/0x55
> > [   47.405383]  [<c04e0e1d>] ? kobject_release+0x0/0x55
> > [   47.409513]  [<c04e1968>] kref_put+0x3e/0x49
> > [   47.414975]  [<c04e0d8d>] kobject_put+0x19/0x1b
> > [   47.418975]  [<c067f44e>] put_device+0x16/0x18
> > [   47.422975]  [<c09db274>] scsi_host_put+0x12/0x14
> > [   47.426975]  [<c09db3dc>] scsi_unregister+0x1d/0x20
> > [   47.433383]  [<c1ceddcc>] aha1542_detect+0x7db/0x7f5
> > [   47.438977]  [<c01698aa>] ? trace_hardirqs_on+0xb/0xd
> > [   47.442976]  [<c1ceddf1>] ? init_this_scsi_driver+0xb/0xd0
> > [   47.450666]  [<c1cede44>] init_this_scsi_driver+0x5e/0xd0
> > [   47.454978]  [<c1c944db>] kernel_init+0x152/0x2b0
> > [   47.458978]  [<c1c94389>] ? kernel_init+0x0/0x2b0
> > [   47.465249]  [<c1c94389>] ? kernel_init+0x0/0x2b0
> > [   47.469258]  [<c01199c3>] kernel_thread_helper+0x7/0x10
> > [   47.474978]  =======================
> > [   47.478980] ---[ end trace 778e504de7e3b1e3 ]---
> > [   47.483297] ------------[ cut here ]------------
> > 
> > config and bootlog at:
> > 
> >  http://redhat.com/~mingo/misc/config-Sat_Apr_19_10_28_28_CEST_2008.bad
> >  http://redhat.com/~mingo/misc/log-Sat_Apr_19_10_28_28_CEST_2008.bad
> > 
> > [a few .config options were turned off: just accept all the defaults 
> >  after 'make oldconfig']
> 
> I couldn't spot anything in particular in SLUB which makes me think 
> SCSI code simply didn't free all objects before 
> scsi_put_host_cmd_pool() called kmem_cache_destroy() to kill the 
> cache.
> 
> James, does this make sense or should I just look at SLUB harder?

yesterday's x86.git auto-qa passed fine with hundreds of successful 
builds and bootups so SLUB cannot be the culprit - i think it's more 
likely the SCSI layer changes that were pulled last night.

	Ingo
