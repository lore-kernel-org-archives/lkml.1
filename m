Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbZKXSAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbZKXSAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbZKXSAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:00:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:3680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769AbZKXSAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="516968703"
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <m1ws1f6csh.fsf@fess.ebiederm.org>
References: <20091120211139.GB19106@sgi.com>
	 <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	 <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	 <1259069986.4531.1453.camel@laptop>
	 <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	 <20091124065022.6933be1a@infradead.org>  <m1ws1f6csh.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 10:00:56 -0800
Message-Id: <1259085656.2631.50.camel@ppwaskie-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:41 -0800, Eric W. Biederman wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Tue, 24 Nov 2009 14:55:15 +0100 (CET)
> >> > Furthermore, the /sysfs topology information should include IRQ
> >> > routing data in this case.
> >> 
> >> Hmm, not sure about that. You'd need to scan through all the nodes to
> >> find the set of CPUs where an irq can be routed to. I prefer to have
> >> the information exposed by the irq enumeration (which is currently in
> >> /proc/irq though).
> >
> > yes please.
> >
> > one device can have multiple irqs
> > one irq can be servicing multiple devices
> >
> > expressing that in sysfs is a nightmare, while
> > sticking it in /proc/irq *where the rest of the info is* is
> > much nicer for apps like irqbalance
> 
> Oii.
> 
> I don't think it is bad to export information to applications like irqbalance.
> 
> I think it pretty horrible that one of the standard ways I have heard
> to improve performance on 10G nics is to kill irqbalance.
> 

This is something I'm actively trying to fix (see thread "irq: Add
node_affinity CPU masks for smarter irqbalance hints").  That patch may
not be the final answer, but whatever comes of it will fix the
recommendation of "killall irqbalance" for performance boosts.

Cheers,
-PJ

