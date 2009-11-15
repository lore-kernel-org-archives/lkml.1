Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZKOCwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZKOCwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 21:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZKOCwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 21:52:51 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:36092 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZKOCwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 21:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eYB70kx2kDpNpAADRJHUVC1nj3bhRzjnOav2B4KYVb3I3I6J/1LBjh962IZ3BNv0Nf
         zKcLsEHdJUbtp0a6wPLpT2G7ROuuSR8oZWU1D9+WzEge2q6MM7B9azUqMR0vxqtzzn2Z
         E5IVlDkWnrHe/ojCDJ0LoeffLD9bGw0AJzajw=
MIME-Version: 1.0
In-Reply-To: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
References: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 14 Nov 2009 21:52:36 -0500
Message-ID: <8bd0f97a0911141852x33dedba8g7d3c3b134ff654b@mail.gmail.com>
Subject: Re: [PATCH] blackfin/trivial: remove duplicated MAX macro from stamp.
To: Thiago Farina <tfransosi@gmail.com>
Cc: trivial@kernel.org, cooloney@kernel.org, michael.hennerich@analog.com,
       barry.song@analog.com, yi.li@analog.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 16:04, Thiago Farina wrote:
> Since the kernel api already has the macro "max",
> just use it instead of declaring another one.
>
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -385,10 +385,9 @@ static struct platform_nand_data bfin_plat_nand_data = {
>        },
>  };
>
> -#define MAX(x, y) (x > y ? x : y)
>  static struct resource bfin_plat_nand_resources = {
>        .start = 0x20212000,
> -       .end   = 0x20212000 + (1 << MAX(BFIN_NAND_PLAT_CLE, BFIN_NAND_PLAT_ALE)),
> +       .end   = 0x20212000 + (1 << max(BFIN_NAND_PLAT_CLE, BFIN_NAND_PLAT_ALE)),

sorry, going to have to reject this.  the common min/max defines are
not usable in this context.  this patch produces a build failure:
  CC      arch/blackfin/mach-bf537/boards/stamp.o
arch/blackfin/mach-bf537/boards/stamp.c:430: error: braced-group
within expression allowed only inside a function
make[1]: *** [arch/blackfin/mach-bf537/boards/stamp.o] Error 1
-mike
