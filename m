Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZFBHPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZFBHPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZFBHP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:15:29 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61813 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZFBHP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sDCsbwn4Kph6h1apaJwAfXzH+zuAhvLhwFNxIcL6O6kPdBlX/pnWnVyV1PH2mHpvPT
         NFRUC9U8Zp00qE2Qgw4Fa2tzoLsElLS4XHAcXIkkFmwlUeyuZpj57aOQleplnk9Y2i6Y
         EPOC8GtOFq/CWr1cPdKe2YbXaNN7xtOZgEozM=
MIME-Version: 1.0
In-Reply-To: <20090601215034.7352ddca.akpm@linux-foundation.org>
References: <200906011357.09966.florian@openwrt.org>
	 <20090601215034.7352ddca.akpm@linux-foundation.org>
Date: Tue, 2 Jun 2009 09:15:29 +0200
X-Google-Sender-Auth: 26a2fe37e5854ca9
Message-ID: <10f740e80906020015t2d63fdadmaa1fa6bc204ec33a@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: export sound/core/pcm_timer.c gcd 
	implementation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Fainelli <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 06:50, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 1 Jun 2009 13:57:09 +0200 Florian Fainelli <florian@openwrt.org> wrote:
>
>> This patch exports the gcd implementation from
>> sound/core/pcm_timer.c into include/linux/kernel.h.
>> AR7 uses it in its clock routines.
>>
>> ...
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 883cd44..878a27a 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -147,6 +147,22 @@ extern int _cond_resched(void);
>>               (__x < 0) ? -__x : __x;         \
>>       })
>>
>> +/* Greatest common divisor */
>> +static inline unsigned long gcd(unsigned long a, unsigned long b)
>> +{
>> +        unsigned long r;
>> +        if (a < b) {
>> +                r = a;
>> +                a = b;
>> +                b = r;
>> +        }
>> +        while ((r = a % b) != 0) {
>> +                a = b;
>> +                b = r;
>> +        }
>> +        return b;
>> +}
>
> a) the name's a bit sucky.   Is there some convention for this name?

Well, `gcd' is a quite common acronym, probably almost as well known as `min'
and `max'...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
