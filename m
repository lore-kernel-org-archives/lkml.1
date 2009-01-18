Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZARXtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZARXtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZARXsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:48:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:38922 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZARXsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j+OuSgVI1oSswSa02p1HOesTmTNuufZ6Ji34KV+iOsChUKMEkTPkwxVVlIqAfise35
         sPHU6ymYMBoe/dLqyhHnzasp1LMR+qwfBcEe3KoMyaXiY32vE+Faq5UIMtaJP5qQYktk
         dAuLdh/9tVBUG5dibkGcO7kUW9ABGOj9Pvhs0=
MIME-Version: 1.0
In-Reply-To: <45a44e480901181546t140f7127hb2f2b5fbfdec8464@mail.gmail.com>
References: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
	 <49738B8C.7020404@bluewatersys.com>
	 <45a44e480901181546t140f7127hb2f2b5fbfdec8464@mail.gmail.com>
Date: Mon, 19 Jan 2009 07:48:50 +0800
Message-ID: <45a44e480901181548q3b22cc7cuad8cc0c7bc377c1f@mail.gmail.com>
Subject: Re: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 7:46 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
> On Mon, Jan 19, 2009 at 4:05 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
>> Jaya Kumar wrote:
>>> Hi friends,
>>>
>>
>>> +
>>> +     /* BATCH GPIO OUTPUT */
>>> +int gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int maskwidth);
>>> +
>>> +The following examples help explain how this function is to be used.
>>> + Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
>>> + A: gpio_set_batch(gpio=0, values=0x0, bitmask=0xFF, width=8);
>>> + Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
>>> + A: gpio_set_batch(gpio=58, values=0xFFFF, bitmask=0xFFFF, width=16);
>>> + Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
>>> + A: gpio_set_batch(gpio=16, values=0xCAFEC001, bitmask=0xFFFFFFFF, width=32);
>>> +
>>
>> Can the gpio_set_batch function be used to set non-consecutive gpios?
>> For example:
>>
>>  gpio_set_batch(0, 0x0, 0x88, 8);
>>
>> To clear gpios 3 and 7? It looks like the pxa implementation will
>
> Hi Ryan,
>
> For the first part, yes, it can do non-consecutive gpios by using the
> mask. Pins 3 and 7 are handled using a 5-bit mask. You'd  do
> gpio_set_batch(3 <- starting pin is gpio 3, 0x0 <- clear, 0x1F <-
> mask, 5 <- bit width of mask);

Correction: I meant to write 0x11 for the mask above (instead of 0x1F)
since you only want to clear the starting pin 3 and the ending pin 7
in the 5 bits. If we used 0x1F here, then we would clear all 5 bits
rather than just 3 and 7.

Thanks,
jaya
