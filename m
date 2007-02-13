Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXBMNQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXBMNQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXBMNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:16:23 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:42196 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXBMNQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:16:22 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 08:16:22 EST
Date: Tue, 13 Feb 2007 05:09:41 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jakub Jelinek <jakub@redhat.com>
cc: Manu Abraham <abraham.manu@gmail.com>, v4l-dvb-maintainer@linuxtv.org,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [v4l-dvb-maintainer] Re: dvb shared datastructure bug?
In-Reply-To: <20070213113552.GL22959@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.58.0702130506410.29610@shell2.speakeasy.net>
References: <1171352878.12771.30.camel@laptopd505.fenrus.org>
 <200702131204.47314.mws@linuxtv.org> <1a297b360702130314i3b67a828v804ddb85dc975101@mail.gmail.com>
 <20070213113552.GL22959@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Jakub Jelinek wrote:
> Wouldn't it be better to kmalloc both struct dvb_device and
> struct file_operations together instead of doing 2 separate allocations?
> struct dvd_device_plus_fops
> {
>   struct dvb_device dev;
>   struct file_operations fops;
> } *dev_fops = kmalloc (sizeof (struct dvd_device_plus_fops), GFP_KERNEL);
> *pdvbdev = dvbdev = (struct dvb_device *)dev_fops;
> if (dev_fops == NULL)
>   error handling;
> memset (&dev_fops->fops, 0, sizeof (dev_fops->fops));
> ...
> dvbdev->fops = &dev_fops->fops;

Maybe change struct dvb_device:

 struct dvb_device {
         struct list_head list_head;
-        struct file_operations *fops;
+        struct file_operations fops;
         struct dvb_adapter *adapter;


