Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZBSUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZBSUSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZBSUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:17:58 -0500
Received: from www.tglx.de ([62.245.132.106]:32789 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZBSUR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:17:58 -0500
Date: Thu, 19 Feb 2009 21:17:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Paul Collins <paul@burly.ondioline.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
In-Reply-To: <1235032710.8805.37.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>  <sWhNs83kKPE.A.p4D.L20jJB@chimera>  <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>  <87hc2u26m5.fsf@burly.wgtn.ondioline.org>  <1234775410.26036.122.camel@pasglop> 
 <87d4di1wwr.fsf@burly.wgtn.ondioline.org>  <87r61uzv95.fsf@burly.wgtn.ondioline.org> <1235032710.8805.37.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Benjamin Herrenschmidt wrote:

> On Thu, 2009-02-19 at 21:27 +1300, Paul Collins wrote:
> > > Just for laughs I slapped together the following, which seems to do
> > the
> > > job, although not especially tidily.
> > 
> > And it doesn't even do the job.  Judging by this new trace, submitting
> > input events from the via-pmu resume function is still too early.
> > 
> What's up Thomas ? We can't call gettimeofday() from a sysdev
> suspend/resume ? That's a little bit too harsh no ?

Well, harsh or not is not the question here. 

Fact is that you call gettimeofday() _before_ the timekeeping code has
resumed.

That's a simple ordering problem. timekeeping is in the sysdev class
as well and it's not the only sysdev which has explicit ordering
requirements.

Thanks,

	tglx
