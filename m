Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYANBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYANBgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYANBgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:36:09 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:18618 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbYANBgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lhCzPZvCVmV/ECiZjaUJQWVuuMgxz3JY0NERwf8sBHWbAXlN2RbS7ThJSuRKW7MR/xj7BHQNb4F6wubf00Uw49ZbRlBaJFL9yi2GY+yZiLCRToPdx9ld4m+ZHjaSPhGVyKIUSopK6jp1pgQi1CPHvnIBOmfyapR2r+bDpp984oE=
Message-ID: <a8e1da0801131736i4fa2eed7pd1569ed1b6214510@mail.gmail.com>
Date: Mon, 14 Jan 2008 09:36:04 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net
In-Reply-To: <20080112201111.GA8129@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080112201111.GA8129@ami.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13, 2008 4:11 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
>
> On Sat, Jan 12, 2008 at 05:47:54PM +0800, Dave Young wrote:
> > Add the following class iteration functions for driver use:
> > class_for_each_device
> > class_find_device
> > class_for_each_child
> > class_find_child
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > ---
> >  drivers/base/class.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/device.h |    8 ++
> >  2 files changed, 167 insertions(+)
> >
> > diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
> > --- linux/drivers/base/class.c        2008-01-12 14:42:24.000000000 +0800
> > +++ linux.new/drivers/base/class.c    2008-01-12 14:42:24.000000000 +0800
> > @@ -798,6 +798,165 @@ void class_device_put(struct class_devic
> >               kobject_put(&class_dev->kobj);
> >  }
> >
> > +/**
> > + *   class_for_each_device - device iterator
> > + *   @class: the class we're iterating
> > + *   @data: data for the callback
> > + *   @fn: function to be called for each device
> > + *
> > + *   Iterate over @class's list of devices, and call @fn for each,
> > + *   passing it @data.
> > + *
> > + *   We check the return of @fn each time. If it returns anything
> > + *   other than 0, we break out and return that value.
> > + */
> > +int class_for_each_device(struct class *class, void *data,
> > +                        int (*fn)(struct device *, void *))
> > +{
> > +     struct device *dev;
> > +     int error = 0;
> > +
> > +     if (!class)
> > +             return -EINVAL;
> > +     down(&class->sem);
> > +     list_for_each_entry(dev, &class->devices, node) {
>
> Probably some tiny oversight, but I see this comment to struct class
> doesn't mention devices list, so maybe this needs to be updated BTW?:
>
> (from include/linux/device.h)
> "        struct semaphore        sem;    /* locks both the children and interfaces lists */"

Sorry for my lazy, I think so too.
IMHO, it should be updated after the comments.

>
> Regards,
> Jarek P.
>
