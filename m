Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZBSVr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZBSVr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZBSVru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:47:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:59323 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbZBSVru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:47:50 -0500
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Collins <paul@burly.ondioline.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200902191400.53528.rjw@sisk.pl>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <87r61uzv95.fsf@burly.wgtn.ondioline.org>
	 <1235032710.8805.37.camel@pasglop>  <200902191400.53528.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 08:47:20 +1100
Message-Id: <1235080040.8805.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 14:00 +0100, Rafael J. Wysocki wrote:
> On Thursday 19 February 2009, Benjamin Herrenschmidt wrote:
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
> Perhaps the ordering is wrong (ie. via-pmu resume happens bevore timekeeping
> resume)?

In this case, maybe gtod should just return the frozen time (ie, last
time at the time of suspend) rather than WARN ?

Ben.


