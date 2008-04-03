Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYDCG3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYDCG3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYDCG2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:28:52 -0400
Received: from www.tglx.de ([62.245.132.106]:40685 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYDCG2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:28:51 -0400
Date: Thu, 3 Apr 2008 08:28:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
cc: John Stultz <johnstul@us.ibm.com>, Tim Ricketts <tr@earth.li>,
       Michael Smith <msmith@xiph.org>, LKML <linux-kernel@vger.kernel.org>,
       Andy Wingo <wingo@fluendo.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: gettimeofday() jumping into the future
In-Reply-To: <200804030157.32086.fzu@wemgehoertderstaat.de>
Message-ID: <alpine.LFD.1.10.0804030827180.3219@apollo.tec.linutronix.de>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <1206979407.6175.2.camel@jstultz-laptop> <alpine.LFD.1.10.0804021254420.3219@apollo.tec.linutronix.de> <200804030157.32086.fzu@wemgehoertderstaat.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Karsten Wiese wrote:
> > To prevent this TSC specific wreckage we need to compare the TSC value
> > against the reference value and return the latter when it is larger
> > than the actual TSC value.
> 
> Last paragraph IMO should be:
> 	To prevent this TSC specific wreckage we need to substract the
> 	reference value from the TSC value, interpret the result as
> 	signed. If the interpreted result is negative, return the reference
> 	value, else the TSC Value.
> Your patch misses the corner case where TSC value is < reference _and_ valid
> at TSC wrap around.

In about 200 years on a 3Ghz box.
 
> The access to the reference value needs a (the xtime ?) lock on 32bit, no?

The readout is under xtime lock anyway.

Thanks,

	tglx
