Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZFXIgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZFXIgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZFXIgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:36:07 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:62669 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZFXIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:36:06 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7mseH1AU4KMzD7MA==
X-RZG-CLASS-ID: mo00
Message-ID: <4A41E56F.6030302@hartkopp.net>
Date: Wed, 24 Jun 2009 10:35:59 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: David Miller <davem@davemloft.net>, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] can: let SJA1000 driver depend on HAS_IOMEM
References: <20090623073120.GA5955@osiris.boeblingen.de.ibm.com>	<4A412C53.8050607@grandegger.com>	<4A41CD36.8030202@hartkopp.net> <20090624.000109.49664041.davem@davemloft.net> <4A41E31B.1030703@grandegger.com>
In-Reply-To: <4A41E31B.1030703@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Grandegger wrote:
> David Miller wrote:
>> From: Oliver Hartkopp <socketcan@hartkopp.net>

>>> the question is, if we should add HAS_IOMEM to almost every SJA1000 depended
>>> driver like SJA1000_PLATFORM, SJA1000_OF_PLATFORM, EMS_PCI and KVASER_PCI ???
>>>
>>> Is it possible to have a support for the SJA1000 that does *not* depend on
>>> HAS_IOMEM?
>
> In principle yes by using an appropriate driver accessing the SJA1000
> with other methods. But I might be wrong because it does not make sense
> hardware-wise.
>
>> This was my initial impression when I saw Wolfgang's suggested patch,
>> and I still feel this way, and thus Heiko's patch seems the best for
>> now until there is an exception.
>>
>> And in fact Heiko's patch has been in my tree for a while already :)
>
> OK, that's fine for the moment. We may even consider making CONFIG_CAN
> depend on HAS_IOMEM like for SPI, USB, Serial, etc.

Why CONFIG_CAN ??

CONFIG_CAN provides a network protocol family that can be used e.g. with the
vcan driver without any hardware. So HAS_IOMEM only has to take care of some
drivers, that fiddle on CAN controller registers themselves. E.g. for SPI, USB
and Serial these 'underlying' interfaces bring their own requirements. When we
depend on SPI, it should bring HAS_IOMEM as a dependency of SPI.

Regards,
Oliver


