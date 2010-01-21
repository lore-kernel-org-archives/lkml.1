Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415Ab0AUVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0AUVsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249Ab0AUVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:48:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38032 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0AUVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qCbVMk2q6KPf/uS2cK7t1swwiRfH7ZuMTxsLd0mimY5fre8IHNLBIutzBQXtYROVKo
         g7O2IqLVLBIIDW88KtXkC2/5BjgElLhGouFGr5ZdiAADnjvlcxI07rV6qC0sZ4vMEIZw
         5ArMM70WDucuc+gB3WaceVrWWNM1HH3lYoYks=
Message-ID: <4B58CBEE.5020301@gmail.com>
Date: Thu, 21 Jan 2010 13:49:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>	 <4B57A2D4.9030204@gmail.com>	 <20100121185544.GB11996@core.coreip.homeip.net> <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
In-Reply-To: <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/10 13:39, Robert Hancock wrote:
> On Thu, Jan 21, 2010 at 12:55 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com>  wrote:
>> On Wed, Jan 20, 2010 at 06:41:56PM -0600, Robert Hancock wrote:
>>> On 01/20/2010 12:23 PM, Bastien Nocera wrote:
>>>> As those computers never had any i8042 controllers, and the
>>>> current lookup code could potentially lock up/hang/wait for
>>>> timeout for long periods of time.
>>>>
>>>> Fixes intermittent hangs on boot on a MacbookAir1,1
>>>>
>>>> Signed-off-by: Bastien Nocera<hadess@hadess.net>
>>>
>>> I assume this is happening because of this code in
>>> drivers/input/serio/i8042-x86ia64io.h:
>>>
>>>          if (!i8042_pnp_kbd_devices&&  !i8042_pnp_aux_devices) {
>>>                  i8042_pnp_exit();
>>> #if defined(__ia64__)
>>>                  return -ENODEV;
>>> #else
>>>                  printk(KERN_INFO "PNP: No PS/2 controller found.
>>> Probing ports directly.\n");
>>>                  return 0;
>>> #endif
>>>
>>> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2
>>> controller exists, we randomly bang on the ports in the expectation
>>> they'll be there anyway. This seems rather misguided.
>>
>> Basically, we do not trust BIOS writers on x86 ;) In the past there were
>> occasions when they forgot to mention presence of KBD/AUX in DSDT and
>> elsewhere which lead to non-functional keyboard/mouse.
>
> Are we certain about that? Any pointers to reports?
>
>>
>>> It would seem
>>> like a better idea to fix this rather than adding yet another DMI
>>> list (especially since there likely are, or will be, machines
>>> without i8042 other than Macs).
>>>
>>
>> If they are not Macs that mean they are tested with windows and thus
>> expect probes in i8042 port region so no harm done. In a few years if
>> everyone uses USB only we could add a year threshold to trust ACPI/PNP
>> data.
>
> Macs will be tested with Windows too, so obviously it manages to avoid
> this problem somehow, and I very much doubt it has an Apple-specific
> check..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I've an iMac, and a macbook over here,
if you guys need me to test out a patch for this let me know.

Justin P. Mattock
