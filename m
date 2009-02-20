Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZBTT5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZBTT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBTT5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:57:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:40045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZBTT5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:57:40 -0500
Date: Fri, 20 Feb 2009 11:57:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090220115745.43d202d6@infradead.org>
In-Reply-To: <20090220160737.GC11294@elte.hu>
References: <20090220125516.GB10232@linux.vnet.ibm.com>
	<20090220132145.GF26418@elte.hu>
	<20090220141415.GA27381@dirshya.in.ibm.com>
	<20090220160737.GC11294@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 17:07:37 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > > I'd also suggest to not do that rather ugly 
> > > enable_timer_migration per-cpu variable, but simply reuse 
> > > the existing nohz.load_balancer as a target CPU.
> > 
> > This is a good idea to automatically bias the timers.  But 
> > this nohz.load_balancer is a very fast moving target and we 
> > will need some heuristics to estimate overall system idleness 
> > before moving the timers.
> > 
> > I would agree that the power saving load balancer has a good 
> > view of the system and can potentially guide the timer biasing 
> > framework.
> 
> Yeah, it's a fast moving target, but it already concentrates 
> the load somewhat.
> 

I wonder if the real answer for this isn't to have timers be considered 
schedulable-entities and have the regular scheduler decide where they
actually run.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
