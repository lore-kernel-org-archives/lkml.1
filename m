Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZHKRHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZHKRHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZHKRHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:07:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:51803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbZHKRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:07:40 -0400
Date: Tue, 11 Aug 2009 09:58:19 -0700
From: Greg KH <gregkh@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, manfred@colorfullife.com,
       Ihno Krumreich <ihno@suse.de>
Subject: Re: [BUG] race of RCU vs NOHU
Message-ID: <20090811165819.GA25981@suse.de>
References: <20090807151529.2806b8b4@skybase>
 <20090807142957.GB6700@linux.vnet.ibm.com>
 <20090810142535.3e685109@skybase>
 <20090810150807.GA6791@linux.vnet.ibm.com>
 <20090811125653.12c35ee8@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811125653.12c35ee8@skybase>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 12:56:53PM +0200, Martin Schwidefsky wrote:
> On Mon, 10 Aug 2009 08:08:07 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Mon, Aug 10, 2009 at 02:25:35PM +0200, Martin Schwidefsky wrote:
> > > On Fri, 7 Aug 2009 07:29:57 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Fri, Aug 07, 2009 at 03:15:29PM +0200, Martin Schwidefsky wrote:
> > > > > Hi Paul,
> > > > > I analysed a dump of a hanging 2.6.30 system and found what I think is
> > > > > a bug of RCU vs NOHZ. There are a number of patches ontop of that
> > > > > kernel but they should be independent of the bug.
> > > > > 
> > > > > The systems has 4 cpus and uses classic RCU. cpus #0, #2 and #3 woke up
> > > > > recently, cpu #1 has been sleeping for 5 minutes, but there is a pending
> > > > > rcu batch. The timer wheel for cpu #1 is empty, it will continue to
> > > > > sleep for NEXT_TIMER_MAX_DELTA ticks.
> > > > 
> > > > Congratulations, Martin!  You have exercised what to date has been a
> > > > theoretical bug identified last year by Manfred Spraul.  The fix is to
> > > > switch from CONFIG_RCU_CLASSIC to CONFIG_RCU_TREE, which was added in
> > > > 2.6.29.
> > > > 
> > > > Of course, if you need to work with an old kernel version, you might
> > > > still need a patch, perhaps for the various -stable versions.  If so,
> > > > please let me know -- otherwise, I will focus forward on CONFIG_RCU_TREE
> > > > rather than backwards on CONFIG_RCU_CLASSIC.
> > > 
> > > SLES11 is 2.6.27 and uses classic RCU. The not-so theoretical bug is
> > > present there and I think it needs to be fixed :-/
> > 
> > I was afraid of that.  ;-)
> > 
> > Given that there are some other theoretical bugs in Classic RCU involving
> > interrupts and CONFIG_NO_HZ, would backporting CONFIG_TREE_RCU make more
> > sense than playing whack-a-mole on Classic RCU bugs?
> 
> Fine with me but I don't know if SuSE/Novell is willing to accept such a
> big change for an existing distribution. I've put Ihno and Greg on Cc.

File a bug in bugzilla.novell.com with the problem and the proper people
at Novell will evaluate it there.

thanks,

greg k-h
