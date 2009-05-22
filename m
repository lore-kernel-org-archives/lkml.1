Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZEVOyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZEVOyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZEVOx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:53:59 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:37751 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZEVOx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uLpUBCcZzPAqF11PIX2nsgDDJQuqna6rKnVLUBpuIroYJTwzOZTDHWwM1ZKlLuNp5q
         v6RUlneOgS+6l82OTvQQaqFX2/TqGlrY0gYFTxIvhRfAqq5z3s6bEqGRg+htkp1RF1OP
         6wb56M8mypyhfTjbqtJDAHPzmh3GrqRYgIec4=
MIME-Version: 1.0
In-Reply-To: <20090522140930.GA26580@elf.ucw.cz>
References: <1240913055.29860.14.camel@maxim-laptop>
	 <1240950704.3781.12.camel@maxim-laptop>
	 <cone.1241299309.265715.3948.1000@mentalhome>
	 <20090503184617.GA3555@liondog.tnic>
	 <cone.1241648222.299676.7476.1000@mentalhome>
	 <20090509171432.GA31126@liondog.tnic>
	 <cone.1242065107.695268.13534.1000@onepiie>
	 <20090519203015.GA1362@ucw.cz>
	 <9ea470500905220450s2367f8a1uc2b19a9466ea8509@mail.gmail.com>
	 <20090522140930.GA26580@elf.ucw.cz>
Date: Fri, 22 May 2009 16:53:59 +0200
Message-ID: <9ea470500905220753x6c2be25dq14422dff2acea422@mail.gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Feuerer <peter@piie.net>, petkovbb@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> The idea of not starting the module in kernel mode was from Matthew. And
>> >> he stated that it could harm the hardware when software controls the fan
>> >> instead of the BIOS. It may also be possible, that the warranty gets
>> >
>> > Well... hw is usually designed to protect itself.
>>
>> It seems like the fan in the aspire one's is used for cooling the
>> surrounding devices too and while the thermal envelope of the CPU is
>> much wider, the peripherals are much more susceptible to temperatures
>> outside of their allowed operating range. That's why currently the
>> driver lets the BIOS control the fan since its settings are most
>> conservative.
>
> Yep, I don't disagree. But I strongly suspect that if you force the
> fan off and overheat the machine, it will shut down in hardware before
> doing any damage.

Yep, however we won't come that far with the current driver since it
relinquishes control of the fan to the BIOS after a critical temp of
89° is reached. I'm still quite unpersuaded about that "magical" number
since it is 1 degree below the high interval boundary of the juncture
temperature of the Atom CPU. I would like to have a more reliable source
for the allowed envelope based not only on the CPU but on the whole
chipset but can't seem to find any data from Acer on that.

>> the module can still be toggled on/off from sysfs. Actually, empirically
>> measured, there seem to be three states of the fan: off, on and on-max
>> where you can hear it rotating at max RPM. The kernel module can handle
>> those completely if you know the respective ACPI EC commands and there's
>> no need for userspace daemon, IMHO.
>
> It would be still nice to let the userspace lower the trip points for
> maximum flexibility. No need for userspace _daemon_.

I'm sure Peter wouldn't mind adding some other sysfs entries in future
versions of the driver controlling exactly that.

-- 
Regards/Gruss,
Boris.
