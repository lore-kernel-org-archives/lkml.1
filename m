Return-Path: <linux-kernel-owner+w=401wt.eu-S935470AbXGYT3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470AbXGYT3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935831AbXGYT2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:28:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:26013 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935812AbXGYT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:28:52 -0400
Message-ID: <46A7A4EC.2020503@ru.mvista.com>
Date: Wed, 25 Jul 2007 23:30:52 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       segher@kernel.crashing.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com> <20070725180145.GA29689@ld0162-tx32.am.freescale.net> <46A7941F.2050300@ru.mvista.com> <46A798D8.7020906@freescale.com>
In-Reply-To: <46A798D8.7020906@freescale.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

>> Scott Wood wrote:

>>>>    Also, what mmio-ide in the compat properly means in the context 
>>>> of ide_platform which is able to handle both port and memory mapped 
>>>> IDE.

>>> I/O-space is only valid in the context of PCI, ISA, or similar buses, 
>>> and
>>> the bus-specific reg format indicates whether it's mmio-space or
>>> io-space.

>>    You could save time on lecturing me (and use it to look on the 
>> driver ;-).

> Sorry, I misread the question as being a mismatch between the 
> capabilities of the device binding and the driver, not about the 
> specific compatible name.

    That too. :-)

> Something like "generic-ide" would probably be better.

    I strongly disagree with "generic" part. The generic IDE could only be 
said of 1:1 I/O mapped IDE ports, not about this fancy mapping.

>>> What is board specific about a set of standard IDE registers at a given

>>    The regisrer mapping used is highly non-standard.

> The gap between registers is nonstandard, but that's a fairly common 
> type of noncompliance in embedded-land, and probably merits being 

    That is only a common variation of embedded non-compliancy (which doesn't 
make it a compliancy. ;-)
    There are worse cases in the bi-endian land, even with the standard 8-bit 
regs and 1-byte stride. *Hopefully*, this driver could also support those...

> supported in a generic way.  I wouldn't call it "highly" nonstandard.

    Yeah, there are also 8250 "compatible" UARTs that use 32-bit memory 
accesses, and even worse -- with some registers mapped differently than on 
8250 (those can't be called compatible by any means), yet 8250.c drives all of 
them.  I'm not really sure it was such a good idea to merge, say Alchemy UART 
support into 8250.c.

> Is there some other non-standardness that I'm missing?

    *Hopefully*, none.  The original Kumar's driver pretended to handle 
byte-lane swapping too (but that was ugly :-).

>>    We're already in board specific code, so why the heck not? :-)

>>> various ns16550-compatibles out there as well?

>>    I never suggested that -- what I did suggest was make of_serial.c 
>> recognize certain chip types and register them with 8250 driver.

> What would be the advantage of maintaining a list of chips whose only 

    Nobody's talking about the advantages, just about the device tree accepted 
practices (which we've already tried to bypass with MTD node -- causing a lot 
of bashing until David Woodhouse came to help :-).

> difference is register spacing, rather than just using reg-shift and 
> being done with it?

    Please read the linuxppc-dev archive's threads following form David's 
patches.  Or maybe Segher could repeat this for you. ;-)

> -Scott

MBR, Sergei
