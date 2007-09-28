Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXI1VQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXI1VQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXI1VQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:16:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbXI1VQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:16:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Date: Fri, 28 Sep 2007 23:31:05 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <200709271759.46018.rjw@sisk.pl> <1190908166.23376.115.camel@chaos>
In-Reply-To: <1190908166.23376.115.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709282331.06203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 17:49, Thomas Gleixner wrote:
> On Thu, 2007-09-27 at 17:59 +0200, Rafael J. Wysocki wrote:
> > > 2) CPU hotplug is busted (onlining of CPU1 kills the kernel), probably due to
> > >    the same issue that I'm having with the -hrt version of 2.6.23-rc8 (we're
> > >    debugging it right now)
> > 
> > This one is fixed by the following patch:
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
> > to disable_apic_timer (labeled as __initdata) from the CPU initialization code.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Doh, I knew I blew it.
> 
> Good catch, thanks,

Some good news from here. :-)

WIth the patch below applied 2.6.23-rc8-mm2 works fine on the nx6325 _with_ NO_HZ
and HIGH_RES_TIMERS set.  Suspend and hibernation work as well, happy me.

NO_HZ and HIGH_RES_TIMERS also work on this box with the hrt patch plus the
C1E-related fix on top of 2.6.23-rc8.

Does it make sense to test CPU_IDLE too at this point?

Greetings,
Rafael


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
> >  /* Local APIC timer works in C2? */
> >  int local_apic_timer_c2_ok;
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
