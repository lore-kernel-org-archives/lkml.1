Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbYAVKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbYAVKKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYAVKK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:10:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYAVKK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:10:28 -0500
Date: Tue, 22 Jan 2008 11:10:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Pinter =?iso-8859-1?B?KFBpbnTpciBPbGl26XIp?= 
	<oliver.pntr@gmail.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: konqueror deadlocks on 2.6.22
Message-ID: <20080122101014.GD5722@elte.hu>
References: <200801192114.41427.a1426z@gawab.com> <6101e8c40801191053j7e81988fm8aaf0a75fb8bd405@mail.gmail.com> <200801192357.13774.a1426z@gawab.com> <6101e8c40801191417k7906422chf657895152b61a2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6101e8c40801191417k7906422chf657895152b61a2d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:

> and then please update to CFS-v24.1
> http://people.redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.6.22.15-v24.1.patch

> > Yes with CFSv20.4, as in the log.
> >
> > It also hangs on 2.6.23.13

my feeling is that this is some sort of timing dependent race in 
konqueror/kde/qt that is exposed when a different scheduler is put in.

If it disappears with CFS-v24.1 it is probably just because the timings 
will change again. Would be nice to debug this on the konqueror side and 
analyze why it fails and how. You can probably tune the timings by 
enabling SCHED_DEBUG and tweaking /proc/sys/kernel/*sched* values - in 
particular sched_latency and the granularity settings. Setting wakeup 
granularity to 0 might be one of the things that could make a 
difference.

	Ingo
