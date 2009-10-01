Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZJANpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZJANpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZJANpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:45:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:56180 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755962AbZJANpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:45:54 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Kxxlc+moKp6xLyO3VJZB+Q4FIIXih7hUA0501xw
	wuixJ2N2lEXBjw
Date: Thu, 1 Oct 2009 15:45:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
In-Reply-To: <20091001132709.GA2221@kroah.com>
Message-ID: <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Greg KH wrote:

> On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > Device structures can be reused over multiple device_add / device_release 
> > cycles.
> 
> They shouldn't be as they should be dynamic, not static.

Should they? I'm pretty sure this is not the first time this comes up - 
there are several drivers and / or subsystems, that re-use driver objects. 
But finding in mail archives wouldn't be very easy. And it worked until 
now - why should we break it?

> What device is having this problem?

My problem case is the soc-camera framework. There device struct is 
embedded into the video client object, which are kept as long as the 
driver is loaded.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
