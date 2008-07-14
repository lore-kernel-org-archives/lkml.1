Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGNLkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGNLkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYGNLkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:40:40 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:50477 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYGNLkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:40:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=KhU21VsetCwMQ7SJyQk5RQ6QDNgg26KX3+lrIV7hAQJBKB5MleqbK9tasdH0EUjL15QIkbzo9WdWYPK6sktGheHZRT9fVu/P+ylCRreHFRFaUS3AC1LsCkMYZ5QVFrEF;
Message-ID: <24484.simon.1216035632@5ec7c279.invalid>
In-Reply-To: <1216003710.2649.24.camel@pc10.localdom.local>
References: <4878F314.6090608@simon.arlott.org.uk>
    <1215919227.2662.3.camel@pc10.localdom.local>
    <487A4A3D.9040809@simon.arlott.org.uk>
    <1216003710.2649.24.camel@pc10.localdom.local>
Date: Mon, 14 Jul 2008 12:40:32 +0100
Subject: Re: [PATCH] V4L: Link tuner before saa7134
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "hermann pitton" <hermann-pitton@arcor.de>
Cc: v4l-dvb-maintainer@linuxtv.org, "Linux DVB" <linux-dvb@linuxtv.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, July 14, 2008 03:48, hermann pitton wrote:
>
> Am Sonntag, den 13.07.2008, 19:32 +0100 schrieb Simon Arlott:
>> >From cde790c56ffe76f3d0bf6f38d89f4e671a5218c6 Mon Sep 17 00:00:00 2001
>> From: Simon Arlott <simon@redrum.invalid>
>> Date: Sun, 13 Jul 2008 19:24:53 +0100
>> Subject: [PATCH] V4L: Link tuner before saa7134
>>
>> If saa7134_init is run before v4l2_i2c_drv_init (tuner),
>> then saa7134_board_init2 will try to set the tuner type
>> for devices that don't exist yet. This moves tuner to
>> before all of the device-specific drivers so that it's
>> loaded early enough on boot.
>>
>> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
>> ---
>>  drivers/media/video/Makefile |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>> index ecbbfaa..6b0af12 100644
>> --- a/drivers/media/video/Makefile
>> +++ b/drivers/media/video/Makefile
>> @@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
>>    obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
>>  endif
>>
>> +obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>> +
>>  obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>>  obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
>> @@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>>  obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
>>  obj-$(CONFIG_TUNER_3036) += tuner-3036.o
>>
>> -obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>> -
>>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
>> --
>> 1.5.6.2
>>
>
> Thanks a lot for working on it!
>
> I must admit that I have not tested it yet.
>
> Remaining issues are.
>
> #1 users can't set the tuner type anymore,
>    but the few cases of tuner detection from eeprom we have should
>    work again for that price.
There are already module parameters to do that... they can be used
from the kernel command line too.

>
> #2 We still don't have any sufficient HDTV support in the kernel ;)
>
DVB-T2? Why is that relevant to this change? My card doesn't even support
it.

> #0 On 2.6.25, without dedicated TV subnorm selection possible anymore
>    and known auto detection flaws, fixed now, folks should have
>    complained about it.
>
>    Interestingly nothing like that happened.
>
>    What could that mean?
>
I'm not sure what you're asking, but not many people appear to compile
v4l/dvb into the kernel. Lots of function calls still work on
uninitialised modules so ordering problems can easily be missed.

> Cheers,
> Hermann

-- 
Simon Arlott
