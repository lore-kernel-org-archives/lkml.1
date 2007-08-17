Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXHQUMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXHQUMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXHQUMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:12:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60708 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbXHQUMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:12:10 -0400
Date: Fri, 17 Aug 2007 13:12:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070817201205.GJ8464@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46C55E90.7010407@yahoo.com.au> <alpine.LFD.0.999.0708171431150.3666@enigma.security.iitk.ac.in> <46C56ADF.8010501@cyberone.com.au> <alpine.LFD.0.999.0708171612440.3666@enigma.security.iitk.ac.in> <46C59717.4020108@cyberone.com.au> <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org> <46C5EDF9.3090507@nortel.com> <1187376873.2615.2.camel@laptopd505.fenrus.org> <20070817194924.GG8464@linux.vnet.ibm.com> <1187380142.2615.6.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187380142.2615.6.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 12:49:00PM -0700, Arjan van de Ven wrote:
> 
> On Fri, 2007-08-17 at 12:49 -0700, Paul E. McKenney wrote:
> > > > What about reading values modified in interrupt handlers, as in your 
> > > > "random" case?  Or is this a bug where the user of atomic_read() is 
> > > > invalidly expecting a read each time it is called?
> > > 
> > > the interrupt handler case is an SMP case since you do not know
> > > beforehand what cpu your interrupt handler will run on.
> > 
> > With the exception of per-CPU variables, yes.
> 
> if you're spinning waiting for a per-CPU variable to get changed by an
> interrupt handler... you have bigger problems than "volatile" ;-)

That would be true, if you were doing that.  But you might instead be
simply making sure that the mainline actions were seen in order by the
interrupt handler.  My current example is the NMI-save rcu_read_lock()
implementation for realtime.  Not the common case, I will admit, but
still real.  ;-)

						Thanx, Paul
