Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXGUTwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXGUTwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbXGUTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:52:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbXGUTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:52:43 -0400
Message-ID: <46A263FA.70501@zytor.com>
Date: Sat, 21 Jul 2007 12:52:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070721181137.GH4152@rhun.haifa.ibm.com>
In-Reply-To: <20070721181137.GH4152@rhun.haifa.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> 
> Mostly looks good, but see below.
> 
>> diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
>> index df8da72..41f46df 100644
>> --- a/drivers/char/agp/efficeon-agp.c
>> +++ b/drivers/char/agp/efficeon-agp.c
>> @@ -221,7 +221,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
>>  		SetPageReserved(virt_to_page((char *)page));
>>  
>>  		for (offset = 0; offset < PAGE_SIZE; offset += clflush_chunk)
>> -			asm volatile("clflush %0" : : "m" (*(char *)(page+offset)));
>> +			clflush((char *)page+offset);
> 
> The original code flushes (*(page+offset)) whereas the new code
> flushes (pagee+offset). Assuming this is a bug-fix, it should go as a
> separate patch.
> 

No, it doesn't.  There is a * in the inline, as there should be.

	-hpa
