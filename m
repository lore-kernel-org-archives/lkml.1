Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbXFVNDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbXFVNDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXFVND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:03:28 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33321 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbXFVND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:03:27 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622123805.GA9770@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <20070622070948.GA21291@infradead.org>
	 <1182515542.5493.20.camel@localhost.localdomain>
	 <20070622123805.GA9770@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:58:44 -0400
Message-Id: <1182517124.5493.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 14:38 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > And this is something that might be fine for benchmarking, but not something
> > > we should put in.  Keeping two wildly different implementation of core
> > > functionality with very different behaviour around is quite bad.  Better
> > > kill tasklets once for all.
> > 
> > Honestly, I highly doubted that this would make it up to Linus's tree.
> 
> that's where it belongs - but it first needs the cleanups suggested by 
> Christoph.

I had the impression that he didn't want it in, but instead wanted each
driver to be changed separately.

> 
> > My aim was to get this into -mm, [...]
> 
> that would be the first step towards getting it upstream.
> 
> > and perhaps even turn on the tasklets-as-workqueues as default.
> 
> that is a hack that shouldnt be in the patch. People can unapply/apply a 
> patch just as well as they can flip a .config switch.

So should the patch be then to not even have the tasklet_softirq there
at all?  Have the patch simply replace the tasklets with workqueues, and
if someone doesn't like that, then they can simply remove the patch?

-- Steve


