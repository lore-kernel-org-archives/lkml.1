Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYBSMWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYBSMWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYBSMWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:22:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:52096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYBSMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:22:12 -0500
Message-ID: <47BAC9EA.1070305@anagramm.de>
Date: Tue, 19 Feb 2008 13:22:02 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, valdis.kletnieks@vt.edu
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign endianness
References: <20080205154432.GA8749@localhost.localdomain>	<20080214224942.a0cb6218.akpm@linux-foundation.org>	<20080215164542.GB16810@localhost.localdomain>	<Pine.LNX.4.64.0802171030330.6848@anakin>	<20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>	<19805.1203355811@turing-police.cc.vt.edu>	<47BA162C.5000807@anagramm.de>	<1203381353.6740.59.camel@pasglop>	<47BABD3A.7010102@anagramm.de> <20080219040530.7b1d115d.akpm@linux-foundation.org>
In-Reply-To: <20080219040530.7b1d115d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+VQ7If0oRkxnY7wxY1f7RMt9jjLcOh7nuP28n
 s86Sl7lNEwm4djWoXGw+wmsopQ4qMj73ZHeoa26WmwsPm9wEm4
 HSR/RXZHXYUOiTcDl1PDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Tue, 19 Feb 2008 12:27:54 +0100 Clemens Koller <clemens.koller@anagramm.de> wrote:
>> Benjamin Herrenschmidt schrieb:
>>> On Tue, 2008-02-19 at 00:35 +0100, Clemens Koller wrote:
>>>> Valdis.Kletnieks@vt.edu schrieb:
>>>>> On Mon, 18 Feb 2008 08:18:47 +0100, Krzysztof Helt said:
>>>>>> I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
>>>>>> Both resolve endianess at driver level. Actually, both handle it by setting special
>>>>>> bits so the graphics chip itself reorder bytes to transform foreign endianess. 
>>>>>> I understand that this patch is for chips which cannot reorder bytes by themselves.
>>>>> Does anybody know of such a chip that's actually available in the wild?  Or are
>>>>> we writing drivers for speculative possible chips?
>>>>>
>>>> I had troubles with the Silicon Motion SM501/SM502 endianess on PowerPC PCI vs. LocalBus.
>>>> The chip also has a register to swap endianess, but that seems to only affect some
>>>> LocalBus modes.
>>>> The current fb and X drivers are working, but when it comes to font
>>>> aliasing and hw-acceleration, the problems start to rise again...
>>> Most "sane" gfx chips nowadays provide configurable surfaces that allow
>>> to perform the swap when writing/reading from regions of the
>>> framebuffer, with the ability to set a different swapper setting (based
>>> on bit depth) per region.
>> Most! But not the SM50x. I still hope I would be wrong here. :-(
>>
>>> Then there is also the risk that your PCI<->Localbus has been wired
>>> improperly :-)
>> That's not an issue in my case. The SM50x can be connected to
>> either an PCI or some Local/CPU-whateverbus IF.
>> I.e. on the MPC85xx PowerPC, PCI and LocalBus are separate bussses.
>> If the sm501 is attached to the MPC85xx' PCI like any other video card,
>> the PCI config-space is can be accessed as usual, whereas the framebuffer
>> memory area is byte-swapped compared to other common video cards.
>>
>> So, to get back on topic:
>> I would welcome endianess swapping in SW. Some architectures (PowerPC)
>> should also be able to do swapped-endian mmapping. I just haven't
>> had time for a closer look but it looks also interesting way to do it
>> that way.
> 
> Bizarrely, the original author of the patch (Anton) has fallen off the cc. 
> Could whoever did that please thwap himself?

Propably my bad, being subscribed to several CCed lists...

> Anyway, my head is now officially spinning.  Did anyone actually have a
> reason why we shouldn't proceed with Anton's patch?

Since it seem that there are some odd chips out in the wild, I guess
Valdis (also readded to CC:) has no more objections to give it a try. :-)

Regards,

Clemens
