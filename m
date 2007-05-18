Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXERHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXERHJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXERHJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:09:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:54009 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbXERHJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:09:09 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Liu <r63238@freescale.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1179466769.3658.0.camel@localhost.localdomain>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
	 <464CB071.5050504@ru.mvista.com>
	 <9095839480a9686d9c40aa6143edb804@kernel.crashing.org>
	 <464CB460.40905@ru.mvista.com>
	 <97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org>
	 <1179464690.32247.370.camel@localhost.localdomain>
	 <1179466769.3658.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 18 May 2007 17:08:15 +1000
Message-Id: <1179472096.32247.394.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 13:39 +0800, Dave Liu wrote:
> > > Yes, on some implementations there can be other conditions that
> > > make a decrementer exception go away; there is no contradiction
> > > here (thankfully).  My wording was sloppy.
> > 
> > Some CPUs have the DEC exceptions basically edge triggered (yeah I know
> 
> for example?
> 
> > it sucks). That's why, among others, the IRQ soft-disable code has code
> > to re-trigger DEC exceptions ASAP (by setting it to 1.. note that we
> > could probably use 0 here, we've been a bit conservative).

I'm not 100% certain... Paulus thinks all the old 6xx are like that, and
maybe POWER4. If I look at the oldest BookIV I can find (the 601), it
says that an exception is generated when the MSB transitions from 0 to
1. It's not clear wether the exception sticks while that bit is 1 or is
indeed considered as an "edge" event that gets cleared as soon as
delivered.

Ben.


