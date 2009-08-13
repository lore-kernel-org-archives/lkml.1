Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZHMLE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZHMLE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZHMLE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:04:58 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:33889 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZHMLE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oI6u7+HYQAvcnm6NnggKubOR/Vexy852sGi5XBKG4921wzfhWkM9q7g3CaVJIq6tZ3
         Jh3Rlnz6jY99gRJJ6uaBbzgkuiWxGr8Adg1HcIZpUadt2hsZcK8tBrjgf0ZMxsL8Zkh8
         irnTrwjA2SY/pRaQ+zbE0dGlBhmtxkWQa8J/A=
MIME-Version: 1.0
In-Reply-To: <1250138467.15796.16.camel@quadrophenia.thebigcorporation.com>
References: <1250138467.15796.16.camel@quadrophenia.thebigcorporation.com>
Date: Thu, 13 Aug 2009 13:04:57 +0200
Message-ID: <520f0cf10908130404p86c991k85dcd797e7e21baa@mail.gmail.com>
Subject: Re: [PATCH][RT] Fix build errors in rtmutex
From: John Kacur <jkacur@gmail.com>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 6:41 AM, Sven-Thorsten
Dietrich<sdietrich@novell.com> wrote:
> Subject: Fix up "too few parameters to function" build errors in rtmutex
> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
>
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> Index: b/kernel/rtmutex.c
> ===================================================================
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -1513,7 +1513,8 @@ int rt_mutex_start_proxy_lock(struct rt_
>
>        mark_rt_mutex_waiters(lock);
>
> -       if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
> +       if (!rt_mutex_owner(lock) ||
> +          try_to_steal_lock(lock, task, STEAL_NORMAL)) {
>                /* We got the lock for task. */
>                debug_rt_mutex_lock(lock);
>                rt_mutex_set_owner(lock, task, 0);
> @@ -1522,7 +1523,8 @@ int rt_mutex_start_proxy_lock(struct rt_
>                return 1;
>        }
>
> -       ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> +       ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock,
> +                                    flags);
>
>        if (ret && !waiter->task) {
>                /*
> Index: b/kernel/trace/ring_buffer.c
> ===================================================================
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2522,7 +2522,7 @@ ring_buffer_peek(struct ring_buffer *buf
>        if (event && event->type_len == RINGBUF_TYPE_PADDING)
>                rb_advance_reader(cpu_buffer);
>        if (dolock)
> -               atomic_)spin_unlock(&cpu_buffer->reader_lock);
> +               atomic_spin_unlock(&cpu_buffer->reader_lock);
>        local_irq_restore(flags);
>
>        if (event && event->type_len == RINGBUF_TYPE_PADDING) {
>
>

Hi Sven

I have to admit I'm scratching my head over this one, I don't see any
rt trees that it applies to. Which version are you referring to here?

Thanks
