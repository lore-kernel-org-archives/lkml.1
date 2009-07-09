Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZGINNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZGINNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbZGINM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:12:57 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:37340 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbZGINM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IVpUrqou+KTTSk8r9AyCX6wPiz8axedDjbzle0uO8YqWERCdljx/lMg0WVfoE4BW0G
         hfTy3TgNM5+xwPvb+OP9Qbz54pEMiI8URY2eLOlP6pdQKU16QZXLALh6baD3BHldqurr
         TN4HUpm+PqA41XYeA69IvBTlcznpODgVeJeHI=
Message-ID: <4A55EC95.5000309@gmail.com>
Date: Thu, 09 Jul 2009 15:11:49 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
References: <4A54FB81.30302@gmail.com>	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>	 <4A551B43.3020104@gmail.com>	 <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>	 <4A5575C1.8090403@lwfinger.net>	 <3ace41890907090347m1f337731rb09b90327664ed5@mail.gmail.com>	 <4A55D123.5090802@gmail.com> <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
In-Reply-To: <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin-Tak Leung wrote:
> 2009/7/9 Marcin Slusarz <marcin.slusarz@gmail.com>:
>> Hin-Tak Leung pisze:
>>> 2009/7/9 Larry Finger <Larry.Finger@lwfinger.net>:
>>>> Hin-Tak Leung wrote:
>>>>> if they are not labelled v1/v2/v3 as such, it may be more
>>>>> useful/informative to change to
>>>>>
>>>>>     [some variant of ] ... [(other variants are supported by the
>>>>> rt2070/rt3070 modules)]
>>>>>
>>>>> instead of just adding [v2] to the end.
>>>> I don't know about the box as I bought mine used on Ebay, but the
>>>> label on the device clearly states that it is a WG111v2.
>>>>
>>>> Larry
>>>>
>>>>
>>> But that's  a Netgear WG111v2 ? We are talking about Linksys
>>> WUSB54GC-EU and its v1/v2/v3 . I am just thinking that if it is for
>>> informative purposes (for those who actually selectively build their
>>> kernel modules), adding a bit more info, such as suggesting to use
>>> rt73usb/rt2070/rt3070 modules, won't hurt.
>>>
>>> Incidentally I like to know a bit more about this patch - presumably
>>> Marcin has such a device? I am also a little curious, as this commit
>>> should be accompanied by a corresponding update in another Kconfig
>>> which supports the device? I am not trying to be picky, but for an
>>> informative (non-code-changing) patch, it can be more informative.
>> I have a v3 device and this driver does not support it.
>> Below is the commit which added the string my patch corrects.
>> I've sent yesterday another patch which adds support for WUSB54GC v3
>> to the rt3070 driver.
> 
> Here is some info from Gabor (shouldn't this be reply-all rather than just me):
> ------------------
> The v1 and v2 look identical (though the label on the device indicates
> the revision). The v3 looks completely different. They all have
> different USB IDs (v1 is stock RT73, v2 has a custom ID, while v3 is
> AFAIK stock RT2070).
> ------------------
> 
> I guess to be informative, may I suggest adding '(for v1  see rt73usb,
> and v3 see rt3070)' or something similiar to the 'v2' change?
> It is fair customary in Kconfig to mention even alternative/competing
> drivers for the same device. And when you add v3 support to the rt3070
> driver, a reverse mention may be appropriate. (I guess I am spending
> far too long on this discussion - but I reckon, the purpose of a
> non-code-changing change is meant to be informative, so one might want
> to be as informative as appropriate without being too wordy...)

Look, support for Ralink chipsets is a mess. They are supported by too sets
of drivers - Ralink's ugly as hell but working staging drivers (rt2860,
rt2870, rt3070, soon rt3090) and properly developed but lagging rt2x00
drivers (RT2400PCI, RT2500PCI, RT61PCI, RT2500USB, RT73USB, RT2800USB).

Theoretically my WUSB54GCv3 is supported by RT2800USB (which was added during
2.6.31 merge window), but it doesn't work. With tiny patch added to rt3070 
(just usb id) my card works. Some day rt2x00 drivers will be better than Ralink's,
but right now they are not.

So I wouldn't like to encourage any of them. I just wanted to fix clearly
wrong help text which stated that rtl8187 (Realtek's chipset!) supports
all WUSB54GC cards.

Marcin

