Return-Path: <linux-kernel-owner+w=401wt.eu-S1751362AbZGRMKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbZGRMKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZGRMKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:10:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZGRMKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:10:40 -0400
Date: Sat, 18 Jul 2009 14:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Andi Kleen <ak@suse.de>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090718120939.GC31007@elte.hu>
References: <1247873945.8334.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247873945.8334.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> Hey all,
> 
> 	After talking with some application writers who want very 
> fast, but not fine-grained timestamps, I decided to try to 
> implement a new clock_ids to clock_gettime(): 
> CLOCK_REALTIME_COARSE and CLOCK_MONOTONIC_COARSE which returns the 
> time at the last tick. This is very fast as we don't have to 
> access any hardware (which can be very painful if you're using 
> something like the acpi_pm clocksource), and we can even use the 
> vdso clock_gettime() method to avoid the syscall. The only trade 
> off is you only get low-res tick grained time resolution.
> 
> This isn't a new idea, I know Ingo pushed a patch (see commit 
> 5899a0f044f3c80e9f7262ec5bc7164773a4c28e) a little while ago that 
> made the vsyscall gettimeofday() return coarse grained time when 
> the vsyscall64 sysctrl was set to 2. However this affects all 
> applications on a system.

Note, that patch is an -rt commit, right? I.e. not yet upstream.

> With this method, applications can choose the proper 
> speed/granularity trade-off for themselves.
> 
> This is a first pass on this implementation, and while I did test 
> it, the box I tested it with did not have a glibc new enough to 
> utilize the vdso clock_gettime(), so there may still be issues 
> there. I'll find a newer box for testing shortly.
> 
> Any thoughts or feedback will be appreciated!

Looks good. I think we should offer both methods: your patch as an 
unconditional 'coarse time' approximator always available 
everywhere, plus the vsyscall redirector as well from -rt, to allow 
admins/users to tweak in a global way on apps that cannot be 
changed.

	Ingo
