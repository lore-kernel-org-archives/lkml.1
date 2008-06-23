Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbYFWTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbYFWTcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbYFWTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:31:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:12919 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762950AbYFWTb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dNmGNIQqcQOWwgXdk4YTJoTuQEZRwF7YFkwU5gzVPq6GSwpVsZ/NamVDeIJNttq4Ez
         Ot4hkPZv2KuXB1Anv+rCxJdFIu/Auc49eFgFijD0FmxfOv1sN2DEsmOKe/GLG3BdXjv/
         75YTebhriDBzRmIJbDJENnrHhnW/XCy1ylq4Y=
Message-ID: <19f34abd0806231231l13a3c2fek6fb9d7c1858be0b6@mail.gmail.com>
Date: Mon, 23 Jun 2008 21:31:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [PATCH] softirq softlockup debugging
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <485EC1A1.1020503@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622122845.GA10133@damson.getinternet.no>
	 <485EC1A1.1020503@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 11:18 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> Vegard Nossum wrote:
>
> Hi
>
> I like the general idea a lot; some comments below on the patch

Thanks.

>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index f1fc747..97d47cf 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -296,6 +296,9 @@ extern void softirq_init(void);
>>  extern void raise_softirq_irqoff(unsigned int nr);
>>  extern void raise_softirq(unsigned int nr);
>>  +#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
>> +extern void *get_last_softirq_action(int cpu);
>> +#endif
>
> you don't need to ifdef prototypes....
> (there's only one exception: if the prototype uses types that are ifdef'd
> themselves, but that's not here)
>
>
> In general... I don't like that this is a config option. I mean... is there
> a really strong
> reason why this shouldn't just always be there?

I thought it would be unacceptable to always have it there given the
performance hit. It's just bound to show up in some benchmark that
some guy runs in the next couple of releases, isn't it? :-D

(Or maybe it isn't that bad. I honestly have no idea. It should be
just a single "store", but if I understood correctly, this loop is
also frequently run.)

Also, as spotted by Johannes Weiner, this is only an issue for
handlers where interrupts are disabled inside the handler (because the
handler itself is run with irqs enabled). Still, it would be nice to
be able to catch those few warnings of this kind that showed up in
kerneloops.org and for which we have no idea what happened or whether
it has been fixed.

Do you think I should resubmit without the CONFIG? (Does anybody else
have an opinion?)

Thank you so much for looking :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
