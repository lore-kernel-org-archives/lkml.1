Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0BMOfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 09:35:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:28551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0BMOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 09:35:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,467,1262592000"; 
   d="scan'208";a="243776707"
From: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
To: "avorontsov@ru.mvista.com" <avorontsov@ru.mvista.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 13 Feb 2010 20:05:29 +0530
Subject: RE: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Topic: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Index: AcqTBaK4bYz2aSiiTmGEOPxTBgXXDAC0Z3PgBbY/smA=
Message-ID: <175E0F9A9EFCEA46A65F5552BB057298046D05F9A2@bgsmsx502.gar.corp.intel.com>
References: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
 <20100111213242.GA3985@oksana.dev.rtsoft.ru>
 <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1DEaPmE015746

Hi Anton,

First of all apologize for not sticking to my word to get back with
the patch as promised. Got tied up with some important work and could
not spend time on this patch.

I have started making changes today and will be testing it out after
the weekend. Will post the patch for review by mid next week for sure.

OK now to a question I had while working on the patch:

>>> +       schedule_work(&pbi->handler);
>> 
>> I think you can use threaded irq for this.
>> 
>> See documentation for request_threaded_irq() in kernel/irq/manage.c.
>> And as an example of usage see drivers/mfd/wm8350-irq.c.
> 
> Haa that is useful information... completely missed to read about this 
> feature. Will modify the code to make use of threaded IRQ.

I have a very peculiar case - My hardware muxes 8 different types of 
battery interrupts as one before forwarding it. I do the interrupt 
de-muxing in the driver to find its real source; because I do this I 
had used workqueue to make sure I do not keep the battery interrupt 
source disabled for a long time and won't potential miss a battery 
interrupt.
I was reading the request_threaded_irq code and found that only 
when the threaded function returns interrupt should be re-enabled 
(as it is suggested in the APIs function comment). Now if I do this, 
won't I potential miss a interrupt?

Also I failed to understand what exact scenario request_threaded_irq 
is useful over having a workqueue spawned inside a interrupt handler? 
Is it only when you want to hold the interrupt EOI until the threaded  
function returns?

Please shout back if I am making some stupid assumptions here.

Regards,
Nithish Mahalingam

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
