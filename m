Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYHYP06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYHYP06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYHYP0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:26:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYHYP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:26:50 -0400
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
In-Reply-To: <20080825151645.GB6745@linux.vnet.ibm.com>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	 <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
	 <1219660496.8515.22.camel@twins> <20080825151645.GB6745@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 17:26:43 +0200
Message-Id: <1219678003.8515.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 08:16 -0700, Paul E. McKenney wrote:
> On Mon, Aug 25, 2008 at 12:34:56PM +0200, Peter Zijlstra wrote:
> > On Fri, 2008-08-22 at 16:29 -0700, Josh Triplett wrote:
> > 
> > > > @@ -26,8 +27,10 @@
> > > >   * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
> > > >   *
> > > >   * For detailed explanation of Read-Copy Update mechanism see -
> > > > - * 		Documentation/RCU
> > > > - *
> > > > + * 	Documentation/RCU
> > > > + * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > > > + * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > > > + * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> > > >   */
> > > 
> > > Why put these references here rather than in Documentation/RCU?  It
> > > seems easier to keep documentation up to date in one place.  If you
> > > think these represent a good "getting started" set of documents, how
> > > about a Documentation/RCU/ReadTheseFirst with links to them, or how
> > > about linking to them from whatisRCU.txt?
> > 
> > I actually like in code comments and 'documentation' more than
> > Documentation/ stuff. Mostly because Documentation/ is:
> >  - far away from the code
> >  - therefore, more easily bitrotted
> >  - and easily forgotten
> 
> I know!!!
> 
> #ifdef JOSH_TRIPLETT
>  * 	Documentation/RCU
>  * 	http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
>  * 	http://lwn.net/Articles/263130/ (What is RCU's Usage?)
>  * 	http://lwn.net/Articles/264090/ (What is RCU's API? + references)
> #elif PETER_ZIJLSTRA
>  * 	Documentation/RCU
> #endif
> 
> (Sorry, couldn't resist!!!)

But but but, you got the cases the wrong way around.. ;-)

> Seriously, I know where all the documentation is, as I wrote most of it.
> These comments are for you guys.  So, any thoughts on how I should
> resolve this?  My default is, as always, a coin flip.  ;-)

I guess we could do the 'this is how the concept works and can be used
like so and so' documentation in Documentation/

And the stuff that says 'this code does like so and so, because blah'
should stay near the code.

And in any case of doubt - stay near the code :-)

I always view Documentation/ as end user stuff (be that a kernel
programmer that needs to learn a new API, or userland folks or people
wanting to know what a certain feature is about).

