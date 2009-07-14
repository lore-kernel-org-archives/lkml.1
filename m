Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZGNS3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZGNS3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZGNS3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:29:23 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:62244 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZGNS3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ek1JkPy0pGm/V5Lj07nEkpktYsLFtXMrpPS0NrU6dxJn10epNOXR5luDJDc5i0Gmrv
         uEqh/2ySjmgkPNmg11GFgBlVoGR1GoeS0sp2x/coICNY+z+MCvwaj/7at/3CmygUH8tK
         ZpJwOpOtBaZKPrEn0ygc1RMYZH736At0QPBkk=
MIME-Version: 1.0
In-Reply-To: <1247492991-26009-2-git-send-email-adkulkar@umail.iu.edu>
References: <1247492991-26009-1-git-send-email-adkulkar@umail.iu.edu>
	 <1247492991-26009-2-git-send-email-adkulkar@umail.iu.edu>
Date: Tue, 14 Jul 2009 13:29:19 -0500
Message-ID: <a4e6962a0907141129w23654edbp1ea309b19bf0b546@mail.gmail.com>
Subject: Re: [PATCH] [net/9p]: default 9p transport module fix
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied v9fs-devel

On Mon, Jul 13, 2009 at 8:49 AM, Abhishek Kulkarni<adkulkar@umail.iu.edu> wrote:
> The default 9p transport module is not chosen unless an option parameter (any)
> is passed to mount, which thus returns a ENOPROTOSUPPORT. This fix moves the
> check out of parse_opts into p9_client_create.
>
> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
> ---
> :100644 100644 cc25e63... 787ccdd... M  net/9p/client.c
>  net/9p/client.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index cc25e63..787ccdd 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -117,9 +117,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
>                }
>        }
>
> -       if (!clnt->trans_mod)
> -               clnt->trans_mod = v9fs_get_default_trans();
> -
>        kfree(options);
>        return ret;
>  }
> @@ -689,6 +686,9 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
>        if (err < 0)
>                goto error;
>
> +       if (!clnt->trans_mod)
> +               clnt->trans_mod = v9fs_get_default_trans();
> +
>        if (clnt->trans_mod == NULL) {
>                err = -EPROTONOSUPPORT;
>                P9_DPRINTK(P9_DEBUG_ERROR,
> --
> 1.6.0.4
>
>
