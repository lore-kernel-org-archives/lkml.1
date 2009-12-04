Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZLDKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZLDKGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZLDKGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:06:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:57566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752200AbZLDKGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:06:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18MTMB2U1wM+IzWsKlDmG+ws87wAGG3U93xor1IiK
	mlRWXReX3Viv4x
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
From: Mike Galbraith <efault@gmx.de>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B18D66E.8020905@suse.de>
References: <4B18D66E.8020905@suse.de>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 11:06:27 +0100
Message-Id: <1259921187.15613.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 14:59 +0530, Suresh Jayaraman wrote:
> The newly introduced GENTLE_FAIR_SLEEPERS does not seem to have any
> effect without FAIR_SLEEPERS. Fix sysctl.sched_features to reflect
> this. Without this change, a user who sets GENTLE_FAIR_SLEEPERS
> without FAIR_SLEEPERS would assume gentle sleeper fairness which
> is not guaranteed.

IMHO, these dependencies belong in documentation, not enforcement code.

Same applies for LAST_BUDDY, meaningless without WAKEUP_PREEMPT.
SYNC_MORE, SYNC_LESS + AFFINE_WAKEUPS etc.

Bottom line for all button poking and knob turning is you'd better make
sure you know what button/knob does, and what other things may depend on
it before messing with it, lest you get a nasty surprise.

	-Mike

