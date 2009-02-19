Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZBSWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZBSWJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZBSWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:09:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZBSWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:09:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Date: Thu, 19 Feb 2009 23:08:45 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Paul Collins <paul@burly.ondioline.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <200902191400.53528.rjw@sisk.pl> <1235080040.8805.47.camel@pasglop>
In-Reply-To: <1235080040.8805.47.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192308.46532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Benjamin Herrenschmidt wrote:
> On Thu, 2009-02-19 at 14:00 +0100, Rafael J. Wysocki wrote:
> > On Thursday 19 February 2009, Benjamin Herrenschmidt wrote:
> > > On Thu, 2009-02-19 at 21:27 +1300, Paul Collins wrote:
> > > > > Just for laughs I slapped together the following, which seems to do
> > > > the
> > > > > job, although not especially tidily.
> > > > 
> > > > And it doesn't even do the job.  Judging by this new trace, submitting
> > > > input events from the via-pmu resume function is still too early.
> > > > 
> > > What's up Thomas ? We can't call gettimeofday() from a sysdev
> > > suspend/resume ? That's a little bit too harsh no ?
> > 
> > Perhaps the ordering is wrong (ie. via-pmu resume happens bevore timekeeping
> > resume)?
> 
> In this case, maybe gtod should just return the frozen time (ie, last
> time at the time of suspend) rather than WARN ?

This might work, but there seem to be more problems like this (cpufreq vs
timekeeping for example).

I think we need a more general approach.

Thanks,
Rafael
