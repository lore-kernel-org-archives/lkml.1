Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZLVBGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZLVBGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZLVBGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:06:15 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:55292 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZLVBGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KZIHR17sTw0avr3rIRA5Bly/zL1BAn+V7J1ThCvX/vPhKRJlZDCaXvpxFT3QAjt1nj
         D9R8FF4+LSuRg/g7XIvzXox4ijzC7utJCTS1+KhrM9fisnOmdTZuTr7KSAnO8P0TXMVX
         FVBRQyEOScB7n8wa+WJKlnO9odFgTKGocIty4=
Message-ID: <4B301B83.1010207@gmail.com>
Date: Mon, 21 Dec 2009 19:06:11 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: Useless thermal acpi driver ?
References: <20091209232608.25aed4ca@werewolf.home>	<4B20483C.6090309@gmail.com>	<alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>	<20091211094515.4b4872ef@werewolf.home>	<alpine.LFD.2.00.0912142159540.9446@localhost.localdomain> <20091215234619.62d0ebc1@werewolf.home>
In-Reply-To: <20091215234619.62d0ebc1@werewolf.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 04:46 PM, J.A. Magallón wrote:
> On Mon, 14 Dec 2009 22:00:25 -0500 (EST), Len Brown<lenb@kernel.org>  wrote:
>
>> this DSDT returns a constant temperature, always:
>>
>>              Method (_TMP, 0, NotSerialized)
>>              {
>>                  Return (0x0BB8)
>>              }
>>
>>
>> so in this case, Linux is just reporting the (lack of) news:-)
>>
>
> So, lets see...:
>
> - Someone decided ACPI is the only-real-good-way
> - Only a few devices are ported to ACPI
> - The old way is unusable
> - We can not return to the old way

You can return to the "old way", that's what acpi_enforce_resources=lax 
is for. It won't be any more dangerous than it was before. The problem 
is that there's no way (at least, no simple one, it seems) to know if 
the BIOS is really going to access those registers it indicates it 
might. There are systems where it indeed does access them and this 
breaks things badly (causing problems like spurious thermal shutdowns).

What is the error that prevents w83627hf from loading? It might be 
useful to find what reference in the AML causes the detection that it 
may access the device registers.
	
>
> So, any solution ? Thermal ACPI info in this boards (and I suspect in many
> others) is useless. We can not disable that part of ACPI, we can not enable
> sensors. So no thermal monitoring.
> Nice.
>
> Ayways, as in this case the ACPI part does not any real work, is still
> present the problem of two drivers poking the same hardware or could I use
> that 'lax' trick ?
>
> And second, can the traditional sensor drivers be ported to offer an ACPI
> device replacing the default one, or is that a stupid question ?

It wouldn't make any sense. An ACPI driver would have to access some 
interface that the BIOS ACPI AML code provides to access the sensor 
data. Presumably this BIOS doesn't provide such an interface. (The only 
such interface other than the standard ACPI thermal zone interface that 
I'm aware of is the ATK0110 interface used on a lot of Asus motherboards.)
