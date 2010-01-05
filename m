Return-Path: <linux-kernel-owner+w=401wt.eu-S932181Ab0AEW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0AEW6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129Ab0AEW6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:58:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63566 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0AEW6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FX/WMwQuJWZxAWtKgWeTVCSguyDbqmghHoP832eP/ueK+OLiYbgicZJo0qp66Nt3cc
         U8BqLBqdm6jJViU+l7wjb1IjvWg9WObBPlCXBhF63qRJF36RkdeqVjBOlsNzkoyb/Xgn
         MchNSvmzyTE44MQI+NZnefxovnkfK0eysPWTY=
MIME-Version: 1.0
In-Reply-To: <4B4311E8.1000001@redhat.com>
References: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>
	 <1262392920.32223.10.camel@laptop>
	 <6041d2001001041043ka810288l64ae9d6d8105b284@mail.gmail.com>
	 <4B42AA40.3060406@redhat.com>
	 <6041d2001001041923u7bd512a6w4b5399af17424422@mail.gmail.com>
	 <4B4311E8.1000001@redhat.com>
Date: Tue, 5 Jan 2010 17:58:30 -0500
Message-ID: <6041d2001001051458j46cdf7abqc4a0a249445ec348@mail.gmail.com>
Subject: Re: BUG during shutdown - bisected to commit e2912009
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 5:18 AM, Xiaotian Feng <dfeng@redhat.com> wrote:
> This is outputed by sound module, but it will not affect clockevents, could
> you please try following patch and let me know the output before BUG_ON
> happens? We can gather more information on the BUG_ON. Thank you.
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 6f740d9..7c945e8 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -260,6 +260,9 @@ void clockevents_notify(unsigned long reason, void *arg)
>                list_for_each_entry_safe(dev, tmp, &clockevent_devices, list)
> {
>                        if (cpumask_test_cpu(cpu, dev->cpumask) &&
>                            cpumask_weight(dev->cpumask) == 1) {
> +                               if (dev->mode != CLOCK_EVT_MODE_UNUSED)
> +                                       printk("invalid dev %s mode %d on
> cpu %d\n", dev->name,
> +                                               dev->mode, cpu);
>                                BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
>                                list_del(&dev->list);

I don't get anything on screen from the printk - is there a trick
needed to getting printk output at that stage of shutting down?  I
tried inserting an mdelay() before the BUG, which delayed the bug
output but still didn't print the invalid dev message.

Thanks,
Marc
