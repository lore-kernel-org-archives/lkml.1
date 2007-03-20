Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXCTSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXCTSEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXCTSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:04:39 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26346 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXCTSEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:04:38 -0400
Subject: Re: [PATCH] time : SMP friendly alignment of struct clocksource
From: Daniel Walker <dwalker@mvista.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1174413482.17430.1.camel@localhost>
References: <20070320110936.1e445e6e.dada1@cosmosbay.com>
	 <1174413482.17430.1.camel@localhost>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 11:04:22 -0700
Message-Id: <1174413862.3101.185.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 10:58 -0700, john stultz wrote:

> >  	/* timekeeping specific data, ignore */
> > -	cycle_t cycle_last, cycle_interval;
> > -	u64 xtime_nsec, xtime_interval;
> > +	cycle_t cycle_interval;
> > +	u64	xtime_interval;
> > +	/*
> > +	 * Second part is written at each timer interrupt
> > +	 * Keep it in a different cache line to dirty no
> > +	 * more than one cache line.
> > +	 */
> > +	cycle_t cycle_last ____cacheline_aligned_in_smp;
> > +	u64 xtime_nsec;
> >  	s64 error;

What was the motivation for having these (cycle_last for example) in the
clocksource structure. I recall them being added in there at one point,
but I'm not sure why.. Specifically the ones that are updated often.

Daniel

