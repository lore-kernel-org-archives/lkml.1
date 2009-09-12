Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZILHWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZILHWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZILHWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:22:42 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:35264 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZILHWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kVElTN3oryoBOHPcgT/LgC+poKPhTuTX7tc3M01PI9YoXDjRPcBjx2R4hfxlPCt51J
         B/0hUVUG47xe05glhIW4g2MTlj3KPXDP5H3kVREmjA61kOZ/T7cNY9z5PWfYNpJzMeyT
         JtnlJYzhsypIcFsReHLr34R1zBTyl1EhFLmFw=
MIME-Version: 1.0
In-Reply-To: <4AAA73A4.9010601@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
	 <1252627011-2933-1-git-send-email-ddaney@caviumnetworks.com>
	 <200909111633.00665.mb@bu3sch.de>
	 <4AAA73A4.9010601@caviumnetworks.com>
Date: Sat, 12 Sep 2009 09:22:43 +0200
X-Google-Sender-Auth: 42a0362e6b437612
Message-ID: <10f740e80909120022m72ad5ea7t692fba93cd3114e9@mail.gmail.com>
Subject: Re: [PATCH 01/10] Add support for GCC-4.5's __builtin_unreachable() 
	to compiler.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Michael Buesch <mb@bu3sch.de>, linuxppc-dev@lists.ozlabs.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-s390@vger.kernel.org,
       linux-am33-list@redhat.com, Helge Deller <deller@gmx.de>,
       x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-alpha@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 17:58, David Daney<ddaney@caviumnetworks.com> wrote:
> Michael Buesch wrote:
>>
>> On Friday 11 September 2009 01:56:42 David Daney wrote:
>>>
>>> +/* Unreachable code */
>>> +#ifndef unreachable
>>> +# define unreachable() do { for (;;) ; } while (0)
>>> +#endif
>>
>> # define unreachable() do { } while (1)
>>
>> ? :)
>
> Clearly I was not thinking clearly when I wrote that part.  RTH noted the
> same thing.  I will fix it.

However, people are so used to seeing the `do { } while (0)' idiom,
that they might miss
there's a `1' here, not a `0'.

So perhaps it's better to use plain `for (;;)' for infinite loops?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
