Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYKJMni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYKJMni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYKJMn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:43:27 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:21195 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYKJMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nbuoWDd8/aAwuCu07y6B8dUAkLOw0VfKbwMRXOsqyTPNFHV7bJI2zInn+mXpft/mQg
         fbgl3e8tjtXARC+1vMNr2Ps5LumNaJxLjNsRNwIXNiJO1N3B5oU27vNpJ9XejssSWdtQ
         CiGNQCCekGH6eRGKWHA+v3OJii+O0oxfYzFMI=
Message-ID: <e2e108260811100443j18a6353cj8d47ee3f1f8bec1@mail.gmail.com>
Date: Mon, 10 Nov 2008 13:43:24 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] C99 initializers for DEFINE_RATELIMIT_STATE()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200811042114.48495.bart.vanassche@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811042114.48495.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone please be so kind to ACK the patch below, NAK it or tell
me whether I should send the patch below to someone else ?

Thanks,

Bart.

On Tue, Nov 4, 2008 at 9:14 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> A few months ago (July 25, 2008) the printk ratelimiting code has been
> rewritten. This patch added a.o. the new macro DEFINE_RATELIMIT_STATE(). The
> patch below converts the initializers in that macro to C99 style.
>
> For more information about the printk ratelimiting rewrite, see also commit
> 717115e1a5856b57af0f71e1df7149108294fc10
> (http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=717115e1a5856b57af0f71e1df7149108294fc10).
>
> Impact: cleanup, no functionality changed.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
>
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index 18a5b9b..61cc908 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -13,8 +13,9 @@ struct ratelimit_state {
>        unsigned long begin;
>  };
>
> -#define DEFINE_RATELIMIT_STATE(name, interval, burst)          \
> -               struct ratelimit_state name = {interval, burst,}
> +#define DEFINE_RATELIMIT_STATE(name, interval_value, burst_value)      \
> +       struct ratelimit_state name =                                   \
> +               { .interval = (interval_value), .burst = (burst_value) }
>
>  extern int __ratelimit(struct ratelimit_state *rs);
>
