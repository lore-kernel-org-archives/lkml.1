Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbXCQMpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbXCQMpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965217AbXCQMpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:45:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCQMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:45:40 -0400
Date: Sat, 17 Mar 2007 13:44:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: jos poortvliet <jos@mijnkamer.nl>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RSDL v0.31
Message-ID: <20070317124458.GA32301@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <1174112768.3144.8.camel@entropy> <20070317075615.GC13685@elte.hu> <200703171207.15221.jos@mijnkamer.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703171207.15221.jos@mijnkamer.nl>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* jos poortvliet <jos@mijnkamer.nl> wrote:

> Op Saturday 17 March 2007, schreef Ingo Molnar:
> > so it is not at all clear to me that RSDL is indeed an improvement, 
> > if it does not have comparable auto-nice properties.
> 
> Wasn't the point of RSDL to get rid of the auto-nice, because it 
> caused starvation, unpredictable behaviour and other problems?

it doesnt really get rid of it, it replaces it with another mechanism 
that is fundamentally unfair too.

RSDL has _another_, albeit more hidden "auto-nice" behavior: this time 
expressed not via the plain manipulation of priorities based on the 
sleep average, but expressed via the quota-depletion flux of tasks over 
time, fed into a complex dance of rotating priorities - which 
quota-depletion flux is in essence a sleep average too, just more 
derived and more hardcoded.

or looking at it from another angle, code size:

   text    data     bss     dec     hex filename
  15750      24    6008   21782    5516 sched.o.vanilla
  15960     360    6336   22656    5880 sched.o.rsdl

there's no reduction in complexity, it just moved elsewhere.

	Ingo
