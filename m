Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZKJD0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZKJD0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZKJD0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:26:30 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53325 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbZKJD03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:26:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EfoFTxo41A0jsfz8Cbq7t+GIDg5GOMdNwLrWmmBbB8N4uZiuLHAEuvkzsMBu/tIZN6
         YYLkIWJuVdnXaSDwaLBlp2PVVBFXJQgPP/FZpG6KfQcUjxuAIXrmWWI+TP9YhTuCZLU3
         /szSEPZj4gV6NnY5V/VnYcSym9kKg2vchyTng=
MIME-Version: 1.0
In-Reply-To: <1257809705.29038.82.camel@dax.rpnet.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <1257809705.29038.82.camel@dax.rpnet.com>
Date: Tue, 10 Nov 2009 12:26:32 +0900
Message-ID: <90b950fc0911091926v32dc1c44n1018322390282bc0@mail.gmail.com>
Subject: Re: [patch] added brightness feature to lcd class.
From: InKi Dae <daeinki@gmail.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.

it is a good idea that lcd driver registers interfaces to lcd class
and backlight class.
but I think for AMOLED LCD Panel, backlight couldn't be real device so
power on/off
for backlight device doesn't make sense.

I had tried lcd driver registers interfaces to lcd class and backlight
class as you said.
and also backlight fake driver as Pavel said.

but I thought to use my patch is more simple and effective.
of course, this patch has a problem that it has different path from
backlight class
for controlling brightness.

how about creating symbolic link file for competiability?

Best Regards,
InKi Dae.

2009/11/10 Richard Purdie <rpurdie@linux.intel.com>:
> On Mon, 2009-11-02 at 17:50 +0900, InKi Dae wrote:
>> This patch adds brightness feature to lcd class.
>> (kernel/driver/video/backlight/lcd.c)
>>
>> In the past, most of the lcd panels for embedded system was TFT-LCD
>> Panel needing backlight device.
>> But now AMOLED LCD Panel appeared so we should consider brightness
>> control for AMOLED Panel.
>>
>> For the time being, I used backlight fake driver for brightness
>> control of AMOLED LCD Panel.
>> But this way is not good, so I propose to add brightness feature to lcd class.
>>
>> For this, I attached patch file and if my proposal is approved
>> Then I will send s6e63m0 and tl2796 AMOLED lcd panel driver based on
>> lcd class modified soon.
>
> Pavel has a good point but let me try and explain it differently.
>
> The point of the backlight class is to expose a backlight brightness
> control to userspace in a consistent well defined way. Anyone wishing to
> write a piece of software to control the brightness of a backlight then
> only needs to support *one* interface.
>
> It is entirely accepted and normal that multiple "class" devices may
> appear in userspace for one piece of physical hardware.
>
> Your patch duplicates a userspace API and means any backlight
> application would have to look for *two* different interfaces. This is
> unacceptable.
>
> Why can't your driver just register a backlight interface and an LCD
> interface? I'd imagine your backlight and LCD can be powered on/off
> separately too.
>
> Please also cc: the backlight/lcd maintainer (me) on backlight/lcd
> patches in future.
>
> Andrew: Can you drop that patch from -mm please as I'm not convinced we
> need two backlight brightness interfaces around...
>
> Cheers,
>
> Richard
>
>
>
>
