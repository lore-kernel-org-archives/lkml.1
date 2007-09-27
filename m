Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbXI0Rfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbXI0Rfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXI0Rfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:35:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32639 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbXI0Rfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:35:37 -0400
Date: Thu, 27 Sep 2007 10:33:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Message-Id: <20070927103351.33c93289.randy.dunlap@oracle.com>
In-Reply-To: <20070927165346.GA919@uranus.ravnborg.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<200709271719.06937.rjw@sisk.pl>
	<200709271759.46018.rjw@sisk.pl>
	<20070927165346.GA919@uranus.ravnborg.org>
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

On Thu, 27 Sep 2007 18:53:46 +0200 Sam Ravnborg wrote:

> Hi Rafael.
> > 
> > Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> > to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86_64/kernel/apic.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > ===================================================================
> > --- linux-2.6.23-rc8-mm2.orig/arch/x86_64/kernel/apic.c
> > +++ linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
> > @@ -42,7 +42,7 @@
> >  
> >  int apic_verbosity;
> >  static int apic_calibrate_pmtmr __initdata;
> > -int disable_apic_timer __initdata;
> > +int disable_apic_timer __cpuinitdata;
> >  
> This is with your configuration a reference from a .text section
> to a .init.data section as I see it.
> 
> So this ought to have been flagged by the section mismatch
> checks in modpost.
> 
> I assume you did not see such warning??

I did:

WARNING: vmlinux.o(.text+0x7778): Section mismatch: reference to .init.data:disable_apic_timer (between 'identify_cpu' and 'IRQ0x20_interrupt')

---
~Randy
Phaedrus says that Quality is about caring.
