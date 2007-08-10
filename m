Return-Path: <linux-kernel-owner+w=401wt.eu-S938839AbXHJRsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938839AbXHJRsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXHJRry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:47:54 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:22691 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXHJRrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S92toFE0Q0JOJQbRdnF4UQriKBmpXr/y5T9Yg2WjUil6G04pq0bKjKAAY47uJvrdktqq+CJgZkn7pzTwjm0zURhYq1niSpSVw6tYk1a6oeePHiX8zvBksPsf5HiGBmiu6+VVJYuTg9viYTn21fTu7K6j9ndHKlR/h2585I+dvAc=
Message-ID: <d9def9db0708101047u27c939a4ve57b28cf4319aaf2@mail.gmail.com>
Date: Fri, 10 Aug 2007 19:47:52 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb_frontend_ioctl(): fix check-after-use
Cc: "Adrian Bunk" <bunk@stusta.de>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1a297b360707312052l14adb72el8ee59c74b7757605@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070730222817.GE3972@stusta.de>
	 <1a297b360707312052l14adb72el8ee59c74b7757605@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 7/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> > The Coverity checker spotted that we have already oops'ed if "fe" was
> NULL.
> >
> > Since "fe" being NULL seems impossible at this point this patch removes
> > the NULL check.
> >
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> >
> > ---
> > --- linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c.old
> 2007-07-29 21:41:56.000000000 +0200
> > +++ linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c
> 2007-07-29 21:42:16.000000000 +0200
> > @@ -706,11 +706,11 @@ static int dvb_frontend_ioctl(struct ino
> >         struct dvb_frontend_private *fepriv = fe->frontend_priv;
> >         int err = -EOPNOTSUPP;
> >
> >         dprintk ("%s\n", __FUNCTION__);
> >
> > -       if (!fe || fepriv->exit)
> > +       if (fepriv->exit)
> >                 return -ENODEV;
> >
> >         if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
> >             (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
> >              cmd == FE_DISEQC_RECV_SLAVE_REPLY))
> >
> > -
>
> Acked-by: Manu Abraham <manu@linuxtv.org>
>

This issue has been known for a while including some other problems at
that part.

http://article.gmane.org/gmane.linux.drivers.dvb/35351/match=patch+dvb_net+hotplugging+support

this includes a link where this and more got discussed in May.

Markus
