Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZFBQWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZFBQWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZFBQWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:22:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60018 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZFBQWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:22:32 -0400
Date: Tue, 2 Jun 2009 18:22:08 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, John Stultz <johnstul@us.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
	convergence
Message-ID: <20090602162208.GA15696@localhost>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org> <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org> <1243542817.29511.523.camel@jstultz-laptop> <20090601232223.GH749@elte.hu> <1243900716.11263.42.camel@jstultz-laptop> <4A246D0B.40204@redhat.com> <20090602002039.GA16410@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602002039.GA16410@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 02:20:39AM +0200, Ingo Molnar wrote:
> > Would this not be true already, because the convergence of Linux 
> > system suddenly became a lot slower in 2.6.19?
> >
> > Damned if we do, damned if we don't - except the new behaviour 
> > introduced by your patches is nicer.
> 
> Not just that - but there's calibration noise during bootup that can 
> cause randomly distributed recalibrations as well. So other hosts in 
> a mixed environment will see inconsistencies anyway, after every 
> bootup.
> 
> NTP is all about being able to be resilient against time noise and 
> being able to sync up to a common time base ASAP.

There has to be a compromise between frequency and offset noise. When
SHIFT_PLL is set to 2 the frequency noise will be higher and that will
have a negative impact on the long-term ability to keep the clock
accurate. The error will grow faster when network connection is
suspended.

The PLL response can be configured to be the same as the proposed
SHIFT_PLL 2 by decreasing the time constant value in adjtimex
structure, so I'd rather keep following the NTP specification and
control it from userspace if necessary.

As for the calibration issue, would it be possible to export the
information that an instable clocksource is used and when was the last
time it was calibrated? Then we'd know when the drift file should not
be trusted and let NTP calculate the frequency directly (it takes
about 15 minutes).

-- 
Miroslav Lichvar
