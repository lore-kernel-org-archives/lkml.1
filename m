Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZJAOSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZJAOSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZJAOSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:18:30 -0400
Received: from kroah.org ([198.145.64.141]:38499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbZJAOS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:18:29 -0400
Date: Thu, 1 Oct 2009 07:15:24 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
Message-ID: <20091001141524.GA3355@kroah.com>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com>
 <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:
> On Thu, 1 Oct 2009, Greg KH wrote:
> 
> > On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > > Device structures can be reused over multiple device_add / device_release 
> > > cycles.
> > 
> > They shouldn't be as they should be dynamic, not static.
> 
> Should they? I'm pretty sure this is not the first time this comes up - 
> there are several drivers and / or subsystems, that re-use driver objects. 

Then those drivers and subsystems should be fixed, as that is incorrect.

> But finding in mail archives wouldn't be very easy. And it worked until 
> now - why should we break it?

I would argue that this code was always broken.
When did this problem show up for you?

> > What device is having this problem?
> 
> My problem case is the soc-camera framework. There device struct is 
> embedded into the video client object, which are kept as long as the 
> driver is loaded.

struct device is a dynamic structure, it is supposed to be able to be
freed when the last reference goes away.  Static struct device usage is
wrong.  It sounds like the video client object code is incorrect, please
fix it.

thanks,

greg k-h
