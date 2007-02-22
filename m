Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbXBVDON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbXBVDON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXBVDON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:14:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:39963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbXBVDOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:14:12 -0500
Date: Thu, 22 Feb 2007 04:14:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [patch 2/2] sched: dynticks idle load balancing - v2
Message-ID: <20070222031406.GC12137@wotan.suse.de>
References: <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <20070216180842.B8744@unix-os.sc.intel.com> <20070221122344.564fb44f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221122344.564fb44f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 12:23:44PM -0800, Andrew Morton wrote:
> On Fri, 16 Feb 2007 18:08:42 -0800

> > +int select_nohz_load_balancer(int stop_tick)
> > +{
> > +	int cpu = smp_processor_id();
> > +
> > +	if (stop_tick) {
> > +		cpu_set(cpu, nohz.cpu_mask);
> > +		cpu_rq(cpu)->in_nohz_recently = 1;
> > +
> > +		/*
> > +		 * If we are going offline and still the leader, give up!
> > +		 */
> > +		if (cpu_is_offline(cpu) && nohz.load_balancer == cpu) {
> > +			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
> 
> So we require that architectures which implement CONFIG_NO_HZ also
> implement cmpxchg.

Just use atomic_cmpxchg, please.
