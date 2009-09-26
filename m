Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIZWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIZWvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZIZWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 18:51:47 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:64254 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZIZWvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 18:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vHKhd9X/0e2tfrchCyDIdZqE0UcVvIM9qJJ/P+YyUbCCyBwXLZAqmUKRn8Ql4uNY/z
         eLlVF+DlBZ1JCY/Q1fRhY8UZ8W2KO8Bcv0NBJO8ZwhqlOAwm1hkU+PtgXe23iFA1rmvz
         wbQLQ47KKBHPMzyUk10T2TDrsk6DfbGU1i7+Q=
MIME-Version: 1.0
In-Reply-To: <4ABD8124.9060108@gmail.com>
References: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
	 <200909260051.34541.elendil@planet.nl>
	 <501db8660909251802hacbaf04wb8dc1734fa523d34@mail.gmail.com>
	 <86802c440909251847p421d6523ra40c59e724d566fb@mail.gmail.com>
	 <4ABD8124.9060108@gmail.com>
Date: Sat, 26 Sep 2009 23:51:45 +0100
Message-ID: <501db8660909261551x6c61b2d7t12125406e246bb5a@mail.gmail.com>
Subject: Re: Regression: kernels since 2.6.26 are unusably slow
From: Aneurin Price <aneurin.price@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai.lu@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 03:49, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 09/25/2009 07:47 PM, Yinghai Lu wrote:
>>
>> On Fri, Sep 25, 2009 at 6:02 PM, Aneurin Price<aneurin.price@gmail.com>
>>  wrote:
>>
>>> Hmm. Looking at dmesg for a 'working' kernel includes an interesting part
>>> which
>>> I foolishly forgot to save, saying that the last 512MB of memory is
>>> inaccessible (I was wondering where that last half-gig had gone :-)). I
>>> can go
>>> and check exactly what it says, but I don't have the energy left for any
>>> more
>>> reboots today. Anyway, that prompted me to try booting with mem=7168 -
>>> and that
>>> makes the problem go away. Perhaps that will shed some light on things.
>>
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
>> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
>> [    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
>> [    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
>> [    0.000000] DMI 2.4 present.
>> [    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-CDFFF write-protect
>> [    0.000000]   CE000-EFFFF uncachable
>> [    0.000000]   F0000-FFFFF write-through
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 100000000 mask FE0000000 write-back
>> [    0.000000]   1 base 100000000 mask F00000000 write-back
>> [    0.000000]   2 base 000000000 mask F00000000 write-back
>> [    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
>> [    0.000000]   4 base 0DFF00000 mask FFFF00000 write-through
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>>
>> looks like your MTRR has some problem, and with that WRITE-THROUGH
>> there, the trimming e820 will not happen
>
> You might want to see if there's a BIOS update available for that
> system/motherboard..
>

Slightly surprisingly to me, after spending two and a half hours figuring out a
way to update the BIOS, it actually worked:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CDFFF write-protect
[    0.000000]   CE000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask FE0000000 write-back
[    0.000000]   4 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled

I do wish I understood this better, but I suppose that'll have to be a topic for
future research.

Given that I'm no longer having the problem, this isn't of pressing importance
to me so is purely informational:

CONFIG_MTRR_SANITIZER didn't help[0], though I didn't try changing the value of
MTRR_SANITIZER_SPARE_REG_NR_DEFAULT. I also tried mtrr-uncover which I learned
about from http://kerneltrap.org/mailarchive/linux-kernel/2008/9/30/3454074, and
that didn't help either. However, the thing that makes me bother mentioning all
this is that I tried booting Windows XP (64bit) before updating the BIOS, and
that worked fine with the full 8GB of RAM. This indicates to me that whatever
the problem, it wasn't insurmountable, so in principle Linux could do better.

If it doesn't seem worth looking into further then that's perfectly
understandable, but if anyone is interested and would like any more information,
let me know.

Thank you all for your suggestions,
Nye



[0] Google indicated that passing the boot param 'enable_mtrr_cleanup' would be
appropriate; I don't know if that's correct, and I don't really understand the
wording on MTRR_SANITIZER_ENABLE_DEFAULT. I got the impression that the optional
0 or 1 value just means 'enable MTRR cleanup or not', and is overridden by the
boot parameter. Maybe that option would be worth clarifying?
