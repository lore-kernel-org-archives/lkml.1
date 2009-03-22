Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZCVQxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZCVQxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZCVQxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:53:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45035 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZCVQx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:53:28 -0400
Date: Sun, 22 Mar 2009 09:53:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090322165324.GH7148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090320111354.679ab53d@infradead.org> <20090321012746.GM6698@linux.vnet.ibm.com> <20090321125115.0a76ac27@infradead.org> <49C54D60.80306@cosmosbay.com> <20090321210745.GE7148@linux.vnet.ibm.com> <20090321204045.4a9022fd@infradead.org> <20090322043838.GF7148@linux.vnet.ibm.com> <20090321215109.717a3f12@infradead.org> <20090322051822.GG7148@linux.vnet.ibm.com> <20090321225318.5b25f0a7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321225318.5b25f0a7@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 10:53:18PM -0700, Arjan van de Ven wrote:
> On Sat, 21 Mar 2009 22:18:22 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > I'm measuring the time that the following code takes:
> > > 
> > >         init_completion(&rcu.completion);
> > >         /* Will wake me after RCU finished. */
> > >         call_rcu(&rcu.head, wakeme_after_rcu);
> > >         /* Wait for it. */
> > >         wait_for_completion(&rcu.completion);
> > > 
> 
> > 
> > No, my confusion -- I misread as 2700 milliseconds rather than 2700
> > -microseconds-.  2700 microseconds (or 2.7 milliseconds) is in the
> > expected range for synchronize_rcu() on an HZ=1000 system.  2.7
> > seconds would of course be way out of line.
> 
> > > > If the former, exactly which kernel are you using?  The single-CPU
> > > > optimization was added in 2.6.29-rc7, commit ID a682604838.
> > > 
> > > a bit after -rc8, specifically  commit
> > > 5bee17f18b595937e6beafeee5197868a3f74a06
> > 
> > How many synchronize_rcu() calls are you seeing on the boot path?
> 
> I see 20 that hit the above code path (eg ones that wait) until
> userspace starts.

So with well-behaved readers, the full sequence would be worth
something like 50-60 milliseconds.

> > Also, are you running with NO_HZ=y?
> 
> of course...  is there any other way ? ;-)

Well, if it does become necessary to make common-case no-readers
execution of synchronize_rcu() go faster, you certainly have made the
correct choice.  ;-)

						Thanx, Paul
