Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYKRVYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYKRVYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKRVYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:24:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYKRVYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:24:18 -0500
Date: Tue, 18 Nov 2008 22:24:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
	latencytop/5621
Message-ID: <20081118212404.GD19150@elte.hu>
References: <20081114085820.GA5206@dhcp35.suse.cz> <200811160028.13724.rjw@sisk.pl> <20081118123748.GB5336@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118123748.GB5336@dhcp35.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Hocko <mhocko@suse.cz> wrote:

> On Sun 16-11-08 00:28:12, Rafael J. Wysocki wrote:
> > On Friday, 14 of November 2008, Michal Hocko wrote:
> > > Hi Ingo,
> > > I am experiencing %subj whenever I run latencytop with the rc4 kernel. I
> > > have bisected down to the patch 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5
> > > I am not sure whether this is the same problem as the one reported by
> > > Maciej Rutecki (http://lkml.org/lkml/2008/11/12/266), but I have tried
> > > your patch (http://lkml.org/lkml/2008/11/12/295) and the problem is
> > > still there:
> > > BUG: using smp_processor_id() in preemptible [00000000] code:
> > > latencytop/5621
> > > caller is native_sched_clock+0x47/0x65
> > > Pid: 5621, comm: latencytop Not tainted 2.6.28-rc4 #13
> > > Call Trace:
> > >  [<c03f17c0>] ? printk+0xf/0x11
> > >  [<c022ad36>] debug_smp_processor_id+0xa2/0xb8
> > >  [<c01080d4>] native_sched_clock+0x47/0x65
> > >  [<c01259a9>] proc_sched_show_task+0xd72/0xdd0
> > >  [<c01a73c4>] sched_show+0x39/0x55
> > >  [<c018cc43>] seq_read+0xee/0x29a
> > >  [<c018cb55>] ? seq_read+0x0/0x29a
> > >  [<c017a04c>] vfs_read+0x87/0x12b
> > >  [<c017a189>] sys_read+0x3b/0x60
> > >  [<c0103a59>] sysenter_do_call+0x12/0x25
> > >  [<c03f0000>] ? cpu_callback+0x238/0x25b
> > > 
> > > I receive flood if this messages immediately after latencytop starts.
> > > Reverting 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5 solves the problem.
> > > Config is attached.
> > > 
> > > Let me know if you need some more testing (however I will afk until
> > > Tuesday).
> > 
> > Please retest with 2.6.28-rc5.
> 
> Still problem with rc5 (4e14e833ac3b97a4aa8803eea49f899adc5bb5f4).
> Ingo's patch from http://lkml.org/lkml/2008/11/16/26 fixes this problem

that's upstream now as of v2.6.28-rc5-117-g7f0f598 and later kernels, 
via this commit:

29d7b90: sched: fix kernel warning on /proc/sched_debug access

	Ingo
