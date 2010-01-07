Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429Ab0AGL6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0AGL6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291Ab0AGL6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:58:11 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:63516 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551Ab0AGL6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:58:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.49,234,1262559600";   d="scan'208";a="40023903"
Message-id: <4B45CC4C.4030603@nets.rwth-aachen.de>
Date: Thu, 07 Jan 2010 12:58:04 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       Daniel Mack <daniel@caiaq.de>, LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
 <1262861484.8493.14.camel@dax.rpnet.com>
In-reply-to: <1262861484.8493.14.camel@dax.rpnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie schrieb:
> On Thu, 2010-01-07 at 11:26 +0100, Arnd Hannemann wrote:
>> with 2.6.33-rc3 the LEDs are not working anymore on my Geode embedded board:
>> If I remember correctly this was working fine with 2.6.32, but certainly with 2.6.31
>>
>> relevant dmesg output of 2.6.33-rc3:
>>
>> [    0.709643] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
>>
>> [    2.207947] leds_alix2: system is recognized as "PC Engines ALIX.2 v0.99h"
>> [    2.228678] leds_alix2: can't allocate I/O for GPIO
>>
>>
>> For reference dmesg of 2.6.31.3:
>>
>> [    0.611953] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
>>
>> [    2.379114] leds_alix2: system is recognized as "PC Engines ALIX.2"
>> [    2.399097] Registered led device: alix:1
>> [    2.411404] Registered led device: alix:2
>> [    2.423720] Registered led device: alix:3
> 
> Its likely to be commit 7f131cf3ed96c969d7b092bf629e25c3df50901e. It
> looks like the request_region() call is failing. Daniel, any idea why?

Some additional debug information:

elara:~# rdmsr 0x5140000C
f00100006100

/proc/ioports says:
6100-61ff : 0000:00:0f.0
  6100-61ff : cs5535_gpio

BTW: why is request_region() needed there after all?

Best regards,
Arnd
