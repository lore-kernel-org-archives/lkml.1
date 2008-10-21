Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYJUSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYJUSmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJUSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:42:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:23947 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYJUSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Pay3rs5PgsXYGMm1tUj4zuB+j58A2C7m5/dZrdiEY0Ef3OILX2vyk+F++SPUhKKib4
         QPRkU+ZjVcfchmEHmUVIgV34NE+MfFVPzeg/ERn+gHrIy3WVURqxYObqH8D7RjSJPuqN
         xU4hCaGZT8b5xGiMJOnpZKIz/iqaauVw0AN58=
Message-ID: <86802c440810211142v30cf5b4s4f71aa1261526c08@mail.gmail.com>
Date: Tue, 21 Oct 2008 11:42:24 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Daniele Calore" <orkaan@orkaan.org>
Subject: Re: [PATCH 2.6.27] x86: memtest fix use of reserve_early()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081013103412.6fec375a@buddha>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081013103412.6fec375a@buddha>
X-Google-Sender-Auth: 559e8ac4e6a867ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 1:34 AM, Daniele Calore <orkaan@orkaan.org> wrote:
> Hi all,
>
> Wrong usage of 2nd parameter in reserve_early call.
> 66/75: reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
>                                ^^^^^^^^^^^^^^^^^^^^
>
> The correct way is to use 'end' address and not 'size'.
> As a bonus a fix to the printk format.
>
> Signed-off-by: Daniele Calore <orkaan@orkaan.org>
>
> ---
> diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> index 672e17f..9cab18b 100644
> --- a/arch/x86/mm/memtest.c
> +++ b/arch/x86/mm/memtest.c
> @@ -61,9 +61,9 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
>                                last_bad += incr;
>                        } else {
>                                if (start_bad) {
> -                                       printk(KERN_CONT "\n  %010lx bad mem addr %010lx - %010lx reserved",
> +                                       printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
>                                                val, start_bad, last_bad + incr);
> -                                       reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
> +                                       reserve_early(start_bad, last_bad + incr, "BAD RAM");
>                                }
>                                start_bad = last_bad = start_phys_aligned;
>                        }
> @@ -72,9 +72,8 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
>        if (start_bad) {
>                printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
>                        val, start_bad, last_bad + incr);
> -               reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
> +               reserve_early(start_bad, last_bad + incr, "BAD RAM");
>        }
> -
>  }
>
>  /* default is disabled */

Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks

YH
