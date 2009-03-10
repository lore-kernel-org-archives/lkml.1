Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZCJLLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZCJLLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZCJLKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:10:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:47857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCJLKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NzQrGGe9TZN6yHYHmdyW2xCSdhWog7LR57T1VC2FYUnBEM2hafu8QFPDcPvQ3hp1I5
         N/5zmA+DiwP8qT6o/ENv9SvssjXhTGK4S/hd1pU3bg8Vkm2pwG29Gfrn1qlUYdPKs3Vg
         JwU8nWVsAYMhveObNRr7Sl7C5XwMPF+T3qr2Q=
MIME-Version: 1.0
In-Reply-To: <aec7e5c30903100352o611e6cake0ddd50fed1d6975@mail.gmail.com>
References: <20090310062421.22328.68726.sendpatchset@rx1.opensource.se>
	 <5d5443650903100124g2bbc4837gaa5d9a9f17cd56f0@mail.gmail.com>
	 <aec7e5c30903100301n3ed24395i3d72fd956b4b7f@mail.gmail.com>
	 <5d5443650903100343x1d997179r578207509be43412@mail.gmail.com>
	 <aec7e5c30903100352o611e6cake0ddd50fed1d6975@mail.gmail.com>
Date: Tue, 10 Mar 2009 16:40:48 +0530
Message-ID: <5d5443650903100410v67b0dfcbn27fd113be3f6e9e6@mail.gmail.com>
Subject: Re: [PATCH] input: add suspend wakeup support to sh_keysc
From: Trilok Soni <soni.trilok@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-input@vger.kernel.org, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tue, Mar 10, 2009 at 4:22 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Tue, Mar 10, 2009 at 7:43 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>>>> Please add device_init_wakeup(&pdev->dev, 0) in sh_keysc_remove.
>>>
>>> Isn't this just flagging the device as wakeup capable? My first guess
>>> would be that the the wakeup state of a removed device is irrelevant
>>> since it won't be suspended anyway. Or am I misunderstanding? Please
>>> explain in more detail.
>>
>> I may not have complete answer, but I am thinking of someone depending/reading
>> on wakeup file state to determine the state of your device in userspace will get
>> confused, so better to disable to wakeup capability on remove.
>
> I think the per device wakeup file will disappear from sysfs when the
> device gets removed, so resetting the flag in the remove() callback
> just makes the driver code more confusing in my opinion. =)

Yes, I thought the same but then I am surprised to find my drivers
doing device_init_wakeup(...., 0)
on driver removal.

#grep "device_init_wakeup(&pdev->dev, 0)" -d recurse ./ | more
./usb/musb/musb_core.c: device_init_wakeup(&pdev->dev, 0);
./usb/gadget/at91_udc.c:        device_init_wakeup(&pdev->dev, 0);
./usb/host/ohci-at91.c: device_init_wakeup(&pdev->dev, 0);
./serial/atmel_serial.c:        device_init_wakeup(&pdev->dev, 0);
./input/keyboard/gpio_keys.c:   device_init_wakeup(&pdev->dev, 0);
./rtc/rtc-at32ap700x.c: device_init_wakeup(&pdev->dev, 0);
./rtc/rtc-omap.c:       device_init_wakeup(&pdev->dev, 0);
./rtc/rtc-omap.c:       device_init_wakeup(&pdev->dev, 0);
./pcmcia/at91_cf.c:     device_init_wakeup(&pdev->dev, 0);
./pcmcia/at91_cf.c:     device_init_wakeup(&pdev->dev, 0);
./mfd/htc-egpio.c:              device_init_wakeup(&pdev->dev, 0);
./mmc/host/at91_mci.c:          device_init_wakeup(&pdev->dev, 0);


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
