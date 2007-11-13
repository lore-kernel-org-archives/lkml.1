Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXKMXQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXKMXQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXKMXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:16:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:52227 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507AbXKMXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=Tpky/7GG27HmH6sO+8pvdcAlrtsGa7SzOAgy+sHDOoQDRz+QIbYKnradRBLOsTVDpdKAQCH3GrEwxvEgsTjP7wUef/OZrMxTasJcmYxTyNfVd6q/h90f5eSfkYXujgyaHTBrBJOPkz0OiiRpv+y5BDtW0fHbrEpmSQ+QkEhJaBM=
Date: Wed, 14 Nov 2007 00:21:02 +0100
To: "dave chung" <ponstrip@gmail.com>
Cc: "Stanislav Brabec" <utx@penguin.cz>, linux-kernel@vger.kernel.org,
       "Thibaut VARENE" <varenet@parisc-linux.org>
Subject: Re: [PATCH] drivers/video/s1d13xxxfb.c as module with dbg
Message-Id: <20071114002102.5e829113.Kristoffer.ericson@gmail.com>
In-Reply-To: <d7b238da0711101529s3384cb6bx928c74cfef8fde0f@mail.gmail.com>
References: <1194709875.4486.8.camel@utx.utx.cz>
	<d7b238da0711101529s3384cb6bx928c74cfef8fde0f@mail.gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 07:29:35 +0800
"dave chung" <ponstrip@gmail.com> wrote:

> On 11/10/07, Stanislav Brabec <utx@penguin.cz> wrote:
> > Attached patch fixes two compilation problems of s1d13xxxfb.c:
> > - Fixes outdated dbg() message to fix compilation error with debugging enabled.
> > - Do not read kernel command line options when compiled as module.
> >
> > Signed-off-by: Stanislav Brabec <utx@penguin.cz>
> >
> > --- linux-2.6.23/drivers/video/s1d13xxxfb.c     2007-10-09 22:31:38.000000000 +0200
> > +++ linux-2.6.23/drivers/video/s1d13xxxfb.c     2007-11-02 16:48:34.000000000 +0100
> > @@ -540,7 +540,7 @@
> >         int ret = 0;
> >         u8 revision;
> >
> > -       dbg("probe called: device is %p\n", dev);
> > +       dbg("probe called: device is %p\n", pdev);
> >
> >         printk(KERN_INFO "Epson S1D13XXX FB Driver\n");
> >
> > @@ -753,8 +753,11 @@
> >  static int __init
> >  s1d13xxxfb_init(void)
> >  {
> > +
> > +#ifndef MODULE
> >         if (fb_get_options("s1d13xxxfb", NULL))
> >                 return -ENODEV;
> > +#endif
> >
> >         return platform_driver_register(&s1d13xxxfb_driver);
> >  }
> >
> >
> >________________________________________________________________________
> > Stanislav Brabec
> > http://www.penguin.cz/~utx
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> we also need to look at splitting out the "chip revision", which is
> currently hard set, as I have had very good results with this driver
> and  chip  S1D13506, which is functionally similar but without the
> external clocking and without teh internal ram.
>  We also have some build dependancies related to  "CONFIG_FB_S1D13XXX"
> and  ics1523 , this chip is not used on the full range of S1D13XXX and
> causes errors in the build , for chips such as S1D13506.
> potentially we could re-use most of the code, but would need a way to
> pass in S1D_CHIP_REV and one or 2 other chip specific data items.

Im all for that. Got 2 platforms (Mobilepro 900c & HP Jornada 720) with both uses S1D13... based chipsets. The driver should
make more room for similiar versions.

> 
> Steve
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
