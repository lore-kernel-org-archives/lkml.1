Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0CGJWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:22:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58920 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0CGJW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aRPOt7GhM3CQdgHa+/d84DHELs1ya3o1e1ORI3hn2huX3oQ2nDAQiipilen8y3Fpa9
         0JYLtHFRoIi5I3jcEFuZB2owS2CsjWDkULObOgSt4/Ja0vVOTKM66GGc5ku0AVlyxO+k
         Jn69dMEVYtPFdy7Tvofl5g2OQ8A4hZB66Kkwc=
MIME-Version: 1.0
In-Reply-To: <20100225144122.d9ba8810.randy.dunlap@oracle.com>
References: <20100225183523.80361261.sfr@canb.auug.org.au>
	 <20100225144122.d9ba8810.randy.dunlap@oracle.com>
Date: Sun, 7 Mar 2010 10:22:27 +0100
X-Google-Sender-Auth: 53e12898a99ad277
Message-ID: <10f740e81003070122y32765942y33c167b5ba4ca8ac@mail.gmail.com>
Subject: Re: [PATCH -next] staging/pohmelfs: fix write_inode parameter warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Evgeniy Polyakov <zbr@ioremap.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 23:41, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> sparse warns that:

Not just sparse, plain gcc as well...

> drivers/staging/pohmelfs/inode.c:1797: warning: initialization from incompatible pointer type
>
> so fix pohmelfs_write_inode() to have the expected parameters.

And now it's in mainline, too...

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/staging/pohmelfs/inode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- linux-next-20100225.orig/drivers/staging/pohmelfs/inode.c
> +++ linux-next-20100225/drivers/staging/pohmelfs/inode.c
> @@ -396,7 +396,8 @@ int pohmelfs_remove_child(struct pohmelf
>  /*
>  * Writeback for given inode.
>  */
> -static int pohmelfs_write_inode(struct inode *inode, int sync)
> +static int pohmelfs_write_inode(struct inode *inode,
> +                               struct writeback_control *wbc)
>  {
>        struct pohmelfs_inode *pi = POHMELFS_I(inode);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
