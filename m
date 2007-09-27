Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbXI0Tjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbXI0Tjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXI0Tjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:39:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61274 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbXI0Tjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:39:35 -0400
Date: Thu, 27 Sep 2007 12:37:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Message-Id: <20070927123715.ebc22761.randy.dunlap@oracle.com>
In-Reply-To: <200709272149.00195.rjw@sisk.pl>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<20070927103351.33c93289.randy.dunlap@oracle.com>
	<20070927191938.GB1847@uranus.ravnborg.org>
	<200709272149.00195.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 21:48:59 +0200 Rafael J. Wysocki wrote:

> On Thursday, 27 September 2007 21:19, Sam Ravnborg wrote:
> > On Thu, Sep 27, 2007 at 10:33:51AM -0700, Randy Dunlap wrote:
> > > On Thu, 27 Sep 2007 18:53:46 +0200 Sam Ravnborg wrote:
> > > 
> > > > Hi Rafael.
> > > > > 
> > > > > Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> > > > > to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > ---
> > > > >  arch/x86_64/kernel/apic.c |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > Index: linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > > > > ===================================================================
> > > > > --- linux-2.6.23-rc8-mm2.orig/arch/x86_64/kernel/apic.c
> > > > > +++ linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > > > > @@ -42,7 +42,7 @@
> > > > >  
> > > > >  int apic_verbosity;
> > > > >  static int apic_calibrate_pmtmr __initdata;
> > > > > -int disable_apic_timer __initdata;
> > > > > +int disable_apic_timer __cpuinitdata;
> > > > >  
> > > > This is with your configuration a reference from a .text section
> > > > to a .init.data section as I see it.
> > > > 
> > > > So this ought to have been flagged by the section mismatch
> > > > checks in modpost.
> > > > 
> > > > I assume you did not see such warning??
> > > 
> > > I did:
> 
> But I didn't.  I'm not sure why.

I did only on one build machine (multiple times).  I tried
to reproduce it on another machine and could not.  I blame
different build tools.

> > > WARNING: vmlinux.o(.text+0x7778): Section mismatch: reference to .init.data:disable_apic_timer (between 'identify_cpu' and 'IRQ0x20_interrupt')
> > 
> > Thanks. I look forward to the day I can make them errors so people
> > cannot ignore them.
> > That said a lot of individuals has done a very good job getting
> > rid of section mismatch warnings all over the kernel.
> 
> Yes.


---
~Randy
Phaedrus says that Quality is about caring.
