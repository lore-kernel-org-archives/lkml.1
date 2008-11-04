Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbYKDSfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbYKDSfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYKDSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:34:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:48023 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbYKDSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:34:50 -0500
Message-ID: <491095C4.3000503@ru.mvista.com>
Date: Tue, 04 Nov 2008 21:34:44 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ide: rework handling of serialized ports
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <20081103200326.5098.2058.sendpatchset@localhost.localdomain> <491094B2.4090107@ru.mvista.com>
In-Reply-To: <491094B2.4090107@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> Index: b/drivers/ide/ide-probe.c
>> ===================================================================
>> --- a/drivers/ide/ide-probe.c
>> +++ b/drivers/ide/ide-probe.c

> [...]

>> @@ -1436,10 +1398,8 @@ static void ide_init_port(ide_hwif_t *hw
>>      }
>>  
>>      if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
>> -        ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
>> -        if (hwif->mate)
>> -            hwif->mate->serialized = hwif->serialized = 1;
>> -    }
>> +        ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base))
>> +        hwif->host_flags |= IDE_HFLAG_SERIALIZE;

>    I don't see what use is forcing this flag at all here -- it doesn't 
> seem to be checked only in init_irq() now, so this *if* could just be 
> moved there...

    Oops, rephrasing hurts sometimes: I meant "it seems", of course. :-)

MBR, Sergei
