Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbZJGSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbZJGSLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759764AbZJGSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:11:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:38595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757954AbZJGSLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:11:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183DQ9UXCg3wc9GVTwhV/JlzxTNG7bmaP88iQbhFx
	kKDbycNGoozCGq
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910071910.53907.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <20091005072428.16ce40e4@infradead.org>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 20:10:40 +0200
Message-Id: <1254939040.7523.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 19:10 +0200, Frans Pop wrote:
> On Tuesday 06 October 2009, Frans Pop wrote:
> > I've checked for 2.6.31.1 now and iwlagn is listed high there too when
> > the system is idle, but with normal values of 60-100 ms. And phy0 has
> > normal values of below 10 ms.
> > I've now rebooted with today's mainline git; phy0 now frequently shows
> > with values of around 100 ms too (i.e. higher than last time).
> >
> > Both still go way down as soon as the system is given work to do.
> >
> > With a 5 second sleep I was unable to get any significant latencies (I
> > started perf on a latencytop refresh and did a manual refresh as it
> > finished to see what happened during the perf run). The perf run does
> > seem to affect the latencies.
> > I've uploaded a chart for a 10s sleep during which I got latencies of
> > 101ms for iwlagn and 77ms for phy0:
> > http://people.debian.org/~fjp/tmp/kernel/.
> 
> Mike privately sent me a script to try to capture the latencies with perf,
> but the perf output does not show any high latencies at all. It looks as if
> we may have found a bug in latencytop here instead.

Maybe.  I have a little perturbation measurement proggy which I just
fired up to verify both perf and latencytop's numbers here.  It's a dirt
simply cycle counter tool, which calibrates itself, sums perturbations
over a period of time and emit stats.  Here, all three are in violent
agreement wrt how long "pert" is waiting for cpu.

	-Mike

