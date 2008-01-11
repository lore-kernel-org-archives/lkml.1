Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbYAKIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbYAKIxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYAKIxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:53:38 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:46977 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755318AbYAKIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fb284PtejGPpplm2u4d5eJOuTpnB56jMBn3JA2HVYJmhvh/Ieh5Xx/Tunhzb+6kD0w5j1AsvQE9TOrPwWIIU8SFj2CLNNuLWsC5IMgt1s8jaU04FyZRBFFFtB9Cr7GRrkKn4qyiXX2f9meR2WyxsdjAQHPxSFTjfPYtMvF1qjok=
Message-ID: <a8e1da0801110053j70a1b117n46983d8c0b073fde@mail.gmail.com>
Date: Fri, 11 Jan 2008 16:53:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Greg KH" <gregkh@suse.de>, "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <20080111092359.7443af68@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478227D5.8050402@s5r6.in-berlin.de>
	 <20080108224837.GA19623@suse.de>
	 <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	 <20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	 <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	 <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	 <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	 <20080110142341.71af4dc5@gondolin.boeblingen.de.ibm.com>
	 <a8e1da0801101833j6fd3bb56p6998e6e326858724@mail.gmail.com>
	 <20080111092359.7443af68@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 4:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Fri, 11 Jan 2008 10:33:16 +0800,
> "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
>
> > > > +struct device *class_find_device(struct class *class, void *data,
> > > > +                                int (*match)(struct device *, void *))
> > > > +{
> > > > +     struct device *dev;
> > > > +
> > > > +     if (!class)
> > > > +             return NULL;
> > > > +
> > > > +     mutex_lock(&class->mutex);
> > > > +     list_for_each_entry(dev, &class->devices, node)
> > > > +             if (match(dev, data) && get_device(dev))
> > >
> > > First get the reference and then drop it if the match function returns
> > > 0 to make this analogous to the other _find_device() functions?
> >
> > It's just like other _find_device() functions. Are these more get/put
> > really needed?
>
> The other _find_device() functions operate on klists, which means that
> there is an implicit get while the element is handled. This function
> operates on a normal list, which means that getting/putting the
> reference looks a bit different if we want the same effect.
>

Hi, you are right. Will be fixed.

Thanks.
