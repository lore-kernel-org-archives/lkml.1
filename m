Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZAYQbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZAYQbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZAYQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:31:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:27801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZAYQbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:31:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MHYsu8PbgJFLA54K40LnoYtSBmj8oSmBr1FEZGFpMvPu4OApbqA/Y1gQjwT8UlDzgZ
         Y6Kk4t7JUZrWjVZMnkQzmFFhyExheQDH9mCgkwmsXbHfNB7m6+9noPpP0A+sUiNXIT/8
         k+iQdL8r6yAKsVYYFToPqxnNrxqXXHxBeaPUo=
MIME-Version: 1.0
In-Reply-To: <20090124183746.395f597b.akpm@linux-foundation.org>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
	 <20090124183746.395f597b.akpm@linux-foundation.org>
Date: Sun, 25 Jan 2009 17:30:59 +0100
Message-ID: <8db1092f0901250830m3300f497yba50afc1a4f8d8e2@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/25 Andrew Morton <akpm@linux-foundation.org>:
[...]
>
>
> Does this fix it?

Yes, message has gone. Thanks for help.

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
>
> --- a/kernel/hrtimer.c~a
> +++ a/kernel/hrtimer.c
> @@ -562,7 +562,7 @@ static int hrtimer_reprogram(struct hrti
>  /*
>  * Retrigger next event is called after clock was set
>  *
> - * Called with interrupts disabled via on_each_cpu()
> + * Called with interrupts disabled.
>  */
>  static void retrigger_next_event(void *arg)
>  {
> @@ -614,8 +614,12 @@ void clock_was_set(void)
>  */
>  void hres_timers_resume(void)
>  {
> +       unsigned long flags;
> +
>        /* Retrigger the CPU local events: */
> +       local_irq_save(flags);
>        retrigger_next_event(NULL);
> +       local_irq_restore(flags);
>  }
>
>  /*
> _
>
>



-- 
Maciej Rutecki
http://www.maciek.unixy.pl
