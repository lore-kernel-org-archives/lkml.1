Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbZAMXty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbZAMXty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZAMXtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:49:43 -0500
Received: from kroah.org ([198.145.64.141]:60823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753919AbZAMXtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:49:42 -0500
Date: Tue, 13 Jan 2009 15:46:33 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?B?SmlfX+0=?= Burda <jburda@email.cz>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Nokia 5310 mass-storage not mounting in kernel
	2.6.28
Message-ID: <20090113234633.GA28105@kroah.com>
References: <496CD114.7060802@email.cz> <20090113153704.2ca5174d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113153704.2ca5174d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:37:04PM -0800, Andrew Morton wrote:
> On Tue, 13 Jan 2009 18:36:20 +0100
> Ji____ Burda <jburda@email.cz> wrote:
> 
> > From: Jiri Burda <jburda@email.cz>	
> > 
> > Nokia 5310 mobile with firmware revision 8.32 does not mount as usb mass-storage in kernel 2.6.28 and previous.
> > This patch solves this problem by increasing firmware revision in drivers/usb/storage/unusual_device.h from 0x0701 to 0x0832.
> > This bug is recorded in kernel bugzilla as 12367.
> > Signed-off-by: Jiri Burda <jburda@email.cz>
> > ---
> > --- linux-2.6.28/drivers/usb/storage/unusual_devs.h.orig	2009-01-13 17:21:24.000000000 +0100
> > +++ linux-2.6.28/drivers/usb/storage/unusual_devs.h	2009-01-13 19:24:16.000000000 +0100
> > @@ -182,7 +182,7 @@ UNUSUAL_DEV(  0x0421, 0x0063, 0x0001, 0x
> >  		US_FL_FIX_CAPACITY ),
> >  
> >  /* Patch for Nokia 5310 capacity */
> > -UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0701,
> > +UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0832,
> >  		"Nokia",
> >  		"5310",
> >  		US_SC_DEVICE, US_PR_DEVICE, NULL,
> > 
> 
> akpm:/usr/src/25> grep 5310 drivers/usb/storage/unusual_devs.h
> akpm:/usr/src/25> 
> 
> The 5310 entry seems to have been removed in 2.6.29-rc1.

Yes, we are handling all Nokia devices in a generic way now in 2.6.29,
so patches like this should no longer be needed.

thanks,

greg k-h
