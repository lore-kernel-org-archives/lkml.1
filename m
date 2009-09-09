Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZIIJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZIIJ2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZIIJ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:28:14 -0400
Received: from ns.penguin.cz ([84.21.108.25]:47997 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZIIJ2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:28:13 -0400
Subject: Re: Zaurus suspend saga
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <20090908215306.GC17228@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <20090907113132.GM23450@elf.ucw.cz>
	 <1252329025.1861.6.camel@hammer.suse.cz>
	 <20090908215306.GC17228@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Sep 2009 11:28:12 +0200
Message-Id: <1252488492.4267.40.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>Well, overnight charge (online) seems to result in pretty much empty
>battery...

Which kernel? I did the same in 2.6.26-RP and the battery was charged
overnight from about 60% to 100%.

I think that it is not possible to drain battery if an AC adapter
provides a sufficient voltage. But it's possible to disable charging by
a bad setting of the software.

>Is CHRG_ON pin reversed?

I am not sure, but it looks so. Both CHRG_ON resp. JK_B travel from
SCOOP PA pins to the gate of FET transistors﻿ with pull-up (probably
acts as an invertor and voltage converter) and end in EN resp. PRGM pins
of ﻿in the charging chip (SC801). You have to consult SC801 data sheet.

You can also verify both with a voltmeter connected to the battery.
CHRG_ON should cause﻿﻿ rise of voltage on the battery pins. The rise
value should be dependent on JK_B.

Also both CP resp. STAT pins of SC801 travel through FET transistors
before it become AC_IN and CHRG_FULL.

> With my AA charger, I get "AC Status: 0", as long as battery is not
> full. It draws power for it (and battery percentage goes higher) but
> it is not even detected as charger :-(.

You have to have about 4.2V﻿ on the AC connector to get AC_IN. When
trying fast online charging, your AA charger must provide more than 4.2V
at possibly more than 1A current. Switching to slow charging, it
decreases to say >500mA online and 120mA offline. In the worst case,
your Zaurus may need nearly 2A.

You can hack the kernel to send CHRG_ON even if AC_IN is 0. But I am not
sure what will charging chip do then (data sheet will probably tell it
to you).

You can try to set SPITZ_SCP_JK_B to slow charging. Maybe voltage will
become sufficient.

> [But charge LED is lit. WTF?]

One pole of the LED is connected to AC power input, the seconds one to
the GPIO. So the logic is following:

IF (kernel says that LED should light) AND (there is sufficient voltage
on AC input) THEN (LED lights)


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

