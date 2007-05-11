Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXEKU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXEKU3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXEKU3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:29:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757232AbXEKU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:29:17 -0400
Date: Fri, 11 May 2007 13:28:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070511132846.5ebf4437.akpm@linux-foundation.org>
In-Reply-To: <200705112210.25397.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	<200705102212.08046.rjw@sisk.pl>
	<20070511094750.e91ea55b.akpm@linux-foundation.org>
	<200705112210.25397.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 22:10:24 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > > Index: linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > > ===================================================================
> > > --- linux-2.6.21.orig/drivers/acpi/hardware/hwsleep.c
> > > +++ linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > > @@ -200,10 +200,10 @@ acpi_status acpi_enter_sleep_state_prep(
> > >  		return_ACPI_STATUS(status);
> > >  	}
> > >  
> > > -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > > +	/*status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> > >  		return_ACPI_STATUS(status);
> > > -	}
> > > +	}*/
> > >  
> > >  	/* Setup the argument to _SST */
> > >  
> > 
> > I tested this against Thomas's original patch (below).  Still hangs, in the
> > same way.
> 
> Well, I'm out of ideas. :-(
> 
> Could you please send me the Vaio's DSDT?

Maybe I should send you the Vaio ;)

I have this 1999-era pre-ACPI, pre-everything-else Dual-PIII-based
Supermicro machine and it just *always* works.  Sigh.


hm, Fedora don't seem to want to give me an RPM which contains acpidump and
all the yum servers are featuring scrogged checksums.  I could build it, I
guess, but there's a principle involved ;)

http://userweb.kernel.org/~akpm/dsdt is /proc/acpi/dsdt.  Is that OK?
