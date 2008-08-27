Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYH0Sgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYH0Sgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYH0Sgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:36:37 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35789 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYH0Sgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:36:36 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Wed, 27 Aug 2008 20:37:48 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0808271423030.17568-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808271423030.17568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808272037.49258.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 20:28:22 schrieb Alan Stern:
> On Wed, 27 Aug 2008, Greg KH wrote:
> 
> > Here's an updated version of the usbtmc driver, with all of the
> > different issues that have been raised, hopefully addressed.
> 
> This is an example of what I was discussing with Oliver.  In all 
> likelihood you simply don't need usbtmc_mutex, and using it will cause 
> a lockdep violation.
> 
> That's why so many of the other USB class drivers don't have an 
> analogous static mutex.
> 
> > +static int usbtmc_open(struct inode *inode, struct file *filp)
> > +{
> > +     struct usb_interface *intf;
> > +     struct usbtmc_device_data *data;
> > +     int retval = -ENODEV;
> > +
> > +     mutex_lock(&usbtmc_mutex);
> 
> You must never acquire a lock in your open method if it will be held
> by your disconnect method while unregistering the minor.

And this rule depends on sharing the USB major or not. This needs
a big fat mention in Documentation.

	Regards
		Oliver

