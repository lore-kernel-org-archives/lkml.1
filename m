Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZEXLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZEXLSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZEXLSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 07:18:03 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:60277 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZEXLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 07:18:02 -0400
References: <1240913055.29860.14.camel@maxim-laptop> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090519203015.GA1362@ucw.cz> <9ea470500905220450s2367f8a1uc2b19a9466ea8509@mail.gmail.com> <20090522140930.GA26580@elf.ucw.cz> <9ea470500905220753x6c2be25dq14422dff2acea422@mail.gmail.com>
Message-ID: <cone.1243163619.528098.4387.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Pavel Machek <pavel@ucw.cz>, petkovbb@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Sun, 24 May 2009 13:13:39 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

>> Yep, I don't disagree. But I strongly suspect that if you force the
>> fan off and overheat the machine, it will shut down in hardware before
>> doing any damage.
> 
> Yep, however we won't come that far with the current driver since it
> relinquishes control of the fan to the BIOS after a critical temp of
> 89° is reached. I'm still quite unpersuaded about that "magical" number
> since it is 1 degree below the high interval boundary of the juncture
> temperature of the Atom CPU. I would like to have a more reliable source
> for the allowed envelope based not only on the CPU but on the whole
> chipset but can't seem to find any data from Acer on that.

I think we are fine the way it is now. The driver allows to read the 
temperature by default and people who know what they are doing can easily 
enable kernel based fan control.

>>> the module can still be toggled on/off from sysfs. Actually, empirically
>>> measured, there seem to be three states of the fan: off, on and on-max
>>> where you can hear it rotating at max RPM. The kernel module can handle
>>> those completely if you know the respective ACPI EC commands and there's
>>> no need for userspace daemon, IMHO.
>>
>> It would be still nice to let the userspace lower the trip points for
>> maximum flexibility. No need for userspace _daemon_.
> 
> I'm sure Peter wouldn't mind adding some other sysfs entries in future
> versions of the driver controlling exactly that.

You can already change the trip points via the 
/sys/module/acerhdf/parameters/* files on the fly.

cheers,
--peter
