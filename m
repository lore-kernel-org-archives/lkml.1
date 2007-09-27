Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXI0Ppk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXI0Ppk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXI0PpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:45:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43539 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbXI0PpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:45:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Date: Thu, 27 Sep 2007 17:59:45 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <200709271719.06937.rjw@sisk.pl>
In-Reply-To: <200709271719.06937.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271759.46018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 17:19, Rafael J. Wysocki wrote:
> On Thursday, 27 September 2007 11:22, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> > 
> > 
> > - The scheduler devel tree has been restored
> > 
> > - The driver tree is presently busted, so I reverted it to the 2..23-rc8-mm1
> >   version.
> > 
> > - It's now a nearly-32MB diff.
> 
> On HP nx6325:
> 
> 1) The audio is back (thanks for reverting x86_64-mm-cpa-einval.patch)
> 
> 2) CPU hotplug is busted (onlining of CPU1 kills the kernel), probably due to
>    the same issue that I'm having with the -hrt version of 2.6.23-rc8 (we're
>    debugging it right now)

This one is fixed by the following patch:

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
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
