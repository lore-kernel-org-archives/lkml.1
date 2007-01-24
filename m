Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXAXUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXAXUiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXAXUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:38:51 -0500
Received: from homer.mvista.com ([63.81.120.155]:57313 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbXAXUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:38:50 -0500
Message-ID: <45B7C3CE.2050301@ru.mvista.com>
Date: Wed, 24 Jan 2007 23:38:38 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
  er
References: <45B78DF5.9000203@pmc-sierra.com>
In-Reply-To: <45B78DF5.9000203@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

>> >>This I would hope you can hide in the platform specific
>> >>serial_in/serial_out functions. If you write the UART_LCR save it in
>> >>serial_out(), if you read IER etc.

>> > I couldn't find hooks for platform specific serial_in/out functions.

>>    It's because there are none. :-)

>> > Do you mean using the up->port.iotype's in serial_in/out from 8250.c?

>>    Not sure what Alan meant, but this seems the only option for now.

> That's the conclusion I came to. I've rewritten the patch to use port.type
> instead of iotype since one of the fix is SoC and not UART specific. I guess

    I failed to folkow your logic. :-)

> I could use both iotype and type with a test on each for the appropriate
> bug, what do you recommend?

    I think iotype would be enough. You can't pass type for platform devices 
anyway, IIRC (the thing I don't quite like).

>>  >>And we might want to add a void * for board specific insanity to the 8250
>> >>structures if we really have to so you can hang your brain damage
>> >>privately off that ?

>> > Sounds good to me, it would give us a location to store the address of the
>> > UART_STATUS_REG required by this UART variant.

>>    I doubt we really need to *store* it somewhere. Isn't it an fixed offset
>>from UART's base (I haven't seen the header)?

> Unfortunately it's not a constant offset from the UART in the SoC register

    Hm...

> space. I've used Alan suggestion and added a classic, on some other OSes %-|,
> void "user" pointer.

    Only do not do it under #ifdef.

> Marc

WBR, Sergei
