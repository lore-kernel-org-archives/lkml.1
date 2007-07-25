Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGYTPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGYTPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935418AbXGYTOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:14:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25913 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935385AbXGYTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:14:12 -0400
Message-ID: <46A7A17C.8090505@ru.mvista.com>
Date: Wed, 25 Jul 2007 23:16:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <46A79DE0.8060405@ru.mvista.com> <46A79F14.9040409@freescale.com>
In-Reply-To: <46A79F14.9040409@freescale.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Scott Wood wrote:

>>> +    hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
>>> +
>>> +    port += (1 << pdata->ioport_shift);
>>> +    for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
>>> +         i++, port += (1 << pdata->ioport_shift))
>>
>>
>>
>>     Looks like shift doesn't buy as anything, why not just use stride?

> It doesn't buy us anything in here, but it's conceivable that someone 
> may want to write a driver that uses a shift in the I/O accessor rather 
> than an array of port offsets,

    It wouldn't be IDE driver then, and neither it would be libata which also 
does this another way this (despite pata_platform uses shifts too -- not in 
the accessors, so no speed loss).

> and it's easier to convert a shift to a stride than the other way around
 > (not all architectures have an
> equivalent of the cntlzw innstruction, and shift makes it clear that the 
> stride must be power-of-two).  Plus, using shift is consistent with what 
> we do on ns16550.

    Why the heck should we care about the UART code taling about IDE?!
    So, let me consider your argument purely speculative and invalid. ;-)

> -Scott

WBR, Sergei
