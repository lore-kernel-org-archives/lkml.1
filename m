Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbZEMJla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbZEMJla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZEMJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:41:20 -0400
Received: from av-gw2.cc.tut.fi ([130.230.130.111]:60794 "EHLO
	av-gw2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZEMJlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:41:20 -0400
X-Greylist: delayed 1064 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 05:41:19 EDT
X-AuditID: 82e6826f-aab96bb0000003e2-77-4a0a95bf9981 
Date: Wed, 13 May 2009 12:41:19 +0300
From: Petri Kaukasoina <kaukasoina704m93hd7@sci.fi>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
Message-ID: <20090513094119.GB22832@elektroni.phys.tut.fi>
Mail-Followup-To: john stultz <johnstul@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
	linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
	zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
References: <1242094321.7214.156.camel@localhost.localdomain> <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <1242167171.3462.13.camel@localhost> <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain> <1242169366.3462.26.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242169366.3462.26.camel@localhost>
User-Agent: Mutt/1.4.2.3i
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 04:02:46PM -0700, john stultz wrote:
> A neat idea from Miroslav Lichvar: Round the TSC calibration results to
> the nearest 100ppm. Although I suspect we already see variations beyond
> 100ppm, so some tweaking would probably be necessary. I'll be looking at
> this option soon.

This does not sound good. Say, e.g., the variations were 40 ppm. Then, with
luck, for some hardware you can get rid of the variations completely. But,
if the average value for some hardware is near the value where you decide
either to round up or down, it will amplify the variation to 100 ppm. I
think you can't reduce the average of the variations for an ensemble of
computers this way.

> 2) Provide a workaround (that doesn't create some sort of userland API
> we have to manage forever) for users who really care about the
> super-fine details of tsc calibration and its interactions with NTP.
> 
> This patch only provides #2 above.

I have used this method on my campus ntp time servers for over a year now. I
just didn't know how to make a command line parameter, so I just wrote a
constant value to cpu_khz in tsc.c, instead. The command line option is much
better, of course.

-Petri
