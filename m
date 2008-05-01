Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbYEATsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbYEATsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764101AbYEATs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:48:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:3902 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbYEATs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:48:27 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: johnstul@us.ibm.com, ralf@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080501123245.d71245ad.akpm@linux-foundation.org>
References: <20080501173123.444094226@mvista.com>
	 <20080501123245.d71245ad.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 12:48:25 -0700
Message-Id: <1209671305.12461.262.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-01 at 12:32 -0700, Andrew Morton wrote:

> > +static inline u32 clocksource_hz2shift(u32 bits, u32 hz)
> > +{
> > +	u64 temp;
> > +
> > +	for (; bits > 0; bits--) {
> > +		temp = (u64) NSEC_PER_SEC << bits;
> > +		do_div(temp, hz);
> > +		if ((temp >> 32) == 0)
> > +			break;
> > +	}
> > +	return bits;
> > +}
> 
> If we expect this to have more than one callsite then it would be best to
> uninline it.
> 
> Unless we always expect it to be called from __init code, in which case
> it's best to inline it ;)

I expect it would always get called from __init flagged functions. The
clocksource can't get registed/used with out the shift and mult values. 

If we did uninline this one, we would have to do the other helpers too.
I imagine the use case is the same for all of them ..

Daniel

