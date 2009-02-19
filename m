Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZBSVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZBSVXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZBSVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:23:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZBSVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:23:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Date: Thu, 19 Feb 2009 22:23:04 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Collins <paul@burly.ondioline.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <1235032710.8805.37.camel@pasglop> <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192223.05361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Thomas Gleixner wrote:
> On Thu, 19 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> > On Thu, 2009-02-19 at 21:27 +1300, Paul Collins wrote:
> > > > Just for laughs I slapped together the following, which seems to do
> > > the
> > > > job, although not especially tidily.
> > > 
> > > And it doesn't even do the job.  Judging by this new trace, submitting
> > > input events from the via-pmu resume function is still too early.
> > > 
> > What's up Thomas ? We can't call gettimeofday() from a sysdev
> > suspend/resume ? That's a little bit too harsh no ?
> 
> Well, harsh or not is not the question here. 
> 
> Fact is that you call gettimeofday() _before_ the timekeeping code has
> resumed.
> 
> That's a simple ordering problem. timekeeping is in the sysdev class
> as well and it's not the only sysdev which has explicit ordering
> requirements.

Do we need suspend-resume priorities for sysdevs?  Such that sysdevs
with a higher priority will always be suspended earlier and resumed later
than sysdevs with lower priority (or the other way around)?

Rafael
