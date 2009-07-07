Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZGGKkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZGGKkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZGGKkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:40:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51991 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZGGKke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:40:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kde+J5r+C1bZ/8NlTjRE8EqYoDSHZWVIFD2LhXEIjJ7Ngv+LaSoHynWWMItJxu/Y7y
         AO5owpTwU4EGTgobZn+Ik6DGGqtvFSp3UTzZuGH2cK6AmUAUPxKH8/wE4zcRxQ8KnPka
         MhwjHKGxVmF0u+WX88U8ib29UvNjoILWS/PHk=
MIME-Version: 1.0
In-Reply-To: <20090707065014.GA3296@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <20090706163106.GA4559@ami.dom.local> 
	<a5d9929e0907061023g4306d80ewfc8907653b949005@mail.gmail.com> 
	<200907061926.43625.andres@anarazel.de> <20090707065014.GA3296@ami.dom.local>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 11:40:16 +0100
Message-ID: <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( 
	possibly?caused by netem)
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am now running 2.6.31-rc2 for a couple of hours, no freeze.

Let me know what/if i can help with tracking down the original source
of the problem.

Thank you very much for your time,
Joao Correia

On Tue, Jul 7, 2009 at 7:50 AM, Jarek Poplawski<jarkao2@gmail.com> wrote:
> On Mon, Jul 06, 2009 at 07:26:43PM +0200, Andres Freund wrote:
>> On Monday 06 July 2009 19:23:18 Joao Correia wrote:
>> > Hello
>> >
>> > Since i already had the kernel compiled and ready to boot when i read
>> > this, i gave it a go anyway :-).
>> >
>> > I can reproduce the freeze with those 4 patches applied, so i can
>> > confirm that its, at least, related to, or exposed by, those patches.
>> > There must be something else too, or its just too much fuzziness, but
>> > the freeze takes a bit more time (approximately five minutes, give or
>> > take) compared to the instant freeze before, but its there with the
>> > patches, and without them, no freeze.
>> >
>> > I assume there isnt a "safe" way to get them out of current .31-rc's,
>> > right?
>> `echo 0 > /proc/sys/kernel/timer_migration` should mitigate the problem.
>
> I guess it should fix it entirely. Btw., here is a patch disabling the
> timers' part, so to make it hrtimers only. Could you try?
>
> Thanks,
> Jarek P.
> ---
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 0b36b9e..011429c 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -634,7 +634,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
>
>        cpu = smp_processor_id();
>
> -#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
> +#if 0
>        if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
>                int preferred_cpu = get_nohz_load_balancer();
>
>
