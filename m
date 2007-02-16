Return-Path: <linux-kernel-owner+w=401wt.eu-S1946261AbXBPVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946261AbXBPVYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946262AbXBPVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:24:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:3433 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946261AbXBPVYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JEyDvZGx1+xKdqng157a/FG+XWuYw/lVQUA5qOMy2M1mj6x7mTJu15JdRurGyaVWQOoATDJIais4TmTyIzFJzaixT117Xz7sH+3FMetIyCtBwNH8Rx+LY65cgw4EZjblVSaXpyRLzavI3Joz+2+K/830BKX43sWncrRJu1gJEOQ=
Message-ID: <6bffcb0e0702161324p217198a0t88fd1058ac0005ca@mail.gmail.com>
Date: Fri, 16 Feb 2007 22:24:39 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.20-git13 kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1171660939.30834.102.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 2007-02-16 at 21:38 +0100, Michal Piotrowski wrote:
> > Hi,
> >
> > This looks like a tickless stuff
>
> Yup.
>
> > 0xc0139ea0 is in tick_nohz_stop_sched_tick (/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168).
> > 163
> > 164             if (need_resched())
> > 165                     goto end;
> > 166
> > 167             cpu = smp_processor_id();
> > 168             BUG_ON(local_softirq_pending());
>
> Hmm, the BUG_ON is inside of an interrupt disabled region, so we should
> have bailed out early in the need_resched() check above (because we are
> in the idle task context according to the stack trace).
>
> Is this reproducible ?

Yes.

>
>         tglx
>
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
