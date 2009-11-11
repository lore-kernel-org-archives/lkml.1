Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZKKHCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZKKHCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZKKHCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:02:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZKKHCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:02:19 -0500
Date: Wed, 11 Nov 2009 08:02:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
 functions
Message-ID: <20091111070208.GA28716@elte.hu>
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
 <1257892710.25443.9.camel@Joe-Laptop.home>
 <20091110225926.GA8424@linux.vnet.ibm.com>
 <1257894380.25443.16.camel@Joe-Laptop.home>
 <20091110234101.GB8424@linux.vnet.ibm.com>
 <1257901421.25443.34.camel@Joe-Laptop.home>
 <20091111014222.GE8424@linux.vnet.ibm.com>
 <1257910108.25443.40.camel@Joe-Laptop.home>
 <20091111045013.GG8424@linux.vnet.ibm.com>
 <20091111054138.GA19777@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111054138.GA19777@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Nov 10, 2009 at 08:50:13PM -0800, Paul E. McKenney wrote:
> > On Tue, Nov 10, 2009 at 07:28:28PM -0800, Joe Perches wrote:
> > > On Tue, 2009-11-10 at 17:42 -0800, Paul E. McKenney wrote:
> > > > On Tue, Nov 10, 2009 at 05:03:41PM -0800, Joe Perches wrote:
> > > > > So maybe rename rcutree_plugin.h to rcutree_plugin.c and
> > > > > #include "rcutree_plugin.c" in rcutree.c instead.
> > > > Hmmm...
> > > 
> > > Perhaps something like this:
> > 
> > While I do very much appreciate your time and attention to this...
> > 
> > My problem with this sort of thing is that when I tried it, it proved
> > fragile.  Small changes required lots of rework of forward declarations.
> > Putting it at the end makes it work very nicely -- the list of forward
> > declarations doubles as documentation for the plugins, and the contents
> > of kernel/rcutree_plugin.h (or .c or whatever, either way I end up
> > violation about the same number of coding guidelines) is independent of
> > rearrangements of kernel/rcutree.c.
> > 
> > The reason that I would really like to keep rcu_bootup_announce() as
> > a function is that it makes it trivial to collect RCU-flavor-dependent
> > boot-time information, if needed for some debugging effort.  If I pull
> > the string out, this sort of thing becomes much more painful.
> 
> And, as noted in our offline conversation, you are absolutely right
> that I need to add __init to both definitions of rcu_bootup_announce(),
> which I will do, with your Suggested-by.
> 
> Fair enough?

Yep, the __init markers are fair enough - but otherwise i wouldnt overdo 
this - a casual glance at rcutree_plugin.h shows that it's special, 
contains an implementation that is included once into kernel/rcutree.c. 
No need for header guards or a rename.

	Ingo
