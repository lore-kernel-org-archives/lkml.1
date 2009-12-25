Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZLYIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZLYIse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 03:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZLYIsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 03:48:33 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35392 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZLYIsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 03:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FwjNKZHpWSRTYgooYNvjR4D/nfrWsYb60rrVSNPLwtEGhNo3SIKCpFSXzePypvqQIp
         Qf6AOaTuxXqutTPerrtInzLr5e1+SE6+GuoycZ5YkHjoDT9cnF97U8jNOSg1fDyY1HGc
         59wAIDr8dD93W1s27yVMmL3K5D2kophrxj8v8=
MIME-Version: 1.0
In-Reply-To: <4B3413C4.6070602@gmail.com>
References: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
	 <4B3413C4.6070602@gmail.com>
Date: Fri, 25 Dec 2009 09:48:31 +0100
Message-ID: <2d0a357f0912250048h2bc987ccs4d4d253a4155becf@mail.gmail.com>
Subject: Re: [2.6.33-rc2] ACPI problems on HP nc6400 notebook
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as I suspected it is an ACPI issue while I tried to boot with "acpi=off".

I have taken new screenshots and added dmesg (acpi=off) and all
messages in /var/log/* [1].

It is possible to load acpi kernel-module afterwards?
Or it is not possible whenn loading with acpi=off?

@Len Brown:
There are two photos showing thermal problems.
Notebook did shut down in the night.
But this was before 2.6.33-rc2.

I will not try a bisect (visting currently my brother and working with
touchpad really sucks), but I will revert the wmi-related (wmi/hp-wmi)
commits.
There seems problems with wmi on other systems w/ 2.6.33-rc2 [2].

Kind Regards,
- Sedat -

[1] http://files.iniza.org/linux-kernel/BUG_2.6.33-rc2/
[2] http://marc.info/?l=linux-kernel&m=126171951030608&w=2

On Fri, Dec 25, 2009 at 2:22 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 12/24/09 17:11, Sedat Dilek wrote:
>>
>> Hi,
>>
>> I build linux-2.6.33-rc2 on a Debian/sid 32-bit host.
>> Unfortunately, this kernel falls in an unusable state (sort of loop)
>> and does not a normal startup.
>>
>> With this setting (see below), I hoped to catch the early
>> boot-messages (but, no success):
>>
>> # cat /etc/default/bootlogd
>> # Run bootlogd at startup ?
>> BOOTLOGD_ENABLE=Yes
>>
>> Finally, I could take a picture [1].
>> It seems to be that latest ACPI patches are breaking my system
>> (speculating).
>>
>> Q: How can I log such early boot (error) messages to give a detailled log?
>>
>> Hope this helps fixing the problem.
>>
>> Kind Regards,
>> - Sedat -
>>
>>
>> [1] http://files.iniza.org/linux-kernel/DSCN2134.JPG
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> you can try(if you have the port)
> ohci1394_dma=early or the usb
> early logging located in kernel hacking.
>
> but if this thing is hitting way early it
> might be a bit more tricky.
>
> if you can try  a bisect from the bad
> kernel to the good.
>
> Justin P. Mattock
>
