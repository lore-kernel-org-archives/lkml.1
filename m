Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZIPPrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZIPPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZIPPrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:47:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48588 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZIPPrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:47:14 -0400
Date: Wed, 16 Sep 2009 08:47:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
Message-ID: <20090916154716.GC6737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com> <20090916152929.GA6737@linux.vnet.ibm.com> <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > by other means since kmemleak was disabled and all callbacks are
> > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > 
> > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > preemption? The kernel oops looks like this:
> > 
> > From your description and the code above, I must suspect a bug with
> > RCU preemption.  A new one, as the only bugs I am currently chasing
> > involve NR_CPUS>32 (>64 on 64-bit systems).
> > 
> > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> 
> CONFIG_NR_CPUS=1.

I was afraid of that.  ;-)

							Thanx, Paul
