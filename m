Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbZIPXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbZIPXTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbZIPXTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:19:47 -0400
Received: from mail.pawisda.de ([213.157.4.156]:39140 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313AbZIPXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:19:46 -0400
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: paulmck@linux.vnet.ibm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090916155719.GA10588@linux.vnet.ibm.com>
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com>
	 <20090916152929.GA6737@linux.vnet.ibm.com>
	 <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
	 <20090916154716.GC6737@linux.vnet.ibm.com>
	 <20090916155719.GA10588@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 01:19:46 +0200
Message-Id: <1253143186.9006.0.camel@queen>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 08:57 -0700, Paul E. McKenney wrote:
> On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > > > by other means since kmemleak was disabled and all callbacks are
> > > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > > > 
> > > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > > preemption? The kernel oops looks like this:
> > > > 
> > > > From your description and the code above, I must suspect a bug with
> > > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > > 
> > > > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> > > 
> > > CONFIG_NR_CPUS=1.
> > 
> > I was afraid of that.  ;-)
> 
> PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
> single-CPU operation, but it is with synchronize_rcu() rather than
> call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
> the following patch.
> 
> So, could you please give the following patch a try?

Sadly this does not fix the issue, is there any further information I
can provide to you?

Regards, Eric

