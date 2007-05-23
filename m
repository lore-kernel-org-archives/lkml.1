Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbXEWSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbXEWSrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbXEWSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:47:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40145 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXEWSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=EdCLpCcC495nzIJQQ/ablSwC9ybYvtviUKoGYeagEaYg6FBbPx86pFFpLyLLvyldh/O4mnXEwOyWAATJHgmLA89JD9pW+im8qbgKQ+KtPDMb0k2KOsQ+vApG5pSwK4GEqX93ZXV1JjjKHL35m+e9pzxsqkjqgU/RRvBxtNTMSHY=
Message-ID: <46548C2A.5050006@gmail.com>
Date: Wed, 23 May 2007 20:47:06 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com>	<464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com>	<4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com>	<4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com>	<4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com>	<46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu>
In-Reply-To: <20070523150229.00a0c3c4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>   http://thread.gmane.org/gmane.linux.kernel/530099
>>>
>>> It seems we're losing interrupts from the CFA device.  Any ideas?
>>>       
>> Alan probably knows more, but ISTR some CFA PCMCIA devices that needed 
>> polling...
>>     
>
> Not that I know of. Not devices anyway - there are embedded boxes with no
> IRQ configuration for the CF slot but we've never supported those (indeed
> there are even people who bitbang ATA on GPIO pins...)
>
>   
So my understanding is, that although some issues with the libata pcmcia 
code where found, the latest issue is a pure pcmcia issue?
Anything I can supply or test to further narrow down the problem?
I have already posted lspci -vxxx and full dmesg log to the linux-kernel 
list, but here are some select pieces of it....

Yenta: CardBus bridge found at 0000:02:00.0 [1014:0552]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.0, mfunc 0x01d21b22, devctl 0x64
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000086
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
PM: Adding info for No Bus:pcmcia_socket0
Yenta: CardBus bridge found at 0000:02:00.1 [1014:0552]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:00.1, mfunc 0x01d21b22, devctl 0x64
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000086
pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
cs: IO port probe 0x4000-0x8fff: clean.
pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
PM: Adding info for No Bus:pcmcia_socket1

cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7 clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.

02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus 
Controller (rev 01)

        Subsystem: IBM Unknown device 0552
        Flags: bus master, medium devsel, latency 168, IRQ 11
        Memory at b0000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: e8000000-ebfff000 (prefetchable)
        Memory window 1: c4000000-c7fff000
        I/O window 0: 00004000-000040ff
        I/O window 1: 00004400-000044ff
        16-bit legacy interface ports at 0001
00: 4c 10 46 ac 07 00 10 02 01 00 07 06 20 a8 82 00
10: 00 00 00 b0 a0 00 00 02 02 03 06 b0 00 00 00 e8
20: 00 f0 ff eb 00 00 00 c4 00 f0 ff c7 00 40 00 00
30: fc 40 00 00 00 44 00 00 fc 44 00 00 0b 01 c0 05
40: 14 10 52 05 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 71 d0 40 08 00 00 0a 04 00 00 0f 00 22 1b d2 01
90: c0 02 64 41 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 12 fe 00 00 c0 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus 
Controller (rev 01)
        Subsystem: IBM Unknown device 0552
        Flags: bus master, medium devsel, latency 168, IRQ 11
        Memory at b1000000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=07, subordinate=07, sec-latency=176
        Memory window 0: ec000000-effff000 (prefetchable)
        Memory window 1: c8000000-cbfff000
        I/O window 0: 00004800-000048ff
        I/O window 1: 00004c00-00004cff
        16-bit legacy interface ports at 0001
00: 4c 10 46 ac 07 00 10 02 01 00 07 06 20 a8 82 00
10: 00 00 00 b1 a0 00 00 02 02 07 07 b0 00 00 00 ec
20: 00 f0 ff ef 00 00 00 c8 00 f0 ff cb 00 48 00 00
30: fc 48 00 00 00 4c 00 00 fc 4c 00 00 0b 02 c0 05
40: 14 10 52 05 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 71 d0 40 08 00 00 0a 04 00 00 0f 00 22 1b d2 01
90: c0 02 64 41 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 12 fe 00 00 c0 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
