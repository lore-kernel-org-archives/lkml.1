Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYIBVRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYIBVRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYIBVRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:17:03 -0400
Received: from www.tglx.de ([62.245.132.106]:47334 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYIBVRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:17:01 -0400
Date: Tue, 2 Sep 2008 23:16:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alok Kataria <akataria@vmware.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <1220380907.3929.10.camel@alok-dev1>
Message-ID: <alpine.LFD.1.10.0809022315090.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net>  <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>  <48BC2A03.9000104@lwfinger.net>  <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <1220380907.3929.10.camel@alok-dev1>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Alok Kataria wrote:
> On Tue, 2008-09-02 at 11:14 -0700, Thomas Gleixner wrote:
> > I think that information is enough to give us a pretty precice idea
> > when to discard the result. I'm currently looking at the hpet/pmtimer
> > values for comparison and I should have a patch for testing ready
> > later tonight.
> > 
> Sorry for joining the party this late...am still going through all my
> mails.
> 
> Ok, so from what I understand until now, we will calibrate TSC against
> PIT as was done in 32bit code and use that as default. If that fails to
> give any sane results we will fall back to calibrating against PM_timer
> or HPET ?
> Thomas has already explained the problem with 32bit calibration ( i.e.
> just against PIT and no checks for SMI's and all) but would like to
> point that this problem is lot more worse in virtualized environment,
> because we may fail to get sane values even from multiple loops of
> calibrating against PIT. 
> If we have a fall back mechanism to detect this SMI event, and then try
> calibrating against PM timer or HPET we should be good. 

I still keep the fallback against pmtimer/hpet alive.

Thanks,

	tglx
