Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXEETM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXEETM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXEETM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:12:27 -0400
Received: from www.osadl.org ([213.239.205.134]:39760 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932985AbXEETM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:12:26 -0400
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200705051924.14258.ak@suse.de>
References: <1178314144.6094.7.camel@localhost.localdomain>
	 <1178321228.6094.34.camel@localhost.localdomain>
	 <1178375214.31213.13.camel@localhost.localdomain>
	 <200705051924.14258.ak@suse.de>
Content-Type: text/plain
Date: Sat, 05 May 2007 21:15:01 +0200
Message-Id: <1178392501.31213.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 19:24 +0200, Andi Kleen wrote:
> >  	if (!is_hpet_capable())
> > @@ -278,6 +279,14 @@ int __init hpet_enable(void)
> >  	/* Start the counter */
> >  	hpet_start_counter();
> >  
> > +	/* Verify whether hpet counter works */
> > +	t1 = hpet_read();
> > +	udelay(50);
> 
> Are you sure udelay is calibrated at this point? I didn't think so.
> In fact it needs the external clocks and it's a chicken and egg problem.

Oops. You are right. OTOH it does not matter whether it is accurate or
not.

> It might be safer to use a long loop with io port accesses or similar.

Should work as well.

	tglx


