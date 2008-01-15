Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYAOARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYAOARS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYAOARG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:17:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:26729 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYAOARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CZl4f0Ipsrm3vlMyzgxdzwLyIN8D+HT9PTV6/YTVSq320xeWc8A2o766rV6qUJpdAHlDbNJdC9f6R3L59FO1xtiQ61A9iS222F/VKmon4URyP87fstoCzY5/8RA32BENjtHMPOhru4nVF40QBunaFtXNP3Bji+zDdv6FITR8sps=
Message-ID: <a8e1da0801141617x6d49a144r441404dfe06d5b35@mail.gmail.com>
Date: Tue, 15 Jan 2008 08:17:04 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com
In-Reply-To: <20080114131347.6ddd036a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080114131347.6ddd036a@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 8:13 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Sat, 12 Jan 2008 17:47:54 +0800,
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
> Minor style suggestion (same for class_find_child):
>
> > +struct device *class_find_device(struct class *class, void *data,
> > +                                int (*match)(struct device *, void *))
> > +{
> > +     struct device *dev;
> > +     int error = 1;
>
> How about using inverse logic here (e.g., start with int found = 0)...

Sounds good, will do. Thanks.

>
> > +
> > +     if (!class)
> > +             return NULL;
> > +
> > +     down(&class->sem);
> > +     list_for_each_entry(dev, &class->devices, node) {
> > +             dev = get_device(dev);
> > +             if (dev) {
> > +                     if (match(dev, data)) {
> > +                             error = 0;
>
> ...and set found = 1 here...
>
> > +                             break;
> > +                     } else
> > +                             put_device(dev);
> > +             } else
> > +                     break;
> > +     }
> > +     up(&class->sem);
> > +
> > +     if (error)
> > +             return NULL;
> > +     return dev;
>
> ...and do
>         return found ? dev : NULL;
> in the end?
>
> Especially since not finding the device is not really an error.
>
> > +}
>
> Otherwise this looks fine to me.
>
