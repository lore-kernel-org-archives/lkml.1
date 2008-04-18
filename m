Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYDRKY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYDRKY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYDRKYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:24:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYDRKYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:24:47 -0400
Subject: Re: ACPI lockdep warning on boot, 2.6.25-rc5
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803192151.59720.rjw@sisk.pl>
References: <E1JZOGd-00057d-BU@pomaz-ex.szeredi.hu>
	 <20080315131611.GA4828@ucw.cz>
	 <20080319200931.GA1525@linux-os.sc.intel.com>
	 <200803192151.59720.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 12:24:20 +0200
Message-Id: <1208514260.7115.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 21:51 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Venki Pallipadi wrote:
> > On Sat, Mar 15, 2008 at 02:16:11PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > @@ -421,7 +423,9 @@
> > > >  		else
> > > >  			acpi_safe_halt();
> > > >  
> > > > -		local_irq_enable();
> > > > +		if (irqs_disabled())
> > > > +			local_irq_enable();
> > > > +
> > > >  		return;
> > > >  	}
> > > >  
> > > > @@ -530,7 +534,9 @@
> > > >  		 *       skew otherwise.
> > > >  		 */
> > > >  		sleep_ticks = 0xFFFFFFFF;
> > > > -		local_irq_enable();
> > > > +		if (irqs_disabled())
> > > > +			local_irq_enable();
> > > > +
> > > >  		break;
> > > >  
> > > >  	case ACPI_STATE_C2:
> > > 
> > > That's pretty ugly. Could the code be modified to have interrupt
> > > consistent at this point?
> > > 
> > 
> > Agreed that this is not very clean. The problem is that we cannot be sure
> > about the interrupt state at this point as the low level idle handlers at
> > this point can come from variety of different places like safe_halt, arch
> > dependent pm_idle code (which is different for (32 and 64 bit at this point)
> > and also pm_idle can be somewhere outside the kernel in some module as it is
> > a function pointer.
> 
> Well, I'd add a comment that this is to make lockdep happy.  Otherwise it looks
> bizarre.

I'd suggest to clean up the source of this mess instead; this is quite
horrible.

