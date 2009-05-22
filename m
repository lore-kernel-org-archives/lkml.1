Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZEVLvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZEVLvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZEVLvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:51:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52564 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZEVLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eZDSgqghSuBuwUsdmJkOYVsbyzjLiT/bxOSNvt9HGYK5K8xckH7M9aKMd9FCweW9oo
         NAGc1/WO9tDYviQwtLglKuMdottJoqvr8cCb9XOdXqA4UsogBT1Vu9xpc0GvBfoWKsvQ
         WzrPknz2kQvLgwGDj94jju0kdJjMgMar4jk+M=
MIME-Version: 1.0
In-Reply-To: <20090519203015.GA1362@ucw.cz>
References: <cone.1240858632.795110.5316.1000@onepiie>
	 <1240913055.29860.14.camel@maxim-laptop>
	 <cone.1240949852.549814.7466.1000@mentalhome>
	 <1240950704.3781.12.camel@maxim-laptop>
	 <cone.1241299309.265715.3948.1000@mentalhome>
	 <20090503184617.GA3555@liondog.tnic>
	 <cone.1241648222.299676.7476.1000@mentalhome>
	 <20090509171432.GA31126@liondog.tnic>
	 <cone.1242065107.695268.13534.1000@onepiie>
	 <20090519203015.GA1362@ucw.cz>
Date: Fri, 22 May 2009 13:50:59 +0200
Message-ID: <9ea470500905220450s2367f8a1uc2b19a9466ea8509@mail.gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Feuerer <peter@piie.net>, petkovbb@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>> the more I'm looking at the driver, the more I get annoyed by that
>>> user/kernel mode operation split. Remind me again why the driver should
>>> be loaded and not started automatically but the user should be required
>>> to activate it explicitly?
>>
>> The idea of not starting the module in kernel mode was from Matthew. And
>> he stated that it could harm the hardware when software controls the fan
>> instead of the BIOS. It may also be possible, that the warranty gets
>
> Well... hw is usually designed to protect itself.

It seems like the fan in the aspire one's is used for cooling the
surrounding devices too and while the thermal envelope of the CPU is
much wider, the peripherals are much more susceptible to temperatures
outside of their allowed operating range. That's why currently the
driver lets the BIOS control the fan since its settings are most
conservative.

>>> That's not so optimal, I'd say. The kernel module should _replace_
>>> the userspace program, not work alongside it, since the last is flaky
>>> and unreliable, and this was the main reason the kernel module was
>>> introduced in the first place - to control the fan from kernel space,
>>> which is the more sane choice.
>>
>> The main reason to do this in kernel was the availabilty of atomic ec-
>> read and write functions. But I agree with you that either kernel or BIOS
>> should control the fan and not a userspace tool. I added the user mode
>> just because it wasn't really much more code than just an implementation
>> of the enable/disable functionality.
>
> Kernels crash, too, just like userspace does. It would still make
> sense to allow userspace to increase fan speed.

Well, if the kernel is dead, userspace has already died too. Besides,
the module can still be toggled on/off from sysfs. Actually, empirically
measured, there seem to be three states of the fan: off, on and on-max
where you can hear it rotating at max RPM. The kernel module can handle
those completely if you know the respective ACPI EC commands and there's
no need for userspace daemon, IMHO.

-- 
Regards/Gruss,
Boris
