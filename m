Return-Path: <linux-kernel-owner+w=401wt.eu-S1750997AbZDINxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbZDINxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764853AbZDINw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:52:56 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45193 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764387AbZDINwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:52:55 -0400
X-IronPort-AV: E=Sophos;i="4.40,160,1238990400"; 
   d="scan'208";a="69541509"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Thu, 9 Apr 2009 09:54:54 -0400
User-Agent: KMail/1.9.5
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Chris Peterson" <cpeterso@cpeterso.com>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <200904071744.17727.rgetz@blackfin.uclinux.org> <1239220294.31467.55.camel@calx>
In-Reply-To: <1239220294.31467.55.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904090954.54601.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 09 Apr 2009 13:52:38.0657 (UTC) FILETIME=[71D0D710:01C9B91A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 8 Apr 2009 15:51, Matt Mackall pondered:
> On Tue, 2009-04-07 at 17:44 -0400, Robin Getz wrote:
> > Is that "Everything in general, with a few exceptions", or
> > "__Everything__"?
> 
> Everything. We want every input point to better document the type of
> entropy source.

OK - any objections to something like this?

===================================================================
--- Documentation/feature-removal-schedule.txt  (revision 6236)
+++ Documentation/feature-removal-schedule.txt  (working copy)
@@ -6,6 +6,19 @@

 ---------------------------

+What:  IRQF_SAMPLE_RANDOM
+Check: IRQF_SAMPLE_RANDOM
+When:  July 2009
+Why:   Many of IRQF_SAMPLE_RANDOM users are technically bogus as entropy
+       sources in the kernel's current entropy model. To resolve this, every
+       input point to the kernel's entropy pool needs to better document the
+       type of entropy source it actually is. This will be replaced with
+       additional add_*_randomness functions in drivers/char/random.c
+
+Who:   Robin Getz <rgetz@blackfin.uclinux.org> & Matt Mackall 
<mpm@selenic.com>
+
+---------------------------
+

Then if someone attempts to add it, and runs checkpatch, it will generate 
something like:

--------
ERROR: Don't use IRQF_SAMPLE_RANDOM(): see 
Documentation/feature-removal-schedule.txt
#10: FILE: serial/bfin_5xx.c:650:
+       if (request_irq(uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED | 
IRQF_SAMPLE_RANDOM,
--------

My only real question is on the date... In a previous email:

On Mon 6 Apr 2009 15:01, Matt Mackall pondered:
> I'm eventually going to move the RNG away from the strict theoretical
>  entropy accounting model to a more pragmatic one which will be much
>  happier with iffy entropy sources, but that's a ways off.

I was not sure what "a ways off" was defined as - or are the two (removal of 
IRQF_SAMPLE_RANDOM, and the pragmatic entropy accounting model) separate in 
your mind? I guess various add_*_randomness functions can be added today, and 
change how they are accounted for in the future?

-Robin
