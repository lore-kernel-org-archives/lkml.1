Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbZJOA4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbZJOA4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761479AbZJOA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:56:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:59572 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZJOA4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:56:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,562,1249282800"; 
   d="scan'208";a="736482929"
From: "Du, Alek" <alek.du@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Oct 2009 08:52:47 +0800
Subject: RE: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
Thread-Topic: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
Thread-Index: AcpM8Mingc4IvxxfRAi7dJxk4UeYlQAQGJPA
Message-ID: <EADF0A36011179459010BDF5142A457501CEC48ECB@pdsmsx502.ccr.corp.intel.com>
References: <4AD33958.7020900@gmail.com>
	 <20091012151127.312c986a.akpm@linux-foundation.org>
	 <EADF0A36011179459010BDF5142A457501CEB8C146@pdsmsx502.ccr.corp.intel.com>
	 <20091013105901.972f7dbe.akpm@linux-foundation.org>
	 <EADF0A36011179459010BDF5142A457501CEC48A68@pdsmsx502.ccr.corp.intel.com>
 <25e057c00910140850j787e9fd6lcd6ac236a0f4851d@mail.gmail.com>
 <EADF0A36011179459010BDF5142A457501CEC48E76@pdsmsx502.ccr.corp.intel.com>
 <4AD60776.5090404@gmail.com>
In-Reply-To: <4AD60776.5090404@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Roel Kluin [mailto:roel.kluin@gmail.com]
>Sent: Thursday, October 15, 2009 1:17 AM
>To: Du, Alek; Andrew Morton; LKML
>Subject: Re: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
>
>The wrong test was used, gpio is unsigned. Also lnw->chip.ngpio is
>set to 64, so if gpio equals that, then reg (= gpio / 32) becomes 2,
>an index out of bounds for GRER and GFER that have 2 elements.
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>---
>>>>> From: Andrew Morton [mailto:akpm@linux-foundation.org]
>>>>>> -    if (gpio < 0 || gpio > lnw->chip.ngpio)
>>>>>> +    if (gpio > lnw->chip.ngpio)
>>>>>>              return -EINVAL;
>>>>>
>>>>> Should that be >= ?
>
>> Oh, my bad. Andrew is right, should be >=...
>
>Ok, how about this then?
>
>diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
>index 5711ce5..72af3fc 100644
>--- a/drivers/gpio/langwell_gpio.c
>+++ b/drivers/gpio/langwell_gpio.c
>@@ -123,7 +123,7 @@ static int lnw_irq_type(unsigned irq, unsigned type)
> 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
> 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
>
>-	if (gpio < 0 || gpio > lnw->chip.ngpio)
>+	if (gpio >= lnw->chip.ngpio)
> 		return -EINVAL;
> 	spin_lock_irqsave(&lnw->lock, flags);
> 	if (type & IRQ_TYPE_EDGE_RISING)

Acked-by: Alek Du <alek.du@intel.com>



