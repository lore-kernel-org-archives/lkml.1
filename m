Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZDSSlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZDSSlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZDSSlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:41:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:43638 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZDSSlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pOc/+gbB5kWSM+YQnrqdWWcZgev+P2NiB3+4iVxj07xIwwIa1pGVz4GnIkCOT0PG4E
         7SwSDglsobHG4hCRlFP7IY1gaw4VhFx7J8IIiNinkv6u8D+NOM68IeMkkOLT1o5l8iB5
         kj6DxXotJVXCHfJ/J7zKvzqH5qvL9MaK4UYq4=
MIME-Version: 1.0
In-Reply-To: <20090418235529.47e481e9@i1501.lan.towertech.it>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-9-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-10-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-11-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-12-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-13-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-14-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-15-git-send-email-geert@linux-m68k.org>
	 <1240080744-14995-16-git-send-email-geert@linux-m68k.org>
	 <20090418235529.47e481e9@i1501.lan.towertech.it>
Date: Sun, 19 Apr 2009 20:41:21 +0200
X-Google-Sender-Auth: c24fef9d98dc698b
Message-ID: <10f740e80904191141i599af898wd47535cabd8c9184@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH/RFC 15/16] rtc: Add an RTC driver for the 
	Ricoh RP5C01
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Sat, Apr 18, 2009 at 23:55, Alessandro Zummo
<alessandro.zummo@towertech.it> wrote:
> On Sat, 18 Apr 2009 20:52:23 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>  Hi Geert, thanks for your contributions. Comments below.
>
>  Missing patch description.

git-am is happy with the one-line summary in the subject:-line, and
there's not much more to say.

>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: rtc-linux@googlegroups.com
>> ---
>>  drivers/rtc/Kconfig      |   10 ++
>>  drivers/rtc/Makefile     |    1 +
>>  drivers/rtc/rtc-rp5c01.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 250 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/rtc/rtc-rp5c01.c
>>
>> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>> index a0f6297..150fe43 100644
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -535,6 +535,16 @@ config RTC_DRV_MSM6242
>>         This driver can also be built as a module. If so, the module
>>         will be called rtc-msm6242.
>>
>> +config RTC_DRV_RP5C01
>> +     tristate "Ricoh RP5C01"
>> +     help
>> +       If you say yes here you get support for the Ricoh RP5C01
>> +       timekeeping chip. It is used in some Amiga models (e.g. A3000
>> +       and A4000).
>> +
>> +       This driver can also be built as a module. If so, the module
>> +       will be called rtc-rp5c01.
>> +
>>  comment "on-CPU RTC drivers"
>>
>>  config RTC_DRV_OMAP
>> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>> index c70418b..6176a8a 100644
>> --- a/drivers/rtc/Makefile
>> +++ b/drivers/rtc/Makefile
>> @@ -77,4 +77,5 @@ obj-$(CONFIG_RTC_DRV_WM8350)        += rtc-wm8350.o
>>  obj-$(CONFIG_RTC_DRV_X1205)  += rtc-x1205.o
>>  obj-$(CONFIG_RTC_DRV_PCF50633)       += rtc-pcf50633.o
>>  obj-$(CONFIG_RTC_DRV_MSM6242)        += rtc-msm6242.o
>> +obj-$(CONFIG_RTC_DRV_RP5C01) += rtc-rp5c01.o
>>  obj-$(CONFIG_RTC_DRV_PS3)    += rtc-ps3.o
>
>  alphabetic order please

Will do.

>> +static const struct rtc_class_ops rp5c01_rtc_ops = {
>> +     .read_time      = rp5c01_read_time,
>> +     .set_time       = rp5c01_set_time,
>> +     .set_mmss       = rp5c01_set_mmss,
>> +};
>
>  please implement either set_time or set_mmss, not both.
>  I don't know the chip but I suspect set_time is the one you need.

OK, I will remove .set_mmss. Got to confused by looking into how
everything is used...
BTW, the only remaining users of rtc_set_mmss() seem to be
arch/sparc/kernel/time_{32,64}.c?

>> +MODULE_AUTHOR("Geert Uytterhoeven");
>
>  it would be fine to have your email here.

Will do.

OK, if I take the result (for both rtc-rp5c01 and rtc-msm6242) through
the m68k tree?
Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
