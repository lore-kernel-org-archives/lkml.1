Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXBMNVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXBMNVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXBMNVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:21:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:2007 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbXBMNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCWmXej6Kv9u3MsxbZEQQImmwBTozgMK2GU2i2iqGttpQSA6Jr56tdqNHt2IcONcFR4eBlovuM5xkhktF4JO0q2QtMtK4XFyfmvk/uk25snDVKs+54jQXkUtX4wJq0iuyn7AKGKZppILvWhNZBk5m4c7TYLDGyh5w+7bB2pX+cQ=
Message-ID: <1a297b360702130521l4ae0de2byf2c277a505adf273@mail.gmail.com>
Date: Tue, 13 Feb 2007 17:21:37 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] Re: dvb shared datastructure bug?
Cc: "Jakub Jelinek" <jakub@redhat.com>, v4l-dvb-maintainer@linuxtv.org,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0702130506410.29610@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
	 <200702131204.47314.mws@linuxtv.org>
	 <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com>
	 <20070213113552.GL22959@devserv.devel.redhat.com>
	 <Pine.LNX.4.58.0702130506410.29610@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> On Tue, 13 Feb 2007, Jakub Jelinek wrote:
> > Wouldn't it be better to kmalloc both struct dvb_device and
> > struct file_operations together instead of doing 2 separate allocations?
> > struct dvd_device_plus_fops
> > {
> >   struct dvb_device dev;
> >   struct file_operations fops;
> > } *dev_fops = kmalloc (sizeof (struct dvd_device_plus_fops), GFP_KERNEL);
> > *pdvbdev = dvbdev = (struct dvb_device *)dev_fops;
> > if (dev_fops == NULL)
> >   error handling;
> > memset (&dev_fops->fops, 0, sizeof (dev_fops->fops));
> > ...
> > dvbdev->fops = &dev_fops->fops;
>
> Maybe change struct dvb_device:
>
>  struct dvb_device {
>          struct list_head list_head;
> -        struct file_operations *fops;
> +        struct file_operations fops;
>          struct dvb_adapter *adapter;
>

We can of course do that, but if we do that now, i will have to rework
on the changes that which i have, but considering the changes that i
have i wouldn't want to do such a change right now as marcel
explained. But we can surely go in for this, as soon as the rest of
the API changes goes in, ie, multiproto + adaptor changes

manu
