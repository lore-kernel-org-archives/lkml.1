Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZBIC2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZBIC2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZBIC2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:28:37 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:53922 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZBIC2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K+aXiz/Q2UEClixtVXTSuGfU81MY9L/c/TgtajLjLItfd7BC7lL7241FMYSAKQwetS
         FBDrcp/+A1c9X+z8YNqQV+5y/nB+FJnUJoEWSFb0X6JcZTcZXNf1kUtrWdSL51tM44wt
         MGlA1Nem8VJNcIFjtTF57S8aMzJH8ZqnI6QUA=
MIME-Version: 1.0
In-Reply-To: <498EEB42.1050509@gmail.com>
References: <498EEB42.1050509@gmail.com>
Date: Mon, 9 Feb 2009 12:28:35 +1000
Message-ID: <21d7e9970902081828m709bd839va95b464cd72a4bdb@mail.gmail.com>
Subject: Re: [PATCH] drm: count reaches -1, tested 0
From: Dave Airlie <airlied@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 12:25 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> With a postfix decrement count will reach -1 rather than 0,
> subsequent tests fail.

Thomas can you sign off on this?

Dave.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
> index 7a339db..600315c 100644
> --- a/drivers/gpu/drm/via/via_dma.c
> +++ b/drivers/gpu/drm/via/via_dma.c
> @@ -481,9 +481,9 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
>  {
>        int count = 10000000;
>
> -       while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
> +       while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count);
>
> -       while (count-- && (VIA_READ(VIA_REG_STATUS) &
> +       while (--count && (VIA_READ(VIA_REG_STATUS) &
>                           (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
>                            VIA_3D_ENG_BUSY))) ;
>        return count;
> @@ -705,7 +705,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
>        switch (d_siz->func) {
>        case VIA_CMDBUF_SPACE:
>                while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
> -                      && count--) {
> +                      && --count) {
>                        if (!d_siz->wait) {
>                                break;
>                        }
> @@ -717,7 +717,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
>                break;
>        case VIA_CMDBUF_LAG:
>                while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
> -                      && count--) {
> +                      && --count) {
>                        if (!d_siz->wait) {
>                                break;
>                        }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
