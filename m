Return-Path: <linux-kernel-owner+w=401wt.eu-S936478AbXGMPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936478AbXGMPM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXGMPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:12:21 -0400
Received: from rtr.ca ([64.26.128.89]:1891 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761283AbXGMPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:12:20 -0400
Message-ID: <46979652.6040201@rtr.ca>
Date: Fri, 13 Jul 2007 11:12:18 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org>	<200702210342.20775.bzolnier@gmail.com>	<466EEFD6.9030001@ru.mvista.com>	<200706160123.55636.bzolnier@gmail.com>	<4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu>
In-Reply-To: <20070713161612.2f2ebb0b@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> >>    BTW, why the timeout is so damn long? 2*WAIT_CMD is 20 secs, and if DMA is 
>>>> not complete or interrupt pending, it may wait 10 more secs...
>>> I really don't remember... :)
>>> Maybe Mark or Alan could help with figuring this out.
>>     They also have probably forgotten. :-)
> 
> Because that value seemed to work ok. Mark set the timeouts way back in
> history and I never touched most of them.

I've lost the original question from this thread, but the idea of the longish
timeouts was that drive *may* be spun down ("standby"), and thus have to spin
up again to complete media commands.  Back then, drives were much slower at
spinning up than nowadays, and the ATA spec says to allow up to 30 seconds.

So..
