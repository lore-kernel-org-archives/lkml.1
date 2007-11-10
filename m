Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbXKJRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbXKJRIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 12:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXKJRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 12:08:25 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49545 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbXKJRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 12:08:24 -0500
Date: Sat, 10 Nov 2007 20:08:32 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eric miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       szabolcs.gyurko@tlt.hu
Subject: Re: [PATCH] make ds1wm driver to check ds1wm_platform_data pointer against NULL
Message-ID: <20071110170831.GA15564@2ka.mipt.ru>
References: <f17812d70711082207p455c5bc9v25fea9a0585ba152@mail.gmail.com> <20071109170238.628fdf0d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109170238.628fdf0d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 05:02:38PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > @@ -351,6 +351,10 @@ static int ds1wm_probe(struct platform_device *pdev)
> >  		goto err0;
> >  	}
> >  	plat = pdev->dev.platform_data;
> > +	if (!plat) {
> > +		ret = -ENXIO;
> > +		goto err0;
> > +	}
> >  	ds1wm_data->bus_shift = plat->bus_shift;
> >  	ds1wm_data->pdev = pdev;
> >  	ds1wm_data->pdata = plat;
> 
> I don't understand this change.  Could you please provide some more details
> regarding what problem it is solving?  How can pdev->dev.platform_data==NULL
> come about?

If I understood correctly, it is posible to call platform's probe
callback without previously calling platform_device_add_data() to setup
platform_data.

But actually I failed to find any user of this platform driver in
vanilla kernel, so it is hard to say if driver is used properly or not
by external modules, and thus this change is very likely valid.

-- 
	Evgeniy Polyakov
