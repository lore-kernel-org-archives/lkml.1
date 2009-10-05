Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZJEQPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZJEQPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZJEQPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:15:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:53193 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751392AbZJEQPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:15:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/f+hRDKXzfUkXetPQ1AFOEKde3RHjsk7dR4YTw9a
	ocA4Ayc8BKW8g6
Date: Mon, 5 Oct 2009 18:14:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
In-Reply-To: <20091005160350.GA13522@kroah.com>
Message-ID: <Pine.LNX.4.64.0910051811210.4337@axis700.grange>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com> <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
 <20091001141524.GA3355@kroah.com> <Pine.LNX.4.64.0910051011280.4337@axis700.grange>
 <20091005160350.GA13522@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Greg KH wrote:

> On Mon, Oct 05, 2009 at 10:11:50AM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 1 Oct 2009, Greg KH wrote:
> > 
> > > On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:
> > > > On Thu, 1 Oct 2009, Greg KH wrote:
> > > > 
> > > > > On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > > > > > Device structures can be reused over multiple device_add / device_release 
> > > > > > cycles.
> > > > > 
> > > > > They shouldn't be as they should be dynamic, not static.
> > > > 
> > > > Should they? I'm pretty sure this is not the first time this comes up - 
> > > > there are several drivers and / or subsystems, that re-use driver objects. 
> > > 
> > > Then those drivers and subsystems should be fixed, as that is incorrect.
> > > 
> > > > But finding in mail archives wouldn't be very easy. And it worked until 
> > > > now - why should we break it?
> > > 
> > > I would argue that this code was always broken.
> > > When did this problem show up for you?
> > 
> > Since commit b4028437876866aba4747a655ede00f892089e14
> 
> Again, which driver/devices are having this problem?

Quoting my previous reply in this thread:

> > What device is having this problem?
> 
> My problem case is the soc-camera framework. There device struct is 
> embedded into the video client object, which are kept as long as the 
> driver is loaded.

</quote>

> The patch
> referenced above had been in linux-next for almost 6 months with no
> reported problems, so this is news to me :)

Hm, really 6 months in linux-next? That surprises me too, that I didn't 
notice it until now. But in any case, the aforementioned commit introduced 
a regression. If you disagree, that it has to be fixed centrally as per 
proposed patch, no problem, I'm pushing a patch tonight, that will fix 
this for soc-camera. No idea about other drivers.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
