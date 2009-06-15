Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZFODWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZFODWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbZFODUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:20:25 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:36041 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbZFODUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v0CfcSi4ErKin4m+ee1aIx0UyLW8gjNwWokOVqBW1XKcV1uJojJ5M06k+IC7fT4Iqu
         yLkxATMSyw97ui1YfpWkJBrVzZWw+U6Lm09dS+niy8bOR7ujtxX57knUnHjxeEycRsWP
         oc5hnCl7KUxW18tLxJqXuwC7uMEfgdnJUyXqI=
MIME-Version: 1.0
In-Reply-To: <2674af740906140833h608ffdefj746096af3a559876@mail.gmail.com>
References: <2674af740906140833h608ffdefj746096af3a559876@mail.gmail.com>
Date: Mon, 15 Jun 2009 11:20:25 +0800
Message-ID: <2375c9f90906142020j74dd3849mc53cc7399ae4243c@mail.gmail.com>
Subject: Re: [PATCH] setup_affinity return 1 with failure
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:33 PM, Yong Zhang<yong.zhang0@gmail.com> wrote:
> setup_affinity should return 1 when failure, then make checking in
> irq_select_affinity_usr() reasonable.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Looks good.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  kernel/irq/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index aaf5c9d..8d2a992 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -137,7 +137,7 @@ int irq_set_affinity(unsigned int irq, const
> struct cpumask *cpumask)
>  static int setup_affinity(unsigned int irq, struct irq_desc *desc)
>  {
>        if (!irq_can_set_affinity(irq))
> -               return 0;
> +               return 1;
>
>        /*
>         * Preserve an userspace affinity setup, but make sure that
> --
> 1.6.0.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
