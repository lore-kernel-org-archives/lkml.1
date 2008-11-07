Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYKGEHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYKGEHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYKGEHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:07:40 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:49392 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKGEHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FXWlJ6zlgQe60je2lquHmd9xYbVSk9cywXJXxytgaEo2Phc1YssLDz5vo3FAw6trx/
         wo5u0pVyghRBjh1nxESzq7pO/rSftPho5sllJDNeMXaYzS6oZbhZQeLNIVp1DNx5eQbp
         IjEPw8QHzDpy4tirZlhi0oEPIc7czNWJ9QAms=
Message-ID: <386072610811062000i37a34e71yf96d1325fdd8c012@mail.gmail.com>
Date: Fri, 7 Nov 2008 12:00:08 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] USB/ISP1760: Add support for the generic platfrom device centralized driver model
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0649D8D0@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225963549-9892-1-git-send-email-cooloney@kernel.org>
	 <20081106175705.GA4687@www.tglx.de>
	 <8A42379416420646B9BFAC9682273B6D0649D8D0@limkexm3.ad.analog.com>
X-Google-Sender-Auth: a9a6aee77a7bfa14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 3:29 AM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
> Sebastian,
>
> Thanks for your feedback, see my comments below.
> We will resubmit a patch soon.
>
> Thanks and best regards,
> Michael
>
>
>>-----Original Message-----
>>From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
>>Sent: Thursday, November 06, 2008 6:57 PM
>>To: Bryan Wu
>>Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
>>Hennerich
>>Subject: Re: [PATCH] USB/ISP1760: Add support for the generic platfrom
>>device centralized driver model
>>
>>* Bryan Wu | 2008-11-06 17:25:49 [+0800]:
>>
>>>From: Michael Hennerich <michael.hennerich@analog.com>
>>>
>>>Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>>>Signed-off-by: Bryan Wu <cooloney@kernel.org>
>>>---
>>> drivers/usb/host/isp1760-if.c |   98
>>+++++++++++++++++++++++++++++++++++++++++
>>> 1 files changed, 98 insertions(+), 0 deletions(-)
>>>
>>>diff --git a/drivers/usb/host/isp1760-if.c
> b/drivers/usb/host/isp1760-if.c
>>>index af849f5..dc16698 100644
>>>--- a/drivers/usb/host/isp1760-if.c
>>>+++ b/drivers/usb/host/isp1760-if.c
>>>@@ -3,6 +3,7 @@
>>>  * Currently there is support for
>>>  * - OpenFirmware
>>>  * - PCI
>>>+ * - PDEV (generic platform device centralized driver model)
>>>  *
>>>  * (c) 2007 Sebastian Siewior <bigeasy@linutronix.de>
>>>  *
>>>@@ -23,6 +24,12 @@
>>> #include <linux/pci.h>
>>> #endif
>>>
>>>+#if !defined(CONFIG_USB_ISP1760_OF) &&
> !defined(CONFIG_USB_ISP1760_PCI)
>>>+#define USB_ISP1760_PDEV
>>Usually I would prefer to make it conditional on
>>CONFIGU_USB_ISP1760_PDEV. But since
>>http://marc.info/?l=linux-usb&m=122563596420156&w=2 I would prefer to
>>have unconditional.
>>Any reason why you only enable it PDEV if you have neiher PCI nor OF?
>
>
> Originally I had this kconfig option, but later decided to toss it.
> Why would you use pdev if you have PCI or OF, was my argument... :-)
> I'll add it back.
>
>>
>>>+#include <linux/platform_device.h>
>>>+#include <linux/usb/isp1760.h>
>>You can't include files which are not mainline
>
> My tree features this file.
> It simply misses in this patch.
>

My fault, I forgot to git-add this new isp1760.h before sending out this patch.

Michael, after you fix up this patch according to Sebastian, I will
send out the update version.

-Bryan
