Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZIXUyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZIXUyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZIXUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:54:10 -0400
Received: from mail-yx0-f183.google.com ([209.85.210.183]:46109 "EHLO
	mail-yx0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZIXUyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:54:09 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 16:54:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R8Jm/Tjq46jpF/cUJ/IEg1CVIPXyP62jNYp/fy/R0R8tH2mpYhevdhVRTbCFxUhs5z
         MboYlQgMA0k8xkUhvv5CkkGHsN8xAV9E0r4766WiWyAhZdEgYZOAiJmBdoOBV7YXkzNV
         MWF9Y5/nDcGETh5tj/Yg0lGi+RvdgAhWi0YHo=
MIME-Version: 1.0
In-Reply-To: <1253825033-30094-1-git-send-email-linux@bohmer.net>
References: <1253825033-30094-1-git-send-email-linux@bohmer.net>
Date: Thu, 24 Sep 2009 22:46:36 +0200
X-Google-Sender-Auth: afc01babdf2f0f0f
Message-ID: <3efb10970909241346r36d284ebufbe17e24fb133bd6@mail.gmail.com>
Subject: Re: [PATCH] get rid of [softirq-NULL]
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: Remy Bohmer <linux@bohmer.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/24 Remy Bohmer <linux@bohmer.net>:
> if CONFIG_HIGH_RES_TIMERS is not configured, still the hrtimer-softirq
> is started, so to prevent the name 'softirq-NULL' in 'ps' output we
> should still define its name here.
> Preventing the softirq from starting at all would touch much more code, so
> I chose the easy way here, it is a cosmetic fix anyway.
>
> Signed-off-by: Remy Bohmer <linux@bohmer.net>

oops... Forgot to mention that this patch applies to 2.6.31-rt11 (preempt-RT)

> ---
>  kernel/softirq.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index aae8d45..590049c 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -1139,9 +1139,7 @@ static const char *softirq_names [] =
>   [NET_RX_SOFTIRQ]     = "net-rx",
>   [BLOCK_SOFTIRQ]      = "block",
>   [TASKLET_SOFTIRQ]    = "tasklet",
> -#ifdef CONFIG_HIGH_RES_TIMERS
>   [HRTIMER_SOFTIRQ]    = "hrtimer",
> -#endif
>   [RCU_SOFTIRQ]                = "rcu",
>  };
>
> --
> 1.6.0.4
>
>
