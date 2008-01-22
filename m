Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYAVT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYAVT2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYAVT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:28:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbYAVT2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:28:06 -0500
Date: Tue, 22 Jan 2008 20:27:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Rescheduling interrupts
Message-ID: <20080122192744.GB3218@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr> <200801221455.16814.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu> <200801221755.56470.caglar@pardus.org.tr> <20080122160557.GA31831@elte.hu> <1201021429.14436.45.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201021429.14436.45.camel@cinder.waste.org>
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


* Matt Mackall <mpm@selenic.com> wrote:

> > amarokapp does wake up threads every 20 microseconds - that could 
> > explain it. It's probably Xorg running on one core, amarokapp on the 
> > other core. That's already 100 reschedules/sec.
> 
> That suggests we want an "anti-load-balancing" heuristic when CPU 
> usage is very low. Migrating everything onto one core when we're close 
> to idle will save power and probably reduce latencies.

that would probably be the case if it's multiple sockets - but for 
multiple cores exactly the opposite is true: the sooner _both_ cores 
finish processing, the deeper power use the CPU can reach. So effective 
and immediate spreading of workloads amongst multiple cores - especially 
with shared L2 caches where the cost of migration is low, helps power 
consumption. (and it obviously helps latencies and bandwith)

	Ingo
