Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZBJXvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZBJXvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZBJXv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:51:29 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:61592 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZBJXv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BCulZ1Bw9UMfw1xANFZWU/oKcBDVXB8Ji2kyMwjaTJABNVV+7FbFHzYvBZa206TNg8
         vKmFD4vbPdxCs1E7Cl0N9rNC2Sa6IDrmup437mrJkHkNWROPSjR5tDdfBInC0o5iRPaq
         MBCV9VfBHFoGh392nrPeCTiMdGDR9BIlmcc7A=
MIME-Version: 1.0
In-Reply-To: <499211D0.3090705@tremplin-utc.net>
References: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <499211D0.3090705@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:51:25 +0100
Message-ID: <cb7bb73a0902101551o30dde0aesaeba399f1ab732af@mail.gmail.com>
Subject: Re: [PATCHv2] lis3lv02d: support both one- and two-byte sensors
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: git@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 12:46 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Giuseppe Bilotta schreef:
>>
>> Sensors responding with 0x3B to WHO_AM_I only have one data register per
>> direction, thus returning a signed byte from the position which is
>> occupied by the MSB in sensors responding with 0x3A.
>>
>> We support both kind of sensors by checking for the sensor type on init
>> and defining appropriate data-access routines and sensor limits (for the
>> joystick) depending on what we find.
>>
>> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
>> ---
>>
>> This is the other version of the patch, and it changes access to use the
>> base address from the 8-bit, so the 16-bit routine is changed to access
>> the PREVIOUS byte for the LSB.
>>
>> Choose whichever of the patches is deemed more correct 8-)
>>
>> Note that both patches are based off Linus tree, so I don't know how
>> they cope with Pavel's "don't touch too much on init" one. I'll try to
>> work out a patch on top of that too.
>
> Yes, great, and this one looks even better than v1 :-)

And don't forget about the v3 for -mm ;-)

> However I'm not sure about the conversion between s8 and s16:
>
>> +static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
>> +{
>> +       u8 lo;
>> +       adev.read(handle, reg, &lo);
>> +       return *((s8*)(&lo));
>> +}
>
> Does it really extend the sign to 16 bits? I would have written it this way:
> +static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
> +{
> +       s8 lo;
> +       adev.read(handle, reg, &lo);
> +       return (s16)lo;
> +}
> Doesn't it work better?

Well, the previous one works, but I admit it's horribly convoluted.
I'll double check with this one and resubmit (I'll only resubmit the
one based on Pavel's "don't touch anything on init" probably though,
hope it's ok)


-- 
Giuseppe "Oblomov" Bilotta
