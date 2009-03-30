Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbZC3UQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbZC3UQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZC3UP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:15:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZC3UP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JhbTKZU6ZmdzZ6ln0TD5yX7eh3KjeD9tGvM/8VyqtNs2sX7OfAAVKwcSjILxRpUG0f
         uYSU93nT2taWAVnVaKAn7xpde0jPtXJf32fJw0xfh7LeT81Ol01ExkzyAJgb2Raj25Zd
         oQK9oOQm7QaaQfQruJh3jo4mszFbdwB4nOaKQ=
MIME-Version: 1.0
In-Reply-To: <200903282354.22331.rusty@rustcorp.com.au>
References: <200903282354.22331.rusty@rustcorp.com.au>
Date: Mon, 30 Mar 2009 22:15:54 +0200
X-Google-Sender-Auth: 24119f7ad4848e91
Message-ID: <5d9b736f0903301315n590edc81k1a4aa02f305b80ff@mail.gmail.com>
Subject: Re: [PATCH 5/5] uvesafb: improve parameter handling.
From: Michal Januszewski <spock@gentoo.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 15:24, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> 1) Now module_param(..., invbool, ...) requires a bool, and similarly
>   module_param(..., bool, ...) allows it, change pmi_setpal to a bool.
> 2) #define param_get_scroll to NULL, since it can never be called (perm
>   argument to module_param_named is 0).
> 3) Return -EINVAL from param_set_scroll if the value is bad, so it's
>   reported.
>
> Note that I don't think the old fb_get_options() is required for new
> drivers: the parameters automatically work as uvesafb.XXX=... anyway.
>
> Cc: Michal Januszewski <spock@gentoo.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Michał Januszewski <spock@gentoo.org>

> ---
>  drivers/video/uvesafb.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -45,7 +45,7 @@ static int mtrr               __devinitdata = 3; /* e
>  static int mtrr                __devinitdata = 3; /* enable mtrr by default */
>  static int blank       = 1;               /* enable blanking by default */
>  static int ypan                = 1;             /* 0: scroll, 1: ypan, 2: ywrap */
> -static int pmi_setpal  __devinitdata = 1; /* use PMI for palette changes */
> +static bool pmi_setpal __devinitdata = true; /* use PMI for palette changes */
>  static int nocrtc      __devinitdata; /* ignore CRTC settings */
>  static int noedid      __devinitdata; /* don't try DDC transfers */
>  static int vram_remap  __devinitdata; /* set amt. of memory to be used */
> @@ -2009,11 +2009,7 @@ static void __devexit uvesafb_exit(void)
>
>  module_exit(uvesafb_exit);
>
> -static int param_get_scroll(char *buffer, struct kernel_param *kp)
> -{
> -       return 0;
> -}
> -
> +#define param_get_scroll NULL
>  static int param_set_scroll(const char *val, struct kernel_param *kp)
>  {
>        ypan = 0;
> @@ -2024,6 +2020,8 @@ static int param_set_scroll(const char *
>                ypan = 1;
>        else if (!strcmp(val, "ywrap"))
>                ypan = 2;
> +       else
> +               return -EINVAL;
>
>        return 0;
>  }
>
>
