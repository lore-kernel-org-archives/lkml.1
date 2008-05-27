Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYE0LPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYE0LPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYE0LPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:15:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1885 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbYE0LPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:15:33 -0400
X-IronPort-AV: E=Sophos;i="4.27,548,1204520400"; 
   d="scan'208";a="54161610"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Date: Tue, 27 May 2008 12:15:29 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D01C39939@limkexm3.ad.analog.com>
In-Reply-To: <8bd0f97a0805211634r41cd2bafp94615fdfbdd4b7f7@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to -mm tree
Thread-Index: Aci7mz0HTK+awGIRSqGrC4Obb94pbwETvyOg
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org> <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com> <8bd0f97a0805211634r41cd2bafp94615fdfbdd4b7f7@mail.gmail.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>, "Bryan Wu" <cooloney@kernel.org>,
       <michael.hennerich@analog.com>
Cc: <akpm@linux-foundation.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 May 2008 11:15:32.0031 (UTC) FILETIME=[FA291CF0:01C8BFEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Mike Frysinger [mailto:vapier.adi@gmail.com]
>Sent: Donnerstag, 22. Mai 2008 01:34
>To: Bryan Wu; michael.hennerich@analog.com
>Cc: akpm@linux-foundation.org; Linux Kernel List
>Subject: Re: +
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-
>2.patch added to -mm tree
>
>On Tue, May 20, 2008 at 3:51 AM, Bryan Wu <cooloney@kernel.org> wrote:
>> On Tue, May 20, 2008 at 2:08 PM,  <akpm@linux-foundation.org> wrote:
>>> +config BFIN_CFPCMCIA
>>> +       tristate "Blackfin CompactFlash PCMCIA Driver"
>>> +       depends on PCMCIA && BLACKFIN
>>> +       help
>>> +         Say Y here to support the CompactFlash PCMCIA driver for
>Blackfin.
>
>please add a common statement that tells you the module name if the
>user builds it as a module.
>
>>> + * author: Michael Hennerich (hennerich@blackfin.uclinux.org)
>
>shouldnt this be MODULE_AUTHOR() ?

Yes.

>
>>> +       u_int irq;
>>> +       u_short cd_pfx;
>
>u_int forms are weird ... i'd wonder why we have these variations
>anywhere in the kernel

Beauty is in the eye of the beholder... 

>
>>> +static int __init bfin_cf_probe(struct platform_device *pdev)
>
>should be __devinit
>
>>> +       cd_pfx = platform_get_irq(pdev, 1);     /*Card Detect GPIO
PIN
>*/
>>> +       if (cd_pfx > MAX_BLACKFIN_GPIOS)
>>> +               return -EINVAL;
>>> +
>>> +       if (gpio_request(cd_pfx, "pcmcia: CD")) {
>
>i dont think that MAX_BLACKFIN_GPIOS check is needed.  the
>gpio_request() function should already be doing it.
>
>>> +               printk(KERN_ERR
>>> +                      "BF5xx flash: Failed ro request Card Detect
>GPIO_%d\n",
>
>"BF5xx flash" ?
>
>>> +       cf = kzalloc(sizeof *cf, GFP_KERNEL);
>>> +       if (!cf)
>>> +               return -ENOMEM;
>
>we dont call gpio_free() here or in the fail0 case below.

Fixed.

Bryan,
 are you going to send a new patch?

-Michael

>-mike
