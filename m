Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZKCVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZKCVXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZKCVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:23:08 -0500
Received: from khc.piap.pl ([195.187.100.11]:55100 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbZKCVXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:23:07 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, Imre Kaloz <kaloz@openwrt.org>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IXP4xx: Ensure index is positive
References: <4AF08014.4000704@gmail.com> <4AF0922B.3030701@hiramoto.org>
Date: Tue, 03 Nov 2009 22:23:07 +0100
In-Reply-To: <4AF0922B.3030701@hiramoto.org> (Karl Hiramoto's message of "Tue,
	03 Nov 2009 21:27:23 +0100")
Message-ID: <m3eiofl2v8.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto <karl@hiramoto.org> writes:

>> +++ b/arch/arm/mach-ixp4xx/common.c
>> @@ -119,7 +119,7 @@ EXPORT_SYMBOL(gpio_to_irq);
>>   int irq_to_gpio(int irq)
>>  {
>> -	int gpio = (irq < 32) ? irq2gpio[irq] : -EINVAL;
>> +	int gpio = (irq < 32 && irq >= 0) ? irq2gpio[irq] : -EINVAL;
>>   	if (gpio == -1)
>>  		return -EINVAL;

>> +++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
>> @@ -667,7 +667,7 @@ err:
>>   struct npe *npe_request(int id)
>>  {
>> -	if (id < NPE_COUNT)
>> +	if (id >= 0 && id < NPE_COUNT)

> changing npe_request() to unsigned would probably be better and  not
> add to bloat.   If your calling these functions with negative
> arguments, your code is buggy then.

Right. Both files in fact.

Even the id < NPE_COUNT test is probably not needed but I can imagine
someone lowering NPE_COUNT. Negative values are unreasonable (though
unsigned type make this unrelevant, of course).
-- 
Krzysztof Halasa
