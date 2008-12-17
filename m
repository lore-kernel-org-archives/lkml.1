Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752547AbYLQTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYLQTjU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYLQTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:39:05 -0500
Received: from kroah.org ([198.145.64.141]:52731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751199AbYLQTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:39:04 -0500
Date: Wed, 17 Dec 2008 11:35:25 -0800
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        v4l <video4linux-list@redhat.com>
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081217193525.GA24916@kroah.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <200812171437.33695.hverkuil@xs4all.nl> <20081217181645.GA26161@kroah.com> <200812172027.13771.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812172027.13771.laurent.pinchart@skynet.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 08:27:13PM +0100, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Wednesday 17 December 2008, Greg KH wrote:
> > On Wed, Dec 17, 2008 at 02:37:33PM +0100, Hans Verkuil wrote:
> > > > Again, don't use cdev's reference counting for your own object
> > > > lifecycle, it is different and will cause problems, like you have found
> > > > out.
> > >
> > > Sigh. It has nothing to do with how v4l uses it. And to demonstrate this,
> > > here is how you reproduce it with the sg module (tested it with my USB
> > > harddisk).
> > >
> > > 1) apply this patch to char_dev.c:
> >
> > <snip>
> >
> > Ok, since I can't convince you that using a cdev for your reference
> > counting is incorrect, I'll have to go change the cdev code to prevent
> > you from doing this :(
> 
> Don't give up yet :-)
> 
> As v4l isn't the only kernel subsystem wrongly using cdev (Hans showed that sg 
> also suffered from race conditions), people seem not to understand cdev 
> properly.

I totally agree, it is not the most easily understood chunk of code.

> Maybe you should start by explaining what cdev has been designed to
> handle and how to use it in device drivers (such as sg or v4l) instead
> of telling us what not to do.

As I didn't create this code, but for some reason seem to maintain it,
I'll work on creating a document to do this.  But as the holidays are
rapidly approaching, it might be a while before I can get to it.

thanks,

greg k-h
