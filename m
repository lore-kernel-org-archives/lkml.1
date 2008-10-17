Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJQCIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJQCIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJQCI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:08:29 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:56530 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbYJQCI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:08:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAN+M90hMQWq+/2dsb2JhbACBcsF/g2w
Date: Thu, 16 Oct 2008 22:08:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       benh@kernel.crashing.org, mingo@redhat.com
Subject: Re: [RFC patch 04/15] get_cycles() : powerpc64 HAVE_GET_CYCLES
	(update)
Message-ID: <20081017020813.GA32468@Krystal>
References: <20081016234656.055839676@polymtl.ca> <18679.56239.74999.534588@cargo.ozlabs.ibm.com> <20081017004328.GA29768@Krystal> <20081016.184252.193691889.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081016.184252.193691889.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:06:04 up 134 days,  6:46, 10 users,  load average: 0.47, 0.43,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Thu, 16 Oct 2008 20:43:28 -0400
> 
> > * Paul Mackerras (paulus@samba.org) wrote:
> > > Mathieu Desnoyers writes:
> > > 
> > > > This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
> > > > get_cycles_rate() are implemented.
> > > 
> > > [snip]
> > > 
> > > > +static inline cycles_t get_cycles_rate(void)
> > > > +{
> > > > +	return CLOCK_TICK_RATE;
> > > > +}
> > > 
> > > CLOCK_TICK_RATE is certainly wrong.  You want ppc_tb_freq (declared in
> > > asm/time.h).  Or tb_ticks_per_sec, since we seem to have two variables
> > > for exactly the same thing, for some reason. :)
> > > 
> > > Paul.
> > 
> > Ok, this should work better. Thanks !
> > 
> > Do you know if mtfb implies an instruction synchronization (isync) ? I
> > think that if it does not, the new get_cycles_barrier() might have to be
> > used at some locations in the kernel code if more precise timestamp
> > order is required.
> 
> You'll need to make a similar fix on sparc64.

I guess you are talking about using sparc64_get_clock_tick rather than
CLOCK_TICK_RATE ? I assume sparc64_get_clock_tick() done on any CPU will
return the same rate ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
