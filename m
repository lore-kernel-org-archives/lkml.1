Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYE0Ptz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYE0Ptz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYE0Ptr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:49:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:54858 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbYE0Ptq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KaP/KoePjDQxt1ZjjOQkFLUABfvz/oonNsF2EHtC9tFwKgW+K6WuFqSxRyNoO5iBRl6fTxCB1exGBrRcfGm/3k8I4c+8PdLfCoOaQur1x5eAunavv29blrwEeweMVIHwTOr+oWJof8MpSxd/Lnxrk4KzN5BcP9wiI0KVz3L58zw=
Message-ID: <386072610805270849g1374e88l8c973733d90b37bb@mail.gmail.com>
Date: Tue, 27 May 2008 23:49:45 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, akpm@linux-foundation.org,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D01C39939@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	 <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
	 <8bd0f97a0805211634r41cd2bafp94615fdfbdd4b7f7@mail.gmail.com>
	 <8A42379416420646B9BFAC9682273B6D01C39939@limkexm3.ad.analog.com>
X-Google-Sender-Auth: f9f55f49759a15df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 7:15 PM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
>
>
>>-----Original Message-----
>>From: Mike Frysinger [mailto:vapier.adi@gmail.com]
>>Sent: Donnerstag, 22. Mai 2008 01:34
>>To: Bryan Wu; michael.hennerich@analog.com
>>Cc: akpm@linux-foundation.org; Linux Kernel List
>>Subject: Re: +
> pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-
>>2.patch added to -mm tree
>>
>>On Tue, May 20, 2008 at 3:51 AM, Bryan Wu <cooloney@kernel.org> wrote:
>>> On Tue, May 20, 2008 at 2:08 PM,  <akpm@linux-foundation.org> wrote:
>>>> +config BFIN_CFPCMCIA
>>>> +       tristate "Blackfin CompactFlash PCMCIA Driver"
>>>> +       depends on PCMCIA && BLACKFIN
>>>> +       help
>>>> +         Say Y here to support the CompactFlash PCMCIA driver for
>>Blackfin.
>>
>>please add a common statement that tells you the module name if the
>>user builds it as a module.
>>
>>>> + * author: Michael Hennerich (hennerich@blackfin.uclinux.org)
>>
>>shouldnt this be MODULE_AUTHOR() ?
>
> Yes.
>
>>
>>>> +       u_int irq;
>>>> +       u_short cd_pfx;
>>
>>u_int forms are weird ... i'd wonder why we have these variations
>>anywhere in the kernel
>
> Beauty is in the eye of the beholder...
>
>>
>>>> +static int __init bfin_cf_probe(struct platform_device *pdev)
>>
>>should be __devinit
>>
>>>> +       cd_pfx = platform_get_irq(pdev, 1);     /*Card Detect GPIO
> PIN
>>*/
>>>> +       if (cd_pfx > MAX_BLACKFIN_GPIOS)
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (gpio_request(cd_pfx, "pcmcia: CD")) {
>>
>>i dont think that MAX_BLACKFIN_GPIOS check is needed.  the
>>gpio_request() function should already be doing it.
>>
>>>> +               printk(KERN_ERR
>>>> +                      "BF5xx flash: Failed ro request Card Detect
>>GPIO_%d\n",
>>
>>"BF5xx flash" ?
>>
>>>> +       cf = kzalloc(sizeof *cf, GFP_KERNEL);
>>>> +       if (!cf)
>>>> +               return -ENOMEM;
>>
>>we dont call gpio_free() here or in the fail0 case below.
>
> Fixed.
>
> Bryan,
>  are you going to send a new patch?
>

No problem, I will take care of it.

-Bryan
