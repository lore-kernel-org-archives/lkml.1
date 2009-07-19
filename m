Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZGSGM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZGSGM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 02:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZGSGMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 02:12:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:54179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZGSGMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 02:12:55 -0400
Date: Sat, 18 Jul 2009 23:14:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Chris Snook <chris.snook@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090718231429.7ddea95f@infradead.org>
In-Reply-To: <13a12eea0907182000v654e38a5l265ae5bdadb1a175@mail.gmail.com>
References: <1247873945.8334.67.camel@localhost.localdomain>
	<13a12eea0907182000v654e38a5l265ae5bdadb1a175@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009 23:00:55 -0400
Chris Snook <chris.snook@gmail.com> wrote:

> On Fri, Jul 17, 2009 at 7:39 PM, john stultz<johnstul@us.ibm.com>
> wrote:
> > -       if (likely(gtod->sysctl_enabled && gtod->clock.vread))
> > +       if (likely(gtod->sysctl_enabled))
> 
> This irks me.  If the sysctl is enabled and the codepath is getting
> used often enough that we care about performance, branch prediction
> should do the right thing without compiler hints.  On the other hand,
> if the sysctl is disabled, and the compiler is telling the cpu to
> ignore its branch predictor, it'll hurt.  I don't think we should be
> wrapping (un)likely annotations around configuration options, unless
> we're biasing against debug conditions where we definitely don't care
> about performance.  The patch is certainly no worse than the existing
> code, but while we have the hood up, it might be nice to remove the
> annotation, unless we're sure that it does no harm, and does some
> good.

it's on x86.. likely/unlikely don't impact the CPU (since there are no
"ignore the branch predictor" hints), only the code placement.....

(and that's probably a good thing; CPU branch predictors are pretty
good, I'd not be surprised if they're at least as good as the
programmers who think how they code is used)


--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
