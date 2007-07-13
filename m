Return-Path: <linux-kernel-owner+w=401wt.eu-S1762578AbXGMTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762578AbXGMTqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXGMTqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:46:16 -0400
Received: from rtr.ca ([64.26.128.89]:2013 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbXGMTqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:46:15 -0400
Message-ID: <4697D686.6090104@rtr.ca>
Date: Fri, 13 Jul 2007 15:46:14 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org>	<200702210342.20775.bzolnier@gmail.com>	<466EEFD6.9030001@ru.mvista.com>	<200706160123.55636.bzolnier@gmail.com>	<4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu> <46979652.6040201@rtr.ca> <4697987E.3040406@ru.mvista.com> <4697D425.7000300@rtr.ca> <4697D518.7010108@ru.mvista.com>
In-Reply-To: <4697D518.7010108@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Mark Lord wrote:
> 
>>>    The original question concerned specifically the DMA command 
>>> timeout which is twice more than the usual one, WAIT_CMD (10 seconds).
..
>> When a drive is in standby, we don't send it anything special to wake up.
>> So even DMA commands have to have a long enough timeout to allow
>> for spinning up.
> 
>    Yes, but why *twice* as long as the others?

I would guess simply because DMA has to transfer up to 256 sectors of data,
possibly with sector reallocations, in addition to waiting for the drive
to spin up.  Other commands don't.

At the time that was coded (?), I suspect that PIO READ/WRITE commands
were fed data as it became available to/from the drive.  This may or may
not still be the case, but it does imply that they don't need to hang
around as long on the timeouts as do DMA commands (which have to wait
for *everything* to be transferred).

I'm guessing that this was the original concern of mine,
way back in 1994 or whenever it was.

Cheers
