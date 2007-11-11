Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXKKC0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXKKC0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 21:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXKKC0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 21:26:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:18667 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXKKC0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 21:26:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TT9+QbugtpVdy6wHcQMM1M3s78Gxirn9hZYWrv5oRd5g0/DISonSmVhZGx8+hGGUd5k58i1Nmaq8/EeS1GLimElmaLX/eaK6vSHu33N1LL01JnArerlfCziFIYmD0xC7/G29UQpXI+B2wyiOHH7IzEZRb5fxJBA/7lq8O2Kgox0=
Message-ID: <f17812d70711101826y24af0f6cg11a8850df20dd9eb@mail.gmail.com>
Date: Sun, 11 Nov 2007 10:26:12 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] make ds1wm driver to check ds1wm_platform_data pointer against NULL
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       szabolcs.gyurko@tlt.hu
In-Reply-To: <20071110170831.GA15564@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70711082207p455c5bc9v25fea9a0585ba152@mail.gmail.com>
	 <20071109170238.628fdf0d.akpm@linux-foundation.org>
	 <20071110170831.GA15564@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 11, 2007 1:08 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Fri, Nov 09, 2007 at 05:02:38PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > > @@ -351,6 +351,10 @@ static int ds1wm_probe(struct platform_device *pdev)
> > >             goto err0;
> > >     }
> > >     plat = pdev->dev.platform_data;
> > > +   if (!plat) {
> > > +           ret = -ENXIO;
> > > +           goto err0;
> > > +   }
> > >     ds1wm_data->bus_shift = plat->bus_shift;
> > >     ds1wm_data->pdev = pdev;
> > >     ds1wm_data->pdata = plat;
> >
> > I don't understand this change.  Could you please provide some more details
> > regarding what problem it is solving?  How can pdev->dev.platform_data==NULL
> > come about?
>
> If I understood correctly, it is posible to call platform's probe
> callback without previously calling platform_device_add_data() to setup
> platform_data.
>
> But actually I failed to find any user of this platform driver in
> vanilla kernel, so it is hard to say if driver is used properly or not
> by external modules, and thus this change is very likely valid.
>
> --
>         Evgeniy Polyakov
>

Yes, that's exactly what this patch meant to prevent. That no use of
this platform driver in vanilla kernel doesn't mean the check is
unnecessary. Actually, from the code of this driver, the platform_data
is mandatory for the driver to work properly.  Well, if an oops is
on purpose when platform_data == NULL, this is, I agree, completely
unnecessary.

-- 
Cheers
- eric
