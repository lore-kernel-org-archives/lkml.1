Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbZKYOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbZKYOQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZKYOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:16:49 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:51643 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZKYOQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kt/hcvffEgdb6A2YR6bne4fWVk8jmOEdlCZ+NL38tu6tatOIU7PC6cVSfpxONU7KB1
         qTHQidiKXsICy8ebrHpqWLc/BvtatZnKPAtAcOpf4CmX8RrhECvXfcptssrEIal7KAZ/
         uKno5SRfpJcNlHARPaCouBaRXPmtucED/bUDM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911251503400.24119@localhost.localdomain>
References: <200911252204173129580@gmail.com>
	 <alpine.LFD.2.00.0911251503400.24119@localhost.localdomain>
Date: Wed, 25 Nov 2009 22:16:55 +0800
Message-ID: <2674af740911250616l201e92d0j81680e7b72d3d5ea@mail.gmail.com>
Subject: Re: [PATCH V2]irq/core: Add a length limitation
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Liuweni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, xgr178 <xgr178@163.com>,
       strongzgy <strongzgy@gmail.com>, qingshenlwy <qingshenlwy@tom.com>,
       rusty <rusty@rustcorp.com.au>, travis <travis@sgi.com>,
       adobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 10:08 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 Nov 2009, Liuweni wrote:
>
>>  ---
>> In this version, I modify the code by Ingo's suggestion,
>> and less code add.
>> The code will check the irqaction->name's length
>> and avoid Using too long name without any notice.
>>
>> --- a/kernel/irq/proc.c
>> +++ b/kernel/irq/proc.c
>> @@ -196,6 +196,8 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
>>       char name [MAX_NAMELEN];
>>       struct irq_desc *desc = irq_to_desc(irq);
>>
>> +     WARN_ON(strlen(action->name) < MAX_NAMELEN);
>> +
>
> This is going to warn on every action->name which is actually used in
> the kernel except for the ones which are too long.
>

Even we add WARN_ON(strlen(action->name) > MAX_NAMELEN), I think it doesn't
affect the runtime things, what it could tell is that there maybe two
different irqs
with the same name showed under /proc

Thanks,
Yong

> Thanks,
>
>        tglx
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
