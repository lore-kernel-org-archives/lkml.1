Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbXI0Pp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbXI0Pp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbXI0PpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:45:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXI0PpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:45:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents)
Date: Thu, 27 Sep 2007 17:58:15 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709270130.51870.rjw@sisk.pl> <1190848909.23376.78.camel@chaos>
In-Reply-To: <1190848909.23376.78.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271758.16138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 01:21, Thomas Gleixner wrote:
> On Thu, 2007-09-27 at 01:30 +0200, Rafael J. Wysocki wrote:
> > > > Tested for a couple of times with each kernel, the results seem to be
> > > > reproducible 100% of the time.
> > > 
> > > Thanks for going through this debug marathon.
> > 
> > No big deal.  I'm glad that you've found what's up.
> > 
> > Well, we still have the "CPU hotplug during suspend w/ the hrt patch" problem
> > to debug ... ;-)
> 
> Yeah. Knowing the actual line of code where it breaks might be helpful.

Instead, I have a fix (appended, against 2.6.23-rc8-mm2). :-)

Next, I'm going to enable NO_HZ and HIGH_RES_TIMERS and see what happens. ;-)

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by the reference
to disable_apic_timer (labeled as __initdata) from the CPU initialization code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86_64/kernel/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.23-rc8-mm2.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.23-rc8-mm2/arch/x86_64/kernel/apic.c
@@ -42,7 +42,7 @@
 
 int apic_verbosity;
 static int apic_calibrate_pmtmr __initdata;
-int disable_apic_timer __initdata;
+int disable_apic_timer __cpuinitdata;
 
 /* Local APIC timer works in C2? */
 int local_apic_timer_c2_ok;
