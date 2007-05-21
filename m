Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbXEUQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbXEUQLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXEUQLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:11:18 -0400
Received: from relay00.pair.com ([209.68.5.9]:1947 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755918AbXEUQLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:11:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 12:11:14 EDT
X-pair-Authenticated: 24.241.238.207
Message-ID: <4651C310.1090008@cybsft.com>
Date: Mon, 21 May 2007 11:04:32 -0500
From: "K.R. Foley" <kr@cybsft.com>
Organization: Cybersoft Solutions, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.21-rt3
References: <20070517194143.GA25394@elte.hu>
In-Reply-To: <20070517194143.GA25394@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------020805030708060904050208"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020805030708060904050208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> i'm pleased to announce the v2.6.21-rt3 kernel, which can be downloaded 
> from the usual place:
> 

This is actually regarding v2.6.21-rt5 but I don't remember seeing an
announcement for that one. The attached patch is necessary if you happen
to have RTC_HISTOGRAM enabled, which I'm guessing most folks don't.

BTW, what was the consensus on pagefault_enable and pagefault_disable?

-- 
   kr

--------------020805030708060904050208
Content-Type: text/x-patch;
 name="fixrtc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixrtc.patch"

--- linux-2.6.21/drivers/char/rtc.c.orig	2007-05-21 08:32:42.000000000 -0500
+++ linux-2.6.21/drivers/char/rtc.c	2007-05-21 08:33:49.000000000 -0500
@@ -93,6 +93,10 @@
 #include <asm/isa.h>
 #endif
 
+static unsigned long rtc_port;
+static int rtc_irq = PCI_IRQ_NONE;
+#endif
+
 #ifdef CONFIG_MIPS
 # include <asm/time.h>
 #endif
@@ -119,10 +123,6 @@ enum rtc_states {
 
 #endif
 
-static unsigned long rtc_port;
-static int rtc_irq = PCI_IRQ_NONE;
-#endif
-
 #ifdef	CONFIG_HPET_RTC_IRQ
 #undef	RTC_IRQ
 #endif

--------------020805030708060904050208--
