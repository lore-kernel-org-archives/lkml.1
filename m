Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZEPB3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZEPB3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZEPB31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:29:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59819 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZEPB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:29:26 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep
 formorethan2.15 seconds
From: John Stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A0DBA9D.2050107@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
	 <1241744048.7518.132.camel@localhost.localdomain> <4A04584E.4020307@ti.com>
	 <1241830281.7297.21.camel@localhost.localdomain>  <4A0A07D6.90408@ti.com>
	 <1242172727.3462.55.camel@localhost>  <4A0AE3E3.5090304@ti.com>
	 <1242232872.9110.98.camel@jstultz-laptop>  <4A0B0939.5030008@ti.com>
	 <1242242497.9777.2.camel@jstultz-laptop> <4A0D99E0.3050306@ti.com>
	 <4A0DBA9D.2050107@ti.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 18:29:26 -0700
Message-Id: <1242437366.29511.208.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 13:55 -0500, Jon Hunter wrote:
> Jon Hunter wrote:
> > +	/*
> > +	 * If the result overflows, return the max value we can.
> > +	 */
> > +	if (overflow)
> > +		ret = LONG_MAX;
> > +	else
> > +		ret = (s64)((upper << 32) + lower);
> > +
> >   	return ret;
> >   }
> 
> Correction. Should have been LLONG_MAX and not LONG_MAX in the above. 
> See below.

As I said before, I don't think we want to go this path, but as an
aside, if we did want to catch and handle overflows (which would be bad
for timekeeping as time would seemingly stop increasing, instead we
really just want to ensure they never happen), you'd not want to return
LLONG_MAX, since that would be *way* too big (500 years of nanoseconds)!

Instead you'd probably want:  LLONG_MAX >> clocksource->shift

Which would better mimic the (cycles*mult) >> shift calculation.

But I think the outline I provided in my last email is the better
solution.

thanks
-john

