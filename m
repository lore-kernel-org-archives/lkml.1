Return-Path: <linux-kernel-owner+w=401wt.eu-S940492AbYCSWT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940492AbYCSWT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYCSUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:52:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbYCSUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:52:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: ACPI lockdep warning on boot, 2.6.25-rc5
Date: Wed, 19 Mar 2008 21:51:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <E1JZOGd-00057d-BU@pomaz-ex.szeredi.hu> <20080315131611.GA4828@ucw.cz> <20080319200931.GA1525@linux-os.sc.intel.com>
In-Reply-To: <20080319200931.GA1525@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192151.59720.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of March 2008, Venki Pallipadi wrote:
> On Sat, Mar 15, 2008 at 02:16:11PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > @@ -421,7 +423,9 @@
> > >  		else
> > >  			acpi_safe_halt();
> > >  
> > > -		local_irq_enable();
> > > +		if (irqs_disabled())
> > > +			local_irq_enable();
> > > +
> > >  		return;
> > >  	}
> > >  
> > > @@ -530,7 +534,9 @@
> > >  		 *       skew otherwise.
> > >  		 */
> > >  		sleep_ticks = 0xFFFFFFFF;
> > > -		local_irq_enable();
> > > +		if (irqs_disabled())
> > > +			local_irq_enable();
> > > +
> > >  		break;
> > >  
> > >  	case ACPI_STATE_C2:
> > 
> > That's pretty ugly. Could the code be modified to have interrupt
> > consistent at this point?
> > 
> 
> Agreed that this is not very clean. The problem is that we cannot be sure
> about the interrupt state at this point as the low level idle handlers at
> this point can come from variety of different places like safe_halt, arch
> dependent pm_idle code (which is different for (32 and 64 bit at this point)
> and also pm_idle can be somewhere outside the kernel in some module as it is
> a function pointer.

Well, I'd add a comment that this is to make lockdep happy.  Otherwise it looks
bizarre.

Thanks,
Rafael
