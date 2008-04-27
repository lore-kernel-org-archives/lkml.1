Return-Path: <linux-kernel-owner+w=401wt.eu-S1763638AbYD0Tsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638AbYD0Tsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbYD0Tsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:48:37 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:12619 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYD0Tsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UB9A8XCAg2s/x2A35yDoK1Og4o33l0TlKNDvs+Io5onFS5t8GIKzcgVuNL8UsV0QXajoXOAzAOoCNUPDjoNwzMZ2PLQQG5YnaFG9jnKdnUAj3bonizHI0bUr2+F9KyCOkHHjvm3MRONU+YE7ySXEDZhORtrmID3jophjfz2ZT+8=
Message-ID: <43e72e890804271248i1fbeb16ev7b05149a8d9adaf1@mail.gmail.com>
Date: Sun, 27 Apr 2008 12:48:34 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Roger While" <simrw@sim-basis.de>
Subject: Re: [PATCH v2] prism54: prism54_get_encode() test below 0 on unsigned index
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6.1.1.1.2.20080427141058.045c43f0@192.168.6.12>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6.1.1.1.2.20080427141058.045c43f0@192.168.6.12>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 5:25 AM, Roger While <simrw@sim-basis.de> wrote:
> Luis Rodriguez wrote :
>
>
>
> > The check for -1 seems silly lets just remove its use.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >
> > diff --git a/drivers/net/wireless/prism54/isl_ioctl.c
> b/drivers/net/wireless/prism54/isl_ioctl.c
> > index 5b375b2..7e2d3b6 100644
> > --- a/drivers/net/wireless/prism54/isl_ioctl.c
> > +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> > @@ -1158,7 +1158,7 @@ prism54_get_encode(struct net_device *ndev, struct
> iw_request_info *info,
> >  {
> >        islpci_private *priv = netdev_priv(ndev);
> >        struct obj_key *key;
> > -       u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> > +       u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX);
> >        u32 authen = 0, invoke = 0, exunencrypt = 0;
> >        int rvalue;
> >        union oid_res_t r;
> > @@ -1186,7 +1186,7 @@ prism54_get_encode(struct net_device *ndev, struct
> iw_request_info *info,
> >        rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
> >        devindex = r.u;
> >        /* Now get the key, return it */
> > -       if (index == -1 || index > 3)
> > +       if (!index || index > 3)
> >                /* no index provided, use the current one */
> >                index = devindex;
> >        rvalue |= mgt_get_request(priv, DOT11_OID_DEFKEYX, index, NULL,
> &r);
> >
>
>  This does not look right to me. Should this not be -
>   if (!index || index > 4)
>    ....
>   else
>   index -= 1;
>  (Or alternatively pass index -1 to mgt_get_request)
>
>  Also 5 lines further on we have -
>         /* return the used key index */
>         dwrq->flags |= devindex + 1;
>  which looks suspect.

Yeah and you're patch already went in. Its OK, was just not likin the -1 stuff.

  Luis
