Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZBJLHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZBJLHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZBJLHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:07:40 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51901 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZBJLHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aUzJTxLQCi65QfxKhO1a79GJTsQAe/iNQqmK17K58u/G5itaLQ2mKzGihwH5QQYaBJ
         a+AmJFTjO/76CfiXXHhBd6WYorGBQFpQcwQDJngRLPH9XSp/UYOl3QGo8JuViW9FJw73
         Wy2/aIbhgvrEqZZghQjVijg9sWepOwtYjxx6A=
MIME-Version: 1.0
In-Reply-To: <49915832.1090501@tremplin-utc.net>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
	 <49915832.1090501@tremplin-utc.net>
Date: Tue, 10 Feb 2009 12:07:37 +0100
Message-ID: <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 11:34 AM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> (putting back the cc's, please keep them when answering)
>
> Palatis Tseng schreef:
>> Éric Piel 提到:
>>> No problem, the patch from Giuseppe will get the axex fine :-)
>>>
>>> However, could you let use know if you too, on your laptop, have huge
>>> fluctuations even when the laptop is not moving? Could you give an idea
>>> of the minimum and maximum values of each axis when the laptop is set
>>> normally on the desk without touching it?
>>>
>>> Thanks,
>>> Eric
>> I took a look at the patch but my axis on dv5 is Y_inverted (instead of
>> X_inverted.) i patched my lis3lv02d.c and added:
>>
>> === cut here ===
>>    AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", y_inverted),
>> === cut here ===
>>
>> and neverball worked just correct with it so i'm kinda sure my patch
>> about the axis should be correct.
>>
>> i've also tested with x_inverted, but whenever i evaluate the left side
>> of my notebook the ball goes to the left side too which is not real-world
>> behavier.
>>
>> mine is a HP Pavilion dv5 1003ax with AMD PUMA platform.
>> `dmidecode | grep "Product Name" says:
>> (under "System Information"...)
>>    Product Name: HP Pavilion dv5 Notebook PC
> Giuseppe,
> Palatis mentions that on his laptop the sensor is actually y_inverted.
> Could you check your laptop? In particular it would be nice if you could
>  describe the values for the four positions defined in the documentation
> file. BTW, what is the exact version of your laptop? Is it the same as
> Palatis?

With my patch applied:

Left raised: 0 -> 32k
Right raised: 0 -> -32k

Front raised: 1 -> -32k
back raised: 1 -> 32k

Upside down: 2 -> 32k

So it seems that my model inverts the Z axis too, I'll have to fix
that. However, this last test is tricky because unless the laptop is
completely upside down the Z axis can go from -32k to +32k with just a
couple of degrees (around the 90°)

I'll update my patch to invert the X and Z axis for my model.

> Palatis, could you let us know if you also have a lot of "noise" in the
> values. That is, if when using jstest /dev/input/js0 you see big changes
> in the values. Is it like on Giuseppe's laptop of around 8000?
>
> Moreover I'm wondering if this could be an error on LSB/MSB ordering.
> Maybe looking at the raw values (cat
> /sys/devices/platform/lis3lv02d/position) would give more insight...

amd64 architecture here. Laptop flat:

oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(-256,256,14592)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(0,256,14848)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(-256,256,14848)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(-256,0,14336)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(-256,512,14336)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(256,256,14592)

Left edge raised:
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(5120,512,13312)
oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
(5632,512,13312)

You might be onto something.

The dmi for my Pavilion is:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: Hewlett-Packard
        Product Name: HP Pavilion dv5 Notebook PC
        Version: F.09
        Serial Number: (x-ed out)
        UUID: (x-ed out)
        Wake-up Type: Power Switch
        SKU Number: (x-ed out)
        Family: 103C_5335KV

So it might be that different pavilions have different sensors?

-- 
Giuseppe "Oblomov" Bilotta
