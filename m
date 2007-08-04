Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXHDDAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXHDDAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXHDDAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:00:03 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1163 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXHDDAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:00:00 -0400
Date: Sat, 4 Aug 2007 05:00:22 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186185229.3153.11.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708040345530.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
  <1186170407.3153.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708032152060.1817@scrub.home>
 <1186185229.3153.11.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 3 Aug 2007, Arjan van de Ven wrote:

> > Actually the hrsleep() function would allow for submillisecond sleeps, 
> > which might be what some of the 450 users really want and they only use
> > msleep(1) because it's the next best thing.
> > A hrsleep() function is really what makes most sense from an API 
> > perspective.
> 
> I respectfully disagree. The power of msleep is that the unit of sleep
> time is in the name; so in your proposal it would be hr_msleep or
> somesuch. I much rather do the opposite in that case; make the "short"
> name be the best implementation of the requested behavior, and have
> qualifiers for allowing exceptions to that... least surprise and all
> that.

hr_msleep makes no sense. Why should we tie this interface to millisecond 
resolution?
Your suggested msleep_approx makes not much sense to me either, since 
neither interface guarantees anything and may "approximate" the sleep 
(and if the user is surprised by that something else already went wrong).
If you don't like the hrsleep name, we can also call it nanosleep and so 
match what we already do for userspace.


bye, Roman
