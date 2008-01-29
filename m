Return-Path: <linux-kernel-owner+w=401wt.eu-S1764395AbYA2OYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395AbYA2OYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYA2OYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:24:40 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:21199 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752112AbYA2OYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:24:39 -0500
Message-ID: <479F36B9.2050308@ru.mvista.com>
Date: Tue, 29 Jan 2008 17:22:49 +0300
From: Valentine Barshak <vbarshak@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, linuxppc-dev@ozlabs.org, sr@denx.de,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
References: <4797C1AD.3040307@tiscali.nl> <20080123191704.2d74073a@zod.rchland.ibm.com>
In-Reply-To: <20080123191704.2d74073a@zod.rchland.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> On Wed, 23 Jan 2008 23:37:33 +0100
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
>> logical/bitand typo
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
>> index ebf9e21..dcfb459 100644
>> --- a/arch/powerpc/boot/4xx.c
>> +++ b/arch/powerpc/boot/4xx.c
>> @@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
>>  	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
>>  	cs = 0;
>>  	while (val) {
>> -		if (val && 0x1)
>> +		if (val & 0x1)
>>  			cs++;
>>  		val = val >> 1;
>>  	}
> 
> Hm, good catch.

Yes, thanks!

Sequoia and Rainier are currently the only boards using denali 
controller and have both chipselects enabled (val = 0x3).
In this case the problem doesn't show up and we still get the right cs 
value.
Thanks,
Valentine.

> 
> Stefan, have you had problems with this code at all?
> 
> josh
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

