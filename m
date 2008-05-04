Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYEDCXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYEDCXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 22:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYEDCX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 22:23:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:46657 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYEDCX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 22:23:26 -0400
Subject: Re: 'global' rq->clock
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
In-Reply-To: <20080503223844.GA18344@elte.hu>
References: <20080503082849.GA29605@elte.hu>
	 <20080503.020502.226847930.davem@davemloft.net>
	 <20080503101016.GA18801@elte.hu>
	 <20080503.122734.01023096.davem@davemloft.net>
	 <1209853855.26383.28.camel@pasglop>  <20080503223844.GA18344@elte.hu>
Content-Type: text/plain
Date: Sun, 04 May 2008 12:22:47 +1000
Message-Id: <1209867767.26383.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> on nohz we still keep jiffies uptodate - despite there not being an 
> explicit 'keep jiffies uptodate' tick interrupt anymore. So on every 
> irq_enter() we roll jiffies forward - if needed - and thus emulate 
> jiffies behavior to drivers and core kernel code, etc.
> 
> if an IPI on Power does not do an irq_enter() then you might miss out on 
> updated jiffies. That might not matter for most jiffies, but you might 
> also miss out on the 'touch the softlockup watchdog because we just woke 
> from idle' action. This is what triggered the false positive warnings on 
> Sparc64.
> 
> the same bug existed on x86 too: that too does a few IPIs without 
> irq_enter/irq_exit. We now removed the softlockup dependency so it 
> should not be required to do an irq_enter()/exit anymore - unless the 
> code that the IPI uses accesses jiffies. (but that would be unusual)

Allright, so it looks like we don't have a problem today, though I'll be
careful if some of our CPUs come up with more fancy ways to do IPIs.
Currently they are just normal interrupts, so we do irq_enter/exit and
we process softirqs on the way out.

Ben.


