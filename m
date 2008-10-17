Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYJQBn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYJQBn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYJQBnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:43:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41404
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbYJQBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:43:16 -0400
Date: Thu, 16 Oct 2008 18:42:52 -0700 (PDT)
Message-Id: <20081016.184252.193691889.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: paulus@samba.org, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       benh@kernel.crashing.org, mingo@redhat.com
Subject: Re: [RFC patch 04/15] get_cycles() : powerpc64 HAVE_GET_CYCLES
 (update)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081017004328.GA29768@Krystal>
References: <20081016234656.055839676@polymtl.ca>
	<18679.56239.74999.534588@cargo.ozlabs.ibm.com>
	<20081017004328.GA29768@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 16 Oct 2008 20:43:28 -0400

> * Paul Mackerras (paulus@samba.org) wrote:
> > Mathieu Desnoyers writes:
> > 
> > > This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
> > > get_cycles_rate() are implemented.
> > 
> > [snip]
> > 
> > > +static inline cycles_t get_cycles_rate(void)
> > > +{
> > > +	return CLOCK_TICK_RATE;
> > > +}
> > 
> > CLOCK_TICK_RATE is certainly wrong.  You want ppc_tb_freq (declared in
> > asm/time.h).  Or tb_ticks_per_sec, since we seem to have two variables
> > for exactly the same thing, for some reason. :)
> > 
> > Paul.
> 
> Ok, this should work better. Thanks !
> 
> Do you know if mtfb implies an instruction synchronization (isync) ? I
> think that if it does not, the new get_cycles_barrier() might have to be
> used at some locations in the kernel code if more precise timestamp
> order is required.

You'll need to make a similar fix on sparc64.
