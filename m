Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYHORHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYHORHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHORH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:07:28 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49024 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYHORH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lQxDhPhSYqRBePdNdsQKejAa/PswHg+9fu9rPmnYksP68Yep4t/C68ZUToR6ALX4Y9
         KmGeuihfGgXge7qHW+F/UknRdiQvdREry5fzKPwGKUK9XAwdxkBhZ0yaqvQO2GVnYZGp
         i/m46SKp2euomlD9g4Lg4XEe0pe4V404c5A4w=
Message-ID: <86802c440808151007m361fdd48p32432a4467238a64@mail.gmail.com>
Date: Fri, 15 Aug 2008 10:07:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1218796084.10800.239.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080815082735.GC4776@elte.hu>
	 <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com>
	 <20080815085120.GA18748@elte.hu> <20080815093546.GA9312@elte.hu>
	 <1218794430.10800.237.camel@twins> <20080815101927.GA4770@elte.hu>
	 <1218796084.10800.239.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 3:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2008-08-15 at 12:19 +0200, Ingo Molnar wrote:
>> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> > On Fri, 2008-08-15 at 11:35 +0200, Ingo Molnar wrote:
>> >
>> > > looks wrong - it should be unconditional (i've done that via the patch
>> > > below). I dont remember why we made early_init_irq_lock_class()
>> > > dependent on CONFIG_TRACE_IRQFLAGS before. Peter, do you have any
>> > > memories?
>> >
>> > Nope, git suggests I poke you about it.. :-)
>>
>> muhaha - i dont even know that guy who did this sloppy commit 2 years
>> ago - "Ingo Molnar", or however he is called.
>>
>> I believe my (mistaken) thinking would have been that desc->irq lockdep
>> class does not matter as long as we dont do irq-tracing. Which might
>> have been borderline correct then but is wrong now, for things like
>> lockstat?
>
> /me pokes a bit at kconfig dependancies, and yes, it seems you're right
> - lockstat doesn't require irq tracing..

can you check if

#ifdef CONFIG_TRACE_IRQFLAGS
void early_init_irq_lock_class(void)
{
#ifndef CONFIG_HAVE_DYN_ARRAY
        int i;

        for (i = 0; i < nr_irqs; i++)
                lockdep_set_class(&irq_descX[i].lock, &irq_desc_lock_class);
#endif
}
#endif

in kernel/irq/handle.c is right too?

YH
