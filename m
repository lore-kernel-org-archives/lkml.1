Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbYEFCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbYEFCKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYEFCKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:10:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:53672 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbYEFCKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sHjAd7TJC+yNy7mXAQhzo2pUAu4SLXovCGq2Yfp2CzgAqDdBR40gZtr/vK/jEPHpPiib0n1D5wch6528pm6YJJV8BqhWsKW6RGn94J0IhZPzrL9l/3PuVCyqNioQVrTuU4TKGJ5IHy0mrROgEl+WWAfV6MRZFeDY1yF/y0bbNbY=
Date: Mon, 5 May 2008 23:13:23 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080506021321.GA4928@Pilar.virtua.com.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <1210031888.17132.85.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210031888.17132.85.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  5.May'08 at 16:58:08 -0700, Daniel Walker wrote:
> 
> On Mon, 2008-05-05 at 20:11 -0300, Carlos R. Mafra wrote:
> 
> > -	tmp = (u64)hpet_period << HPET_SHIFT;
> > -	do_div(tmp, FSEC_PER_NSEC);
> > -	clocksource_hpet.mult = (u32)tmp;
> > +	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
> >  
> 
> There's helper functions that should be used called clocksource_hz2mult
> and one called clocksource_khz2mult. I think they're more accurate than
> using div_sc.

Ok, but they take the frequency as the input while the "natural" variable
we have is the period, because that's what we get from the hardware (at
least for the HPET, if I understood it correctly).

If I want to use clocksource_hz2mult then I have
to do one more operation (to find the frequency) before calling it (and
that's what the other part of the patch which you didn't quote is
actually doing).

So the savings in my patch is due to using the period directly, and
not the frequency. That's what my idea was, so if you object then
my attempt was a failure and should be forgotten :-)

Or maybe I should create a clocksource_period2mult to replace 
clocksource_hz2mult and save the extra operation in more places too?




