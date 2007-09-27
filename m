Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbXI0TeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbXI0TeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXI0TeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:34:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbXI0TeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:34:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Date: Thu, 27 Sep 2007 21:48:59 +0200
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <20070927103351.33c93289.randy.dunlap@oracle.com> <20070927191938.GB1847@uranus.ravnborg.org>
In-Reply-To: <20070927191938.GB1847@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709272149.00195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 21:19, Sam Ravnborg wrote:
> On Thu, Sep 27, 2007 at 10:33:51AM -0700, Randy Dunlap wrote:
> > On Thu, 27 Sep 2007 18:53:46 +0200 Sam Ravnborg wrote:
> > 
> > > Hi Rafael.
> > > > 
> > > > Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> > > > to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > ---
> > > >  arch/x86_64/kernel/apic.c |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > Index: linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > > > ===================================================================
> > > > --- linux-2.6.23-rc8-mm2.orig/arch/x86_64/kernel/apic.c
> > > > +++ linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > > > @@ -42,7 +42,7 @@
> > > >  
> > > >  int apic_verbosity;
> > > >  static int apic_calibrate_pmtmr __initdata;
> > > > -int disable_apic_timer __initdata;
> > > > +int disable_apic_timer __cpuinitdata;
> > > >  
> > > This is with your configuration a reference from a .text section
> > > to a .init.data section as I see it.
> > > 
> > > So this ought to have been flagged by the section mismatch
> > > checks in modpost.
> > > 
> > > I assume you did not see such warning??
> > 
> > I did:

But I didn't.  I'm not sure why.

> > WARNING: vmlinux.o(.text+0x7778): Section mismatch: reference to .init.data:disable_apic_timer (between 'identify_cpu' and 'IRQ0x20_interrupt')
> 
> Thanks. I look forward to the day I can make them errors so people
> cannot ignore them.
> That said a lot of individuals has done a very good job getting
> rid of section mismatch warnings all over the kernel.

Yes.

Greetings,
Rafael
