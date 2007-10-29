Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXJ2Ukm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXJ2Ukm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXJ2Ukf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:40:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:57388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbXJ2Uke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:40:34 -0400
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org, niv@us.ibm.com
In-Reply-To: <20071029202617.GF8824@linux.vnet.ibm.com>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
	 <1193688468.9928.30.camel@pasglop>
	 <20071029202617.GF8824@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 07:37:50 +1100
Message-Id: <1193690270.9928.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 13:26 -0700, Paul E. McKenney wrote:
> 
> > I see a lot of case where you add preempt_disable/enable around
> areas
> > that have the PTE lock held...
> > 
> > So in -rt, spin_lock doesn't disable preempt ? I'm a bit worried...
> > there are some strong requirements that anything within that lock is
> not
> > preempted, so zap_pte_ranges() is the obvious ones but all of them
> would
> > need to be addressed.
> 
> Right in one!  One of the big changes in -rt is that spinlock critical
> sections (and RCU read-side critical sections, for that matter) are
> preemptible under CONFIG_PREEMPT_RT.
> 
> And I agree that this patchset will have missed quite a few places
> where
> additional changes are required.  Hence the word "including" above,
> rather
> than something like "specifically".  ;-)

Ok, well, I'm pretty familiar with that MM code since I wrote a good
deal of the current version so I'll try to spend some time with your
patch have a look. It may have to wait for next week though, but feel
free to ping me if you don't hear back, in case it falls through the
hole in my brain :-)

Ben.


