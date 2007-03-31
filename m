Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbXCaIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbXCaIBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXCaIBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:01:51 -0400
Received: from smtp-4.hut.fi ([130.233.228.94]:36690 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXCaIBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:01:50 -0400
Date: Sat, 31 Mar 2007 11:00:52 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/5] RT kernel: force detect HPET from PCI space
In-Reply-To: <1175294288.32441.6.camel@rousalka.dyndns.org>
Message-ID: <Pine.OSF.4.64.0703311053330.412261@kosh.hut.fi>
References: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
 <1175294288.32441.6.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at putosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007, Nicolas Mailhot wrote:

> Le samedi 31 mars 2007 à 01:09 +0300, Mikko Tiihonen a écrit :
>>> Anyone got the same thing for CK804? I had my hopes high, and then I saw
>>> the DECLARE_PCI_FIXUP_HEADER values [and the thread title was misleading]
>>
>> I have an A8N-E motherboard with AthlonX2 and the ACPI definitions are
>> missing the HPET (standard feature of Asus motherboards).
>>
>> I too got interested to get my motherboard working. Luckily I found this
>> http://lkml.org/lkml/2006/12/17/69
>
> Oh, is looks so close to my system
>
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
>        Subsystem: Giga-byte Technology GA-K8N Ultra-9 Mainboard
>        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
> 00: de 10 50 00 0f 00 a0 00 a3 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
>                ^^^^^^^^^^^
>                Usual HPET base address
> 50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
> 60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
> 70: 10 00 ff ff c1 00 00 00 00 00 04 19 18 d2 80 0d
>                ^^
>                c1 => HPET disabled (according to your reference)
>
> I don't have an HPET toggle in my bios
>
>> from which I generated the following patch:
>
> I'd love to test it, but what kernel baseline did you use?
> 2.6.21-rc5-mm2?

No, I could not get the original patches to apply to any new kernel. They did 
apply to 2.6.20-mm2 with very minimal collisions.

I only applied patches 1/5 and 2/5 of the original series. But now that I look 
into patch 3/5 it seems that it has useful irq allocation things.

Anyway, I think the best way would be to get 2.6.20-rt8 against which the 
original patch series was made. Add all 5 patches from Venkatesh and then try 
with my patch added. I'll try that myself later today.

-Mikko
