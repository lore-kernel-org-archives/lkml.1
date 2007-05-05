Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbXEEWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbXEEWFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbXEEWFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:05:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:60202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965AbXEEWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:05:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: tglx@linutronix.de
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Date: Sun, 6 May 2007 00:05:37 +0200
User-Agent: KMail/1.9.6
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
References: <1178314144.6094.7.camel@localhost.localdomain> <200705051924.14258.ak@suse.de> <1178392501.31213.18.camel@localhost.localdomain>
In-Reply-To: <1178392501.31213.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705060005.38122.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2007 21:15:01 Thomas Gleixner wrote:
> On Sat, 2007-05-05 at 19:24 +0200, Andi Kleen wrote:
> > >  	if (!is_hpet_capable())
> > > @@ -278,6 +279,14 @@ int __init hpet_enable(void)
> > >  	/* Start the counter */
> > >  	hpet_start_counter();
> > >  
> > > +	/* Verify whether hpet counter works */
> > > +	t1 = hpet_read();
> > > +	udelay(50);
> > 
> > Are you sure udelay is calibrated at this point? I didn't think so.
> > In fact it needs the external clocks and it's a chicken and egg problem.
> 
> Oops. You are right. OTOH it does not matter whether it is accurate or
> not.

It might be very short if you're very unlucky and the CPU is fast
and then trigger the check incorrectly.

-Andi
