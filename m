Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZJEIMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZJEIMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbZJEIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:12:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:48532 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758550AbZJEIMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:12:32 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19iaWtXaspiQYluwWbHf6dzADEB0PJ8j+9bl6pfD+
	C3h3vF54luoObi
Date: Mon, 5 Oct 2009 10:11:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
In-Reply-To: <20091001141524.GA3355@kroah.com>
Message-ID: <Pine.LNX.4.64.0910051011280.4337@axis700.grange>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com> <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
 <20091001141524.GA3355@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Greg KH wrote:

> On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 1 Oct 2009, Greg KH wrote:
> > 
> > > On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > > > Device structures can be reused over multiple device_add / device_release 
> > > > cycles.
> > > 
> > > They shouldn't be as they should be dynamic, not static.
> > 
> > Should they? I'm pretty sure this is not the first time this comes up - 
> > there are several drivers and / or subsystems, that re-use driver objects. 
> 
> Then those drivers and subsystems should be fixed, as that is incorrect.
> 
> > But finding in mail archives wouldn't be very easy. And it worked until 
> > now - why should we break it?
> 
> I would argue that this code was always broken.
> When did this problem show up for you?

Since commit b4028437876866aba4747a655ede00f892089e14

> > > What device is having this problem?
> > 
> > My problem case is the soc-camera framework. There device struct is 
> > embedded into the video client object, which are kept as long as the 
> > driver is loaded.
> 
> struct device is a dynamic structure, it is supposed to be able to be
> freed when the last reference goes away.  Static struct device usage is
> wrong.  It sounds like the video client object code is incorrect, please
> fix it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
