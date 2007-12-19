Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbXLSUdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbXLSUdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXLSUc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:32:56 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:56033 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbXLSUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xI79hsTJOuA5LrCEvuRIisZKsfvIeociby723qCPfmUAEVQnx28ZXukrRt2QUrryy4BtE0DRRNgQ+fD2bkmWGCSlqafbCcNlOEFP+X2LModg7BMlWT/j4oOg9cwNfLaKX//DTsuURH+cWd4kBPmeUsFvAKmnDpJpe/1t4T0yw/8=
Message-ID: <3efb10970712191232t4e1a1148q2c634b004421a685@mail.gmail.com>
Date: Wed, 19 Dec 2007 21:32:44 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
In-Reply-To: <20071219181915.71e9daeb@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
	 <20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
	 <3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
	 <20071219174742.68e70c6c@dhcp-252-066.norway.atmel.com>
	 <3efb10970712190859j125eb027y89a967280c2c829@mail.gmail.com>
	 <20071219181915.71e9daeb@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 5df5bef46b12a8e8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> preempt-rt can disable interrupts for 300 us?

I am not sure if it really is an interrupt lock that long, but on
these ARM cores I still run into latencies that large. I tried using
latency_trace to figure out where they come from, but that tool even
reports interrupt locks up to 10 ms while those surely do not exist
(the 2nd in size reported is about 300us). So, those tools are buggy
on AT91 as well, and I do not trust them completely yet.. (They even
do not compile cleanly, conflicts in headers, warnings etc. Maybe
those tools are not used very much outside x86)

So, I still have a long way to go to make Preempt-RT to run on these
cores just as good as preempt-rt runs on X86, although I am sure that
I never will reach the <30us as I have on x86.

> If so, then I guess there's really no way to avoid a few overruns.

And if DBGU is used as a terminal, it should be no problem at all, or
someone has to slow down the baudrate a bit.
I only get this overrun under very heavy system load (CPU load 99%,
with one single thread running at RT-prio 99, taking chunks away of
99/100ms.) and then throw in a big file of many MBs in the terminal.
But, as long as the read part still runs in hard-irq context, it
should keep up, unless interrupts are locked too long.

> > Notice that without these interrupt handler splitup, it was much, much
> > much worse...
>
> Ok, that's good I guess.

Yep, that _is_ good.

> > So, for me it is not a big deal, because it is just a terminal, and
> > with my shaky fingers I usually do not type that fast ;-))
> If you do, you just need to switch to one of the USARTs instead of the
> DBGU so that you can use DMA :-)

:-)

> We need to fix the break- and error handling though. But my vacation
> starts tomorrow, so I probably won't be able to fix it until next year.

In that case, I wish you very good holiday, and a happy new-year.
It was very pleasant working with you on this driver.

I probably see you again on the list next year.


Kind Regards,

Remy
