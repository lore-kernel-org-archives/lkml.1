Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYCaQDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYCaQDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYCaQDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:03:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57606 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYCaQDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:03:33 -0400
Subject: Re: gettimeofday() jumping into the future
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Ricketts <tr@earth.li>, Michael Smith <msmith@xiph.org>,
       LKML <linux-kernel@vger.kernel.org>, Andy Wingo <wingo@fluendo.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0803311048170.3219@apollo.tec.linutronix.de>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
	 <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
	 <alpine.LFD.1.10.0803311048170.3219@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 09:03:27 -0700
Message-Id: <1206979407.6175.2.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-31 at 10:55 +0200, Thomas Gleixner wrote:
> 
> > +     if (cycle_now < clock->cycle_last)
> > +             return 0;
> > +
> 
> No, this breaks wrapping clocksources e.g. pmtimer. We need a
> different sanity check for that TSC crap.

Yea. If you're going to do that sort of logic (which requires a costly
cmpxchg as well), it should be done in the read() function of the
clocksource.

thanks
-john
 

