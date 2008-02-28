Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYB1JJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYB1JJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYB1JJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:09:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYB1JJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:09:11 -0500
Date: Thu, 28 Feb 2008 10:08:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-ID: <20080228090847.GA1133@elte.hu>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228020808.3fd22f77.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> > i've queued up your patches in sched-devel.git
> 
> Before this patchset gets too far, I'd like to decide on whether to 
> adapt my suggestion to call that per-cpuset flag 'cpus_system' (or 
> anything else with 'cpu' in it, perhaps 'system_cpus' would be more 
> idiomatic), rather than the tad too generic 'system'.

yeah. In fact i'm not at all sure this is really a "system" thing - it's 
more of a "bootup" default.

once the system has booted up and the user is in a position to create 
cpusets, i believe the distinction and assymetry between any bootup 
cpuset and the other cpusets should vanish. The "bootup" cpuset is just 
a convenience container to handle everything that the box booted up 
with, and then we can shrink it (without having to enumerate every PID 
and every irq and other resource explicitly) to make place for other 
cpusets.

maybe it's even more idomatic to call it "set0" and just create a 
/dev/cpuset/set0/ directory for it and making it an explicit cpuset - 
instead of the hardcoded /dev/cpusets/system thing? Do you have any 
established naming scheme for cpusets that we could follow here?

> People doing 'ls /dev/cpuset' should be able to half-way guess what 
> things do, just from their name.

oh, certainly. This is at the earliest v2.6.26 material - but now it at 
least looks clean conceptually, fits more nicely into cpusets instead of 
being a bolted-on thing.

	Ingo
