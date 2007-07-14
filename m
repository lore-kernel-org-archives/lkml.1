Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbXGNJII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbXGNJII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbXGNJH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:07:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626AbXGNJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:07:55 -0400
Date: Sat, 14 Jul 2007 02:07:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070714020713.36f604d2.akpm@linux-foundation.org>
In-Reply-To: <469879A2.1000002@shaw.ca>
References: <fa.GKNLH/oj9PSCnQCxx9ZAggjc5uA@ifi.uio.no>
	<469879A2.1000002@shaw.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 01:22:10 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Andrew Morton wrote:
> > +x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
> > 
> >  pretend to fix it
> 
> I'm not sure what this patch does on x86_64, but it seems like it 
> trashes all HPET support on i386?
> 

It might do, if your i386 is old and has the HPET_ID_LEGSUP bit set.

The code path which that patch disables:

--- a/arch/i386/kernel/hpet.c~x86_64-dynticks-disable-hpet_id_legsup-hpets
+++ a/arch/i386/kernel/hpet.c
@@ -376,7 +376,7 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
-	if (id & HPET_ID_LEGSUP) {
+	if (0 && (id & HPET_ID_LEGSUP)) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
 		/*
_

will, if executed (on x86_64, at least), instaoops the machine.  It might
take down i386 as well, dunno.

I'd forgotten about this problem, and it seems that Thomas & John have too.
It's a showstopper.

