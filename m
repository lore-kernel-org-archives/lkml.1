Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYAAO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYAAO54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYAAO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:57:45 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:24783 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYAAO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SwCc5faNlYocIr1l78FkJRlyiLnt05feQQK2YRayH8I/IJ5y8JXr1jZZJLAz0ErXWKplVtgbeT0rWpQqlQ4VwKk8w8/Q3uBKugkc8WLLBrEH9BHqbOdgjiYGm0iFRATWWm4vZKqaJcwv2xCmE3PgiSazXELteB+mcuqz/II22cs=
Message-ID: <386072610801010657o59fd2aboee90e29f8a637a7f@mail.gmail.com>
Date: Tue, 1 Jan 2008 22:57:38 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] make BINFMT_FLAT a bool
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20080101134831.GM2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080101134831.GM2360@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 1, 2008 9:48 PM, Adrian Bunk <bunk@kernel.org> wrote:
> I have not yet seen anyone saying he has a reasonable use case for using
> BINFMT_FLAT modular on his embedded device.
>
> Considering that fs/binfmt_flat.c even lacks a MODULE_LICENSE() I really
> doubt there is any, and this patch therefore makes BINFMT_FLAT a bool.
>

It is OK for Blackfin. There is no application using FLAT binary
format as module.

Thanks
-Bryan

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  fs/Kconfig.binfmt |    2 +-
>  fs/binfmt_flat.c  |    6 ------
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
> 5437fb7517380d1b93dde3c09dbd3a2efaf276c3
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index d4fc609..c16a16c 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -37,7 +37,7 @@ config BINFMT_ELF_FDPIC
>           It is also possible to run FDPIC ELF binaries on MMU linux also.
>
>  config BINFMT_FLAT
> -       tristate "Kernel support for flat binaries"
> +       bool "Kernel support for flat binaries"
>         depends on !MMU
>         help
>           Support uClinux FLAT format binaries.
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 33764fd..274d723 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -933,14 +933,8 @@ static int __init init_flat_binfmt(void)
>         return register_binfmt(&flat_format);
>  }
>
> -static void __exit exit_flat_binfmt(void)
> -{
> -       unregister_binfmt(&flat_format);
> -}
> -
>  /****************************************************************************/
>
>  core_initcall(init_flat_binfmt);
> -module_exit(exit_flat_binfmt);
>
>  /****************************************************************************/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
