Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbXBMNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbXBMNVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXBMNVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:21:22 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:51412 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXBMNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:21:21 -0500
From: Marcel Siegert <mws@linuxtv.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] Re: dvb shared datastructure bug?
Date: Tue, 13 Feb 2007 14:21:05 +0100
User-Agent: KMail/1.9.6
Cc: Jakub Jelinek <jakub@redhat.com>, Manu Abraham <abraham.manu@gmail.com>,
       v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <1171352878.12771.30.camel@laptopd505.fenrus.org> <20070213113552.GL22959@devserv.devel.redhat.com> <Pine.LNX.4.58.0702130506410.29610@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0702130506410.29610@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131421.07147.mws@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007, Trent Piepho wrote:
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
> 
hi trent, 

your suggestion is correct and useful, 
but this would mean a lot of more work to do, 
and maybe creates new issues.

we should get a working - non issued - v4l-dvb tree and
afterwards start to review, optimize things.

can we put that on wait for the future?

regards 
marcel
