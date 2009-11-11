Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZKKTr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZKKTr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZKKTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:47:27 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43770 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632AbZKKTr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:47:26 -0500
Date: Wed, 11 Nov 2009 11:47:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
	functions
Message-ID: <20091111194734.GL8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1257892710.25443.9.camel@Joe-Laptop.home> <20091110225926.GA8424@linux.vnet.ibm.com> <1257894380.25443.16.camel@Joe-Laptop.home> <20091110234101.GB8424@linux.vnet.ibm.com> <1257901421.25443.34.camel@Joe-Laptop.home> <20091111014222.GE8424@linux.vnet.ibm.com> <1257910108.25443.40.camel@Joe-Laptop.home> <20091111045013.GG8424@linux.vnet.ibm.com> <20091111054138.GA19777@linux.vnet.ibm.com> <20091111070208.GA28716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111070208.GA28716@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 08:02:08AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Nov 10, 2009 at 08:50:13PM -0800, Paul E. McKenney wrote:
> > > On Tue, Nov 10, 2009 at 07:28:28PM -0800, Joe Perches wrote:
> > > > On Tue, 2009-11-10 at 17:42 -0800, Paul E. McKenney wrote:
> > > > > On Tue, Nov 10, 2009 at 05:03:41PM -0800, Joe Perches wrote:
> > > > > > So maybe rename rcutree_plugin.h to rcutree_plugin.c and
> > > > > > #include "rcutree_plugin.c" in rcutree.c instead.
> > > > > Hmmm...
> > > > 
> > > > Perhaps something like this:
> > > 
> > > While I do very much appreciate your time and attention to this...
> > > 
> > > My problem with this sort of thing is that when I tried it, it proved
> > > fragile.  Small changes required lots of rework of forward declarations.
> > > Putting it at the end makes it work very nicely -- the list of forward
> > > declarations doubles as documentation for the plugins, and the contents
> > > of kernel/rcutree_plugin.h (or .c or whatever, either way I end up
> > > violation about the same number of coding guidelines) is independent of
> > > rearrangements of kernel/rcutree.c.
> > > 
> > > The reason that I would really like to keep rcu_bootup_announce() as
> > > a function is that it makes it trivial to collect RCU-flavor-dependent
> > > boot-time information, if needed for some debugging effort.  If I pull
> > > the string out, this sort of thing becomes much more painful.
> > 
> > And, as noted in our offline conversation, you are absolutely right
> > that I need to add __init to both definitions of rcu_bootup_announce(),
> > which I will do, with your Suggested-by.
> > 
> > Fair enough?
> 
> Yep, the __init markers are fair enough - but otherwise i wouldnt overdo 
> this - a casual glance at rcutree_plugin.h shows that it's special, 
> contains an implementation that is included once into kernel/rcutree.c. 
> No need for header guards or a rename.

Sounds good, patch sent separately.  ;-)

							Thanx, Paul
