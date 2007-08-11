Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbXHKLON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbXHKLON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 07:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXHKLOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 07:14:01 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:46688 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXHKLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 07:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fGpfP4SoeSKXnmrUx3Woe67PKDv7CZNrK0cUk9+X7hV0xXM/uur8dvW2fsRKpyC71E973xw7mCLVqMnSW/hq2G6VtwtRSWG68jyQGX/LDgEMYdXTRFT4bfPmvt6hkYSl/yPi7Uaz8wnoXXdGtzZAVsf8Cz0aMD17pVAiPyZhy3g=
Message-ID: <d9def9db0708110413w10f49769kad3f46331b5919d4@mail.gmail.com>
Date: Sat, 11 Aug 2007 13:13:59 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] dvb_frontend_ioctl(): fix check-after-use
Cc: "Manu Abraham" <abraham.manu@gmail.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <Pine.LNX.4.58.0708101546170.26791@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070730222817.GE3972@stusta.de>
	 <1a297b360707312052l14adb72el8ee59c74b7757605@mail.gmail.com>
	 <d9def9db0708101047u27c939a4ve57b28cf4319aaf2@mail.gmail.com>
	 <Pine.LNX.4.58.0708101546170.26791@shell4.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> On Fri, 10 Aug 2007, Markus Rechberger wrote:
> > On 8/1/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > > On 7/31/07, Adrian Bunk <bunk@stusta.de> wrote:
> > > > The Coverity checker spotted that we have already oops'ed if "fe" was
> > > NULL.
> > > >
> > > > --- linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c.old
> > > > +++ linux-2.6.23-rc1-mm1/drivers/media/dvb/dvb-core/dvb_frontend.c
> > > > @@ -706,11 +706,11 @@ static int dvb_frontend_ioctl(struct ino
> > > > -       if (!fe || fepriv->exit)
> > > > +       if (fepriv->exit)
> > > >                 return -ENODEV;
> >
> > This issue has been known for a while including some other problems at
> > that part.
> >
> >
> http://article.gmane.org/gmane.linux.drivers.dvb/35351/match=patch+dvb_net+hotplugging+support
> >
> > this includes a link where this and more got discussed in May.
>
> For dvb_net_close, I like the patch I already posted better.  To fix the
> check-after-use, it's not "use" part that's the problem, it's the "check"
> part
> that isn't necessary.
>
> I traced the dvb-net code,
> http://article.gmane.org/gmane.linux.kernel/543689,
> and I'm sure that dvbdev can't be NULL.
>
> My patch also deletes a few pieces of duplicated code by calling
> dvb_generic_release().
>
> The only problem is that practically no one uses dvb-net, so it's very hard
> to
> test these patches.
>

I didn't see this patch, it would be fine if it would get applied.

> In all the dvb code, were is the locking for device open and release?  I
> don't
> see it.  What is preventing two threads from trying to open and/or close the
> same dvb device at the same time?
>

Haven't looked at that yet, since I moreover work to get the em28xx
driver included now.

Markus
