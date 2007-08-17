Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXHQWC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXHQWC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXHQWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:02:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:16004 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbXHQWCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:02:48 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48714028:sNHT29542863"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 23:02:44 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0D87BDCE@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Thread-Index: AcfhFbZp9trnqGnjR0iEJiaBTTEClgAAbKPQ
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, "Bryan Wu" <bryan.wu@analog.com>,
       <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 17 Aug 2007 22:02:47.0657 (UTC) FILETIME=[58AE5D90:01C7E11A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>
>On Friday 17 August 2007, Hennerich, Michael wrote:
>> What Mike wants to point out is that a external IRQ is first a GPIO
and
>> needs to be configured like an INPUT GPIO and then a specific bit
needs
>> to be set unmask it as IRQ.
>>
>> So why not use the GPIO infrastructure to setup this pin as GPIO?
>
>My comments about the advantages of using that infrastructure
>for *early* binding captured the key points ... it's "failfast".
>
>For IRQs you're probably on decently firm ground, since it's
>extremely rare that people not handle request_irq() errors.
>
>Remember, I just pointed out that the "late fail" strategy
>is unusual.  That doesn't mean it's wrong ... just it'll be
>a bit of surprise, some cognitive dissonance to developers
>picking up a Blackfin project, potentially more error prone.
>

Dave,

Thanks - we really appreciate your feedback.
Please believe me - since a great while we have similar internal
discussion how we should handle these things.

Things need to be DAU proof.

We rather prefer having some verbal runtime messages, than having a
system that doesn't do what expected and being silent.
(The bootloader doesn't know what kernel modules are being loaded
requiring specific HW setup) 

We also don't fear the memory overhead (compared to the support
overhead), the runtime overhead is almost neglectable since these
functions are only called once, best case twice (module remove).

I see your points - I would prefer having a fix function board suiting
all our customers' needs - or something like an x86 system where
everything is fixed or dedicated and abstracted by IO/Memory and IRQ.

-Michael 

  


>- Dave
