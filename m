Return-Path: <linux-kernel-owner+w=401wt.eu-S966745AbXEKUFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966745AbXEKUFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbXEKUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:05:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724AbXEKUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:05:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Fri, 11 May 2007 22:10:24 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <200705102212.08046.rjw@sisk.pl> <20070511094750.e91ea55b.akpm@linux-foundation.org>
In-Reply-To: <20070511094750.e91ea55b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705112210.25397.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 May 2007 18:47, Andrew Morton wrote:
> On Thu, 10 May 2007 22:12:07 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, 10 May 2007 11:27, Thomas Gleixner wrote:
> > > On Thu, 2007-05-10 at 02:18 -0700, Andrew Morton wrote:
> > > > > > > If that patch makes the problem go away, then we should have a quite
> > > > > > > good hint what we need to look at.
> > > > > > 
> > > > > > No joy, sorry.  It still hangs at the last statement in acpi_evaluate_object().
> > > > > 
> > > > > Can you add "nolapic_timer" to the command line please ?
> > > > > 
> > > > 
> > > > That works.
> > > 
> > > Ok, that boils it down to the change, which affects the lapic timer
> > > resume. It does nothing else, than fiddling in some APIC registers, but
> > > I don't see how this affects the ACPI stuff. This smells extremly fishy.
> > 
> > Hmm, I wonder if it might be related to the execution of the _GTS ACPI control
> > method in acpi_enter_sleep_state_prep() in violation of the spec.
> > 
> > Andrew, could you please try to apply the following change on top of the
> > previous ones and see if the machine still hangs in the same place without
> > "nolapic_timer"?
> > 
> > ---
> >  drivers/acpi/hardware/hwsleep.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > ===================================================================
> > --- linux-2.6.21.orig/drivers/acpi/hardware/hwsleep.c
> > +++ linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > @@ -200,10 +200,10 @@ acpi_status acpi_enter_sleep_state_prep(
> >  		return_ACPI_STATUS(status);
> >  	}
> >  
> > -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > +	/*status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> >  		return_ACPI_STATUS(status);
> > -	}
> > +	}*/
> >  
> >  	/* Setup the argument to _SST */
> >  
> 
> I tested this against Thomas's original patch (below).  Still hangs, in the
> same way.

Well, I'm out of ideas. :-(

Could you please send me the Vaio's DSDT?
