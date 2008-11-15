Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYKORHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYKORHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYKORGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:06:53 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:47177 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYKORGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IjjtcVR/q7PTO2xVxnqiHAFcUdxaX+QjUkLtPUt9RmQVpIgqCV7nIJB1ab9rAqf335
         6AetN3ygpVnv7WiyrrvZs6Vt+MtLaicw+EQ7y0PH0FZRZ8jQvWgMK2yKmc6dz1YWdzL9
         FrqngKq8CdJGweKHoRVVB/stLeg1QyMKdmXq0=
Message-ID: <2375c9f90811150906r6b2437e9w7c363c40897a862a@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:06:50 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 1/5] x86: ia32_signal: cleanup macro COPY
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <491E4101.7010405@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491E4101.7010405@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 3:24 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup
>
> No need to use temporary variable in this case.
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/ia32/ia32_signal.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> index e886907..a28790a 100644
> --- a/arch/x86/ia32/ia32_signal.c
> +++ b/arch/x86/ia32/ia32_signal.c
> @@ -197,10 +197,8 @@ struct rt_sigframe
>        /* fp state follows here */
>  };
>
> -#define COPY(x)                {               \
> -       unsigned int reg;               \
> -       err |= __get_user(reg, &sc->x); \
> -       regs->x = reg;                  \
> +#define COPY(x)                        {               \
> +       err |= __get_user(regs->x, &sc->x);     \
>  }

Then you can also kill the braces now. :)

What's more, if I saw it correctly, the belowing two __get_user() calls can
also be replaced by COPY().
