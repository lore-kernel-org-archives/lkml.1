Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYA0OQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYA0OQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYA0OQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:16:24 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59497 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752563AbYA0OQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:16:23 -0500
Date: Sun, 27 Jan 2008 15:16:20 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH -mm 1/2] Basic PWM driver for AVR32 and AT91
Message-ID: <20080127151620.1ea94383@siona>
In-Reply-To: <200801241253.13680.david-b@pacbell.net>
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
	<200801241253.13680.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 12:53:13 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 24 January 2008, Haavard Skinnemoen wrote:
> > +config ATMEL_PWM
> > +       tristate "Atmel AT32/AT91 PWM support"
> > +       depends on (AVR32 || AT91) && EXPERIMENTAL
> 
> There's probably no need for EXPERIMENTAL except in the
> limited sense of "young driver".  :)

Yeah, I don't think EXPERIMENTAL makes sense here. Either you need the
PWM or you don't.

> There's a bug there ... it should have used ARCH_AT91 instead
> of just AT91.  Or even ARCH_AT91SAM9263 || ARCH_AT91SAM9RL.

I've turned it into ARCH_AT91. I think listing the specific chips that
have it is a bit too much; it won't break if you enable it on a chip
that doesn't have it, it will just be useless. That's what defconfigs
are for, and we still want people that test allmodconfigs on e.g.
AT91RM9200 to report any breakage.

Patch below.

Haavard

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 03c0c27..23a9231 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -15,7 +15,7 @@ if MISC_DEVICES
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on (AVR32 || AT91) && EXPERIMENTAL
+	depends on AVR32 || ARCH_AT91
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
