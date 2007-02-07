Return-Path: <linux-kernel-owner+w=401wt.eu-S1422697AbXBGSm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697AbXBGSm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422699AbXBGSmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:42:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53896 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422697AbXBGSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:42:24 -0500
Date: Wed, 7 Feb 2007 18:42:16 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Dave Airlie <airlied@gmail.com>
cc: Greg KH <greg@kroah.com>, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
In-Reply-To: <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702071511520.2158@pentafluge.infradead.org>
References: <1169637623985-git-send-email-airlied@linux.ie> 
 <20070124214654.GA30634@kroah.com> <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Why do we want this?
> > >
> > > Currently the kernel cannot provide both the fb and drm drivers with
> > > access to the device model and this means the drm cannot get any
> > > suspend/resume callbacks.  This layer attempts to fix this problem by
> > > adding a bus for the gpu drivers to attach to. Currently a lowlevel
> > > binding driver is needed along with optional fb and drm components.
> > 
> > If we were to allow this kind of "sharing" for all PCI devices would
> > that work out instead?  Or would this layer still be needed?
> 
> Initially this layer wouldn't be needed, but I'd like to add some
> awareness to the drivers, so the drm can tell the fb to stop doing
> stuff and vice-versa if necessary....  but perhaps that could be done
> with a generic layer also.. or via the lowlevel driver I have...

	I have a idea. Greg asked me to move my display class away from the 
class_device method. One of the nice things about using 
class_device_register is that it handles all the attributes for you :-)
So while going throught the core code for device handling I discovered
that struct device has a struct class. I found it alot easier to have 
class field in the device point to the class you want to use. With 
device registeration the class is setup up for you. 
	The idea was to have the a linked list of classes inside of 
struct device. Then have a way to register/unregister that class with
the device. This way struct device and struct device_driver are per 
hardware but struct class could be used to handle different interfaces
to that same hardware. What do you think? I could do a example with 
hardware that registers a fbdev drivers as well as a backlight. Plus
nobody is using the class field in struct device at this time.
