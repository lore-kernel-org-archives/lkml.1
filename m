Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXHADwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXHADwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXHADwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:52:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:15216 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbXHADwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W3XPMheovedYf1myHz7y19Be/LMtLO7U2TW6sG08O0B0WYNYqWQYx4U26oeKIaKmgVsn9/+cyewFU5juacNOybB7xiSqHPbGoZcLHdmrOnEPz3bjy8PtJnTCqG7q2lKMV3r37bn9XM8Bie2HOvwZEqIYzk4/SENpILVsHIUjdEQ=
Message-ID: <1a297b360707312052l14adb72el8ee59c74b7757605@mail.gmail.com>
Date: Wed, 1 Aug 2007 07:52:29 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [2.6 patch] dvb_frontend_ioctl(): fix check-after-use
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070730222817.GE3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070730222817.GE3972@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> The Coverity checker spotted that we have already oops'ed if "fe" was NULL.
>
> Since "fe" being NULL seems impossible at this point this patch removes
> the NULL check.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c.old  2007-07-29 21:41:56.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c      2007-07-29 21:42:16.000000000 +0200
> @@ -706,11 +706,11 @@ static int dvb_frontend_ioctl(struct ino
>         struct dvb_frontend_private *fepriv = fe->frontend_priv;
>         int err = -EOPNOTSUPP;
>
>         dprintk ("%s\n", __FUNCTION__);
>
> -       if (!fe || fepriv->exit)
> +       if (fepriv->exit)
>                 return -ENODEV;
>
>         if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
>             (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
>              cmd == FE_DISEQC_RECV_SLAVE_REPLY))
>
> -

Acked-by: Manu Abraham <manu@linuxtv.org>
