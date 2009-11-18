Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZKRKwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZKRKwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZKRKwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:52:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZKRKwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:52:44 -0500
Date: Wed, 18 Nov 2009 11:52:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091118105246.GA19027@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost> <20091118042516.GC21813@wotan.suse.de> <alpine.LFD.2.00.0911181110430.24119@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911181110430.24119@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 11:19:14AM +0100, Thomas Gleixner wrote:
> Nick,
> 
> On Wed, 18 Nov 2009, Nick Piggin wrote:
> > > So yes, on -rt, the overhead from lock contention is way way worse then
> > > any extra atomic ops. :)
> > 
> > How about overhead for an uncontended lock? Ie. is the problem caused
> > because lock *contention* issues are magnified on -rt, or is it
> > because uncontended lock overheads are higher? Detailed callgraph
> > profiles and lockstat of +/-atomic case would be very interesting.
> 
> In the uncontended case we have the overhead of calling might_sleep()
> before we acquire the lock with cmpxchg(). The uncontended unlock is a
> cmpxchg() as well.

OK well then you don't reduce atomic ops in the lookup/dput fastpaths
by protecting d_count with d_lock, so single threaded performance should
not hurt by using atomic_t here.

I'll keep this in mind. As I said, I still need to do some more work on
the fast path lookup and other single threaded performance. In the worst
case that mainline really doesn't like atomic_t there it probably isn't
hard to make some small wrappers for -rt.

 
> I don't think that this is significant overhead and we see real lock
> contention issues magnified by at least an order of magnitude.

Yeah I'm sure you're right. I'm just interested where it is coming from
in -rt.

