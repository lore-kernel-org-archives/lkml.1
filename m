Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0BBH30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:29:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0BBH3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:29:20 -0500
Date: Tue, 2 Feb 2010 08:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100202072902.GA29715@elte.hu>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-4-git-send-email-dzickus@redhat.com>
 <1264690494.4283.2103.camel@laptop>
 <20100128154448.GV4472@redhat.com>
 <20100129081227.GK14636@elte.hu>
 <20100201185218.GC3062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201185218.GC3062@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Fri, Jan 29, 2010 at 09:12:27AM +0100, Ingo Molnar wrote:
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > On Thu, Jan 28, 2010 at 03:54:54PM +0100, Peter Zijlstra wrote:
> > > > On Wed, 2010-01-27 at 15:03 -0500, Don Zickus wrote:
> > > > >
> > > > > These are the bits that enable the new nmi_watchdog and safely 
> > > > > isolate the old nmi_watchdog.  Only one or the other can run, not 
> > > > > both at the same time.
> > > > 
> > > > perf disables the lapic watchdog when it wants the pmu, so there 
> > > > shouldn't be a problem having both built in.
> > > 
> > > Yes it does disable but does not prevent nmi_watchdog_tick from running 
> > > nor the /proc interface from being loaded.  So perhaps my description 
> > > isn't very good.  The idea with the new watchdog was to re-use some of 
> > > the bits of the old one, but having them both compiled in seemed to 
> > > stomp on each other.  That is what I was trying to prevent.
> > > 
> > > I can certainly change the behaviour, just makes the code a little more 
> > > messy I think.
> > 
> > I think that's a good idea - and i think we want to be bold and just have 
> > the new code run seemlessly. (and fix bugs, if any.)
> 
> Ok.  I guess I am confused what you are suggesting here, to do as Peter 
> suggested and run both at the same time?

I dont think we want to run old and new code at once, the old NMI watchdog 
code is really a hardcoded minimal PMU driver generating a cycles based NMI 
tick once per second.

> > What do you think?
> 
> I will need to give you an updated patch that properly sets the frequency 
> of the NMI and I probably should still implement a code path that uses the 
> software perf counters in the cases where the hardware perf counters are 
> not available.
> 
> It seems like you are ok with my approach.  If that is so, I can test on 
> more machines to iron out some more bugs.  Or did you want to take my 
> patches as is and have me throw fixes on top?

Well, all known bugs/showstoppers should be fixed - but otherwise if you 
think it works fine we can certainly apply it and then iterate it from that 
point on to increase coverage and add features.

	Ingo
