Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYCOFHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYCOFHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 01:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYCOFHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 01:07:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59711 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYCOFHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 01:07:04 -0400
Subject: Re: [PATCH 1/5] split clocksource adjustment from clockosurce mult
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803150526060.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150526060.1791@scrub.home>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 22:07:00 -0700
Message-Id: <1205557620.6173.5.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-15 at 05:28 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 14 Mar 2008, john stultz wrote:
> 
> > @@ -179,7 +181,7 @@ static inline cycle_t clocksource_read(struct clocksource *cs)
> >  static inline s64 cyc2ns(struct clocksource *cs, cycle_t cycles)
> >  {
> >  	u64 ret = (u64)cycles;
> > -	ret = (ret * cs->mult) >> cs->shift;
> > +	ret = (ret * (cs->mult + cs->mult_adj)) >> cs->shift;
> >  	return ret;
> >  }
> 
> This add an extra memory access and extra instruction to a code path, we 
> should keep as short as possible.
> I'd rather add a mult_raw or mult_org and use that for your next patch.

Yea, I played with that at first, but the functoinal duplication (two
values, both storing close to the same info) was ugly. 

I guess I could go back to mult_orig.

-john


