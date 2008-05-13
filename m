Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYEMIVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYEMIVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbYEMIUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:20:52 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:46831 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbYEMIUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:20:50 -0400
X-IronPort-AV: E=Sophos;i="4.27,478,1204520400"; 
   d="scan'208";a="68195000"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected ifbuilt in Bluetooth CF driver
Date: Tue, 13 May 2008 09:20:39 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D015A1866@limkexm3.ad.analog.com>
In-Reply-To: <1210597828.16390.44.camel@violet.holtmann.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected ifbuilt in Bluetooth CF driver
Thread-Index: Aci0MZMe9Bn7l449QXqwO7uGKPIGtgAnzUwg
References: <1210587779-10257-1-git-send-email-cooloney@kernel.org> <1210597828.16390.44.camel@violet.holtmann.net>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Marcel Holtmann" <marcel@holtmann.org>, "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-bluetooth@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 13 May 2008 08:20:41.0136 (UTC) FILETIME=[3B511300:01C8B4D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Montag, 12. Mai 2008 15:10
>To: Bryan Wu
>Cc: linux-bluetooth@vger.kernel.org; linux-kernel@vger.kernel.org;
Michael
>Hennerich
>Subject: Re: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected
>ifbuilt in Bluetooth CF driver
>
>Hi Brian,
>
>> https://blackfin.uclinux.org/gf/project/uclinux-
>dist/tracker/?action=TrackerItemEdit&tracker_item_id=2650
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/bluetooth/bluecard_cs.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/bluetooth/bluecard_cs.c
>b/drivers/bluetooth/bluecard_cs.c
>> index bcf5792..3b330a0 100644
>> --- a/drivers/bluetooth/bluecard_cs.c
>> +++ b/drivers/bluetooth/bluecard_cs.c
>> @@ -867,7 +867,7 @@ static int bluecard_probe(struct pcmcia_device
*link)
>>
>>  	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
>>  	link->io.NumPorts1 = 8;
>> -	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
>> +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
IRQ_HANDLE_PRESENT;
>>  	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
>>
>>  	link->irq.Handler = bluecard_interrupt;
>
>all Bluetooth PCMCIA drivers use an exclusive IRQ:
>
>bluecard_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>IRQ_HANDLE_PRESENT;
>bt3c_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
IRQ_HANDLE_PRESENT;
>btuart_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
>IRQ_HANDLE_PRESENT;
>dtl1_cs.c:	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE |
IRQ_HANDLE_PRESENT;
>
>There was a reason for that when these drivers where written. I am not
>sure if it is still valid or not. Does anybody at least have tested
that
>the cards still work if you use a shared IRQ.
>
>Regards
>
>Marcel

Please disregard this patch. It's a leftover and not really necessary.
Some time ago the Blackfin PCMCIA driver also requested the Card IRQ in
order to shut up some irq handling noise. However this is no longer the
case.

Best regards,
Michael

