Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZABF4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZABF4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 00:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZABF4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 00:56:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:55317 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZABF4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 00:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YX3JcBDBDs0AyORXwFxBpBtwQuQQWF35+o40NxgvR6VzGDqM3fl5ZvYHp9kCga+z0O
         h8zhg/No2RXbk5m0CKPmtyAjdfprzwLXPPMzXHSrgut/IQquaTTmy/LKSpBzSn0x4Ax4
         HRhnB31YGYvzUQXPReHmlsgdTvgQRT3gLYPcE=
Message-ID: <2f11576a0901012156w30a6b162v96aed31d357929e6@mail.gmail.com>
Date: Fri, 2 Jan 2009 14:56:23 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Raja R Harinath" <harinath@hurrynot.org>
Subject: Re: [PATCH for -tip 4/4] irq: for_each_irq_desc() makes simplify
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87wsdezyu6.fsf@hariville.hurrynot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081226122830.5CAF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <87wsdezyu6.fsf@hariville.hurrynot.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>>  # define for_each_irq_desc(irq, desc)                                        \
>>       for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;           \
>> -          irq++, desc = irq_to_desc(irq))
>> +          irq++, desc = irq_to_desc(irq))                            \
>> +             if (desc)
>> +
>> +
>>  # define for_each_irq_desc_reverse(irq, desc)                                \
>>       for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;      \
>> -          irq--, desc = irq_to_desc(irq))
>> +          irq--, desc = irq_to_desc(irq))                            \
>> +             if (desc)
>
> I know this has gone in, but isn't this naked 'if' unsafe.  Consider the
> following hypothetical code:
>
>  if (safe)
>    for_each_irq_desc(irq, desc) {
>       ...
>    }
>  else
>    panic();
>
> With the macro definition above, the loop would panic() each time !desc,
> and _not_ panic() when !safe.  I'd consider this behaviour to be
> unexpected, to say the least :-)

Correct.

> The fix is to change the
>
>  if (desc)
>
> in the macro to
>
>  if (!desc) ; else

Ok. I'll do that.
Very thanks for good reviewing.

btw, actually current kernel aready have similar macros.
e.g.

#define for_each_node_with_cpus(node)                   \
        for_each_online_node(node)                      \
                if (nr_cpus_node(node))


Shoud we fixed it too? ;-)
