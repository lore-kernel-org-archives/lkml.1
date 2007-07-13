Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXGMVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXGMVAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXGMVAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:00:21 -0400
Received: from rtr.ca ([64.26.128.89]:2524 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXGMVAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:00:19 -0400
Message-ID: <4697E7E2.70303@rtr.ca>
Date: Fri, 13 Jul 2007 17:00:18 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mark Lord <lkml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org>	<200702210342.20775.bzolnier@gmail.com>	<466EEFD6.9030001@ru.mvista.com>	<200706160123.55636.bzolnier@gmail.com>	<4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu> <46979652.6040201@rtr.ca> <4697987E.3040406@ru.mvista.com> <4697D425.7000300@rtr.ca> <4697D518.7010108@ru.mvista.com> <4697D686.6090104@rtr.ca> <4697DAAE.5090704@ru.mvista.com>
In-Reply-To: <4697DAAE.5090704@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Mark Lord wrote:
> ..
>> I would guess simply because DMA has to transfer up to 256 sectors of 
>> data,
>> possibly with sector reallocations, in addition to waiting for the drive
>> to spin up.  Other commands don't.
> 
>    What?! PIO commands don't have to do this as well? :-)

"Other commands" don't have to transfer up to 256 sectors before interrupting.

>> At the time that was coded (?), I suspect that PIO READ/WRITE commands
>> were fed data as it became available to/from the drive.  This may or may
> 
>    I don't see *any* difference with the DMA commands here -- the drive 
> has always been free to assert and deassert DMARQ at its well.

Yeah, but that's not what our software timeout is for.
The timeout is for the next interrupt, which will only 
be given (for DMA) once the drive completes *all* transfers.

>> not still be the case, but it does imply that they don't need to hang
>> around as long on the timeouts as do DMA commands (which have to wait
>> for *everything* to be transferred).
> 
>    Ah, that makes sense -- during PIO interrupts happen a lot more often.
> 20 secs still seem to be too much.

I don't think so, even for modern drives.
Figure 8-10 seconds max for spin-up,
plus 6-9 seconds to do a sector re-assignment
or retries on a bad block (a measured *real-life* value).

That adds up to 14-19 seconds, so 20 seconds is probably good.

Still, this does need to be adjustable for faster (CF) devices,
and slower (optical/tape) devices, rather than just a single
set of fixed timeout values.

Cheers

> PS: Your mail server still keeps bouncing me off. :-(

PS: your mail server still looks like a spammer, because it is
(1) missing a reverse DNS entry for 63.81.120.155,
and (2) is not RFC compliant on the SMTP "HELO" message
(bad hostname given there).
