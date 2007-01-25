Return-Path: <linux-kernel-owner+w=401wt.eu-S1030447AbXAYRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447AbXAYRDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030446AbXAYRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:03:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:2034 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030363AbXAYRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:03:18 -0500
Message-ID: <45B8E2D5.1030508@ru.mvista.com>
Date: Thu, 25 Jan 2007 20:03:17 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/15] ide: disable DMA in ->ide_dma_check for "no IORDY"
 case
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	 <20070119003154.14846.87217.sendpatchset@localhost.localdomain>	 <45B0F12B.3000202@ru.mvista.com>	 <58cb370e0701191047h524434eobdb9d86ed614bc71@mail.gmail.com>	 <45B117D4.7050406@gmail.com> <45B11D8D.8070105@ru.mvista.com>	 <58cb370e0701191200i10119313i4aacae9c504a02e4@mail.gmail.com>	 <45B13B8D.2020402@gmail.com> <45B24CBA.8080900@ru.mvista.com> <58cb370e0701200947p578f4d74g1fee511ded6c9a77@mail.gmail.com> <45B25DB7.8050903@gmail.com>
In-Reply-To: <45B25DB7.8050903@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>The other advantage of doing cleanups is that code becomes cleaner/simpler
>>>which matters a lot for this codebase, i.e. ide-dma-off-void.patch exposed
>>>(yet to be fixed) bug in set_using_dma() (->ide_dma_off_quietly always returns
>>>0 which is passed by ->ide_dma_check to set_using_dma() which incorrectly
>>>then calls ->ide_dma_on).

>>   Well, this seems a newly intruduced bug.

> The old code is so convulted that it is hard to see it w/o cleanup. :)

> ->ide_dma_check implementations often do

> 		return hwif->ide_dma_off_quietly(drive);

> so the return value of ide_dma_off_quietly() (which is always 0) is passed to

> 			if (HWIF(drive)->ide_dma_check(drive)) return -EIO;

> in ide.c:set_using_dma() -> as a result the next line is executed

> 			if (HWIF(drive)->ide_dma_on(drive)) return -EIO;

    So, the error seems to call hwif->ide_dma_on() after hwif->ide_dma_check() 
since hwif->ide_dma_check() must've already called that.

MBR, Sergei
