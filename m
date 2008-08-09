Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYHIVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYHIVVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHIVVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:21:47 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:26569 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYHIVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D1shSHZ+Hl09jJv05GaSA5MghJz3WX0wsRIYsNxJgZBngn6ewA5qHWIPAGeQTK0co/
         juLDAWIyO2eFR7vMZqBQKsI1JFComqkwRGuY6NXgj9oxURDYWn1RIByilBmgSmwCF0pJ
         6g5+vCAXPHLqEYlzcFQHKGkow1N9kxURy2or8=
Message-ID: <86802c440808091421n50fd4b25i73e1bd00d7a8a67e@mail.gmail.com>
Date: Sat, 9 Aug 2008 14:21:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 08/42] introduce nr_irqs
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m14p5uuqh3.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	 <m1ej4zvw6s.fsf@frodo.ebiederm.org>
	 <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
	 <489CFA0A.5030609@zytor.com>
	 <86802c440808090030k7269590ftf233a13a21a2e37e@mail.gmail.com>
	 <m14p5uuqh3.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 9:02 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>>> Also, what's the point, if it's just a renaming?
>>
>> that is the start point.
>> nr_irqs is variable, and will be probed later. and use that number to
>> init dyn_alloc.
>
> YH.
>
> In my conception the code in kernel/irq.c that today does:
>
> struct irq_desc *desc;
> if (irq >= NR_IRQS)
>   return -EINVAL;
> desc = irq_desc + irq;
>
> Should become:
>
> struct irq_desc *desc;
> desc = irq_desc(irq);
> if (!desc)
>   return -EINVAL;
>

OK.

also want to introduce dummy
struct irq_desc
{
   unsigned int irq;
};

in linux/interrupt.h if GENERIC_HARDIRQS is not defined.
so could have same interface
irq_desc()
and
for_each_irq_desc(irq, desc)

YH
