Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0CIC0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:26:00 -0500
Received: from mail-yx0-f191.google.com ([209.85.210.191]:41349 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0CICZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:25:58 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 21:25:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JSA/8UM0uCton7y15zmJ0SLUVGHZKdVC1Fkl3kHHo0cVjDz1wWMfTqhHSsaqnu2LIw
         0D17lo05RSo3lgnmXs4KSkhSj/kuXpz4ohLpZlVBkLYV7eHbmluLNY8X8qItuDNbg7tp
         pCg3ga14Et+hj5X1orKwNYxOvsV9KN9ng82v0=
Message-ID: <4B95B028.3050106@gmail.com>
Date: Mon, 08 Mar 2010 20:19:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Lamanna <jlamanna@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com> <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
In-Reply-To: <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 03:13 PM, James Lamanna wrote:
> On Mon, Mar 8, 2010 at 11:07 AM, James Lamanna<jlamanna@gmail.com>  wrote:
>> Hi,
>> I recently purchased a SIIG DP CyberSerial 4S PCIe card, however the
>> kernel doesn't seem to recognize it.
>> There are no messages in dmesg or anything about it.
>> Currently I'm at 2.6.24, but looking at drivers/serial/8250_pci.c
>> between 2.6.24 and 2.6.32 there doesn't
>> seem to be real changes with SIIG cards.
>> Seems like other SIIG cards are supported, so are we just missing the
>> PCI IDs for this card?
>>
>> Here's the lspci -nnvvvvvv output:
>>
>> 01:00.0 Serial controller [0700]: Oxford Semiconductor Ltd Unknown
>> device [1415:c208] (prog-if 06 [16950])
>>         Subsystem: Siig Inc Unknown device [131f:2250]
>>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-
>> <TAbort-<MAbort->SERR-<PERR-
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at fe8fc000 (32-bit, non-prefetchable) [size=16K]
>>         Region 1: Memory at fe600000 (32-bit, non-prefetchable) [size=2M]
>>         Region 2: Memory at fe400000 (32-bit, non-prefetchable) [size=2M]
>>         Capabilities: [40] Power Management version 3
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA
>> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [70] Express Endpoint IRQ 0
>>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>>                 Device: Latency L0s<128ns, L1<2us
>>                 Device: AtnBtn- AtnInd- PwrInd-
>>                 Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
>>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>>                 Link: Latency L0s<512ns, L1<64us
>>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>>                 Link: Speed 2.5Gb/s, Width x1
>>         Capabilities: [b0] MSI-X: Enable- Mask- TabSize=16
>>                 Vector table: BAR=1 offset=001b3000
>>                 PBA: BAR=1 offset=001b2000
>
> After some more digging I found these messages in dmesg which doesn't
> exactly sound good:
>
> [   52.104180] ACPI: PCI Interrupt 0000:01:00.0[A] ->  GSI 16 (level,
> low) ->  IRQ 16
> [   52.104189] ACPI: PCI interrupt for device 0000:01:00.0 disabled
>
> 01:00.0 is the device ID of the SIIG card.
> Any reason ACPI would disable interrupts for this card?

Probably just means some driver temporarily decided to enable the 
interrupt, then disabled it (maybe because it decided it couldn't run 
the device?)
