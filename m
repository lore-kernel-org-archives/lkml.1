Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXEHP5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXEHP5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030354AbXEHP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:57:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33034 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966433AbXEHP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:57:12 -0400
Date: Tue, 8 May 2007 11:57:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Kruchinin <dubalom@gmail.com>
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH -mm] drivers/usb/core/config.c: kzalloc(0,
 ..)
In-Reply-To: <20070508141453.GA12771@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0705081152590.3217-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Greg KH wrote:

> >  The problem was in drivers/usb/core/config.c in function 
> >  usb_parse_interface:
> >  ---
> >  num_ep = num_ep_orig = alt->desc.bNumEndpoints;
> >  ...
> >  len = sizeof(struct usb_host_endpoint) * num_ep;
> >  alt->endpoint = kzalloc(len, GFP_KERNEL);
> >  ---
> > 
> >  num_ep can be 0, as it was in my case, so following patch makes this
> >  situation more obvious
> >  and clear.

How about instead just doing:

+	num_ep = max(num_ep, 1);
 	len = sizeof(struct usb_host_endpoint) * num_ep;

Also, wasn't it true at one point that it was legal to call kmalloc() with 
a length of 0?  ISTR seeing somewhere that it's true for regular malloc().

Alan Stern

