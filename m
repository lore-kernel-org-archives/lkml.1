Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXFSPiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXFSPiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXFSPio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:38:44 -0400
Received: from rtr.ca ([64.26.128.89]:4608 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbXFSPin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:38:43 -0400
Message-ID: <4677F881.6060200@rtr.ca>
Date: Tue, 19 Jun 2007 11:38:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linas Vepstas <linas@austin.ibm.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com>	<20070618212704.394912b8@the-village.bc.nu>	<20070618204601.GF5836@austin.ibm.com>	<20070618220441.3a3af8ca@the-village.bc.nu>	<4677E3BC.3040307@ru.mvista.com> <20070619151919.79c79af1@the-village.bc.nu> <4677E726.1080602@ru.mvista.com>
In-Reply-To: <4677E726.1080602@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Alan Cox wrote:
> 
>>>>> I can prepare a patch, but only with a lot of guidance. I can test 
>>>>> & debug, I'm highly motivated just right now ... 
> 
>>>> If you've got a nice repeatable problem please try using the libata
>>>> driver. That handles the error paths differently and doesn't try a FIFO
>>>> drain which might matter in this case I guess.
> 
>>>    FIFO drain for DMA commands?
> 
>> Welcome to the old IDE layer which I am so glad I left behind 8)
> 
>> ide_ata_error will try and do a PIO flush regardless of the command type
>> if DRQ_STAT is asserted. See ide_dma_intr -> ide_error -> ...
> 
>    Indeed... but the thing is we don't know what's asserted in this case 
> -- remember, it's reading the status register that locks everything up...

Exactly.  And IORDY shouldn't really apply there,
unless some nitwit standards person wrote it into a spec..

-ml
