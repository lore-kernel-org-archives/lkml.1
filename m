Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZLAEIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZLAEIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZLAEIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:08:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58175 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZLAEIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YA+VuQ5adZTDAV+1IV3wGqZU38RwF307xs5IndgRDdX3odJzw0UrzDJ21RVahr7Qgm
         4JC3Qur/IMZWi10K+U6eA7JwfjlPPt8TSpJKO2SLANf0K9qAwnQXlusB81acyW1kaMBB
         ARaZSFpCbYgUSPusLxhYjn/HjGwmvXyaakdyk=
MIME-Version: 1.0
In-Reply-To: <20091021164431.6193d96b@buddha>
References: <20091021164431.6193d96b@buddha>
Date: Mon, 30 Nov 2009 23:08:51 -0500
Message-ID: <b4198de60911302008g5c25c9f3id36fe3748ad7d666@mail.gmail.com>
Subject: Re: [PATCH] alpha: Wire up missing/new syscalls
From: Matt Turner <mattst88@gmail.com>
To: Daniele Calore <orkaan@orkaan.org>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 9:44 AM, Daniele Calore <orkaan@orkaan.org> wrote:
> This wire up the: fallocate, timerfd_create, timerfd_settime, timerfd_gettime
> signalfd4, eventfd2, epoll_create1, dup3, pipe2, inotify_init1, preadv,
> pwritev and rt_tgsigqueueinfo syscalls for the alpha port.
>
> For umount2, alpha have an "old" and "new" version called: oldumount and umount;
> so ignore umount2.
>
> Signed-off-by: Daniele Calore <orkaan@orkaan.org>
>
> ---
> diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
> index 5b5c174..17f72b7 100644
> --- a/arch/alpha/include/asm/unistd.h
> +++ b/arch/alpha/include/asm/unistd.h
> @@ -247,6 +247,7 @@
>  #define __IGNORE_pause
>  #define __IGNORE_time
>  #define __IGNORE_utime
> +#define __IGNORE_umount2
>
>  /*
>  * Linux-specific system calls begin at 300
> @@ -433,10 +434,23 @@
>  #define __NR_signalfd                  476
>  #define __NR_timerfd                   477
>  #define __NR_eventfd                   478
> +#define __NR_fallocate                 479
> +#define __NR_timerfd_create            480
> +#define __NR_timerfd_settime           481
> +#define __NR_timerfd_gettime           482
> +#define __NR_signalfd4                 483
> +#define __NR_eventfd2                  484
> +#define __NR_epoll_create1             485
> +#define __NR_dup3                      486
> +#define __NR_pipe2                     487
> +#define __NR_inotify_init1             488
> +#define __NR_preadv                    489
> +#define __NR_pwritev                   490
> +#define __NR_rt_tgsigqueueinfo         491
>
>  #ifdef __KERNEL__
>
> -#define NR_SYSCALLS                    479
> +#define NR_SYSCALLS                    492
>
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
> index 95c9aef..78199b9 100644
> --- a/arch/alpha/kernel/systbls.S
> +++ b/arch/alpha/kernel/systbls.S
> @@ -495,8 +495,21 @@ sys_call_table:
>        .quad sys_epoll_pwait
>        .quad sys_utimensat                     /* 475 */
>        .quad sys_signalfd
> -       .quad sys_ni_syscall
> +       .quad sys_ni_syscall                    /* sys_timerfd */
>        .quad sys_eventfd
> +       .quad sys_fallocate
> +       .quad sys_timerfd_create                /* 480 */
> +       .quad sys_timerfd_settime
> +       .quad sys_timerfd_gettime
> +       .quad sys_signalfd4
> +       .quad sys_eventfd2
> +       .quad sys_epoll_create1                 /* 485 */
> +       .quad sys_dup3
> +       .quad sys_pipe2
> +       .quad sys_inotify_init1
> +       .quad sys_preadv
> +       .quad sys_pwritev                       /* 490 */
> +       .quad sys_rt_tgsigqueueinfo
>
>        .size sys_call_table, . - sys_call_table
>        .type sys_call_table, @object
> --

Applied to alpha-2.6.git. Thanks!

Matt
