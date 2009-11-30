Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZK3NoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZK3NoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZK3NoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:44:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55191 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZK3Nn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aG5riYUezFBLs8+I6CXE9u1AFfEyrmeuXVM6VjhcucWBoUSMoKGybIhvRYtHKAEYt6
         jNW1yrX2n9R9UxpgyMlrQ7/ASfgHc1g2jM/LO2a7UBGq+tZeSvWV9SudruBJN4Xy04yg
         /yJR4kYzQ2XNwKCg00THCeNkGFlU/LYIkn9j0=
MIME-Version: 1.0
In-Reply-To: <20091130130921.26634.96600.stgit@localhost.localdomain>
References: <20091130130921.26634.96600.stgit@localhost.localdomain>
Date: Mon, 30 Nov 2009 15:44:05 +0200
X-Google-Sender-Auth: 26f9286f73558fe2
Message-ID: <84144f020911300544j30fe1036o797f495a7857831d@mail.gmail.com>
Subject: Re: [PATCH] matroxfb: Fix problems with display stability
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@linux.intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rvm1974@raketnet.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, Nov 30, 2009 at 3:13 PM, Alan Cox <alan@linux.intel.com> wrote:
> Regression caused in 2.6.23 and then despite repeated requests never fixed
> or dealt with (Petr promised to sort it in 2008 but seems to have
> forgotten).
>
> Enough is enough - remove the problem line that was added. If it upsets
> someone they've had two years to deal with it and at the very least it'll
> rattle their cage and wake them up.
>
> Closes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=9709
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Cc: <stable@kernel.org>

We might as well ask for a Tested-by tag from Ruud (whom I've added to
CC) while we're at it.

> ---
>
>  drivers/video/matrox/g450_pll.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/video/matrox/g450_pll.c b/drivers/video/matrox/g450_pll.c
> index 09f6e04..c15f8a5 100644
> --- a/drivers/video/matrox/g450_pll.c
> +++ b/drivers/video/matrox/g450_pll.c
> @@ -368,7 +368,8 @@ static int __g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
>                                        M1064_XDVICLKCTRL_C1DVICLKEN |
>                                        M1064_XDVICLKCTRL_DVILOOPCTL |
>                                        M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
> -                               matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp);
> +                                /* Setting this breaks PC systems so don't do it */
> +                               /* matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp); */
>                                matroxfb_DAC_out(minfo, M1064_XPWRCTRL,
>                                                 xpwrctrl);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
