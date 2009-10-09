Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbZJIG5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbZJIG5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 02:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbZJIG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 02:57:05 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:37849 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbZJIG5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 02:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PqdE2UEYfqnXBvsMh1BurcojZKcKTImcJM9i8Ic1Y3LW5f2GW5aGYMzYztrgYXXCeL
         R5xkJ1JTCGYnkxScxEjj7WANsRylqRhsmoO19VgvAbmH2C31NIyKE9C3/NYcd5OSja5S
         H6z4ybRpTaDRtGKKtJSfXvW2MAkQkJD6nO2J8=
MIME-Version: 1.0
In-Reply-To: <1255015903.14496.44.camel@falcon>
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com>
	 <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
	 <1255015903.14496.44.camel@falcon>
Date: Fri, 9 Oct 2009 14:56:27 +0800
Message-ID: <2674af740910082356i7197ad5yd9f00e2ca2ab64c5@mail.gmail.com>
Subject: Re: [PATCH] kernel/time/tick-sched.c: fix warning of printk's 
	argument format
From: Yong Zhang <yong.zhang0@gmail.com>
To: wuzhangjin@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, ralf@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 11:31 PM, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> On Thu, 2009-10-08 at 08:03 -0700, Linus Torvalds wrote:
>>
>> On Thu, 8 Oct 2009, Wu Zhangjin wrote:
>> >
>> > This patch will fix the following warning:
>>
>> No it won't. It will add a lot of new warnings.
>>
>> The thing is, almost all architectures (including x86) have
>>
>>       unsigned int __softirq_pending;
>>
>> but then in <asm-generic/hardirq.h> we have
>>
>>       unsigned long __softirq_pending;
>>
>> for some unfathomable reason. Quite frankly, I think Arnd just screwed up
>> the "generic" version, and the fix is almost certainly to just make the
>> generic version match all the main architectures.
>>
>> I don't have any architectures using the generic header file, though, so
>> I'm not going to do that change blindly. People who do should look at it
>> (alpha, powerpc and mips look like the only ones that might be 64-bit, but
>> I didn't check very carefully - just grepped for it)
>>
>> Added Cc's for some people that have worked on, or used, that generic
>> header file. Is there any possible reason why it is "unsigned long" in
>> that one?
>>
>
> I'm really using a MIPS machine! there is only a "unsigned long"
> definition in include/asm-generic/hardirq.h.
>

So this is introduced by 24ffce18a4b6b5e9769200582c09df7ff044259f.
     MIPS: Convert to asm-generic/hardirq.h

Cced Ralf.

Thanks,
Yong

> Regards,
>        Wu Zhangjin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
