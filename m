Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZJEQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZJEQdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZJEQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:33:34 -0400
Received: from kroah.org ([198.145.64.141]:39844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZJEQde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:33:34 -0400
Date: Mon, 5 Oct 2009 09:30:23 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers-core: nullify private pointer on device-release
Message-ID: <20091005163023.GA31280@kroah.com>
References: <Pine.LNX.4.64.0910010950330.4408@axis700.grange>
 <20091001132709.GA2221@kroah.com>
 <Pine.LNX.4.64.0910011533220.4408@axis700.grange>
 <20091001141524.GA3355@kroah.com>
 <Pine.LNX.4.64.0910051011280.4337@axis700.grange>
 <20091005160350.GA13522@kroah.com>
 <Pine.LNX.4.64.0910051811210.4337@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910051811210.4337@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 06:14:37PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 5 Oct 2009, Greg KH wrote:
> 
> > On Mon, Oct 05, 2009 at 10:11:50AM +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 1 Oct 2009, Greg KH wrote:
> > > 
> > > > On Thu, Oct 01, 2009 at 03:45:56PM +0200, Guennadi Liakhovetski wrote:
> > > > > On Thu, 1 Oct 2009, Greg KH wrote:
> > > > > 
> > > > > > On Thu, Oct 01, 2009 at 10:02:08AM +0200, Guennadi Liakhovetski wrote:
> > > > > > > Device structures can be reused over multiple device_add / device_release 
> > > > > > > cycles.
> > > > > > 
> > > > > > They shouldn't be as they should be dynamic, not static.
> > > > > 
> > > > > Should they? I'm pretty sure this is not the first time this comes up - 
> > > > > there are several drivers and / or subsystems, that re-use driver objects. 
> > > > 
> > > > Then those drivers and subsystems should be fixed, as that is incorrect.
> > > > 
> > > > > But finding in mail archives wouldn't be very easy. And it worked until 
> > > > > now - why should we break it?
> > > > 
> > > > I would argue that this code was always broken.
> > > > When did this problem show up for you?
> > > 
> > > Since commit b4028437876866aba4747a655ede00f892089e14
> > 
> > Again, which driver/devices are having this problem?
> 
> Quoting my previous reply in this thread:
> 
> > > What device is having this problem?
> > 
> > My problem case is the soc-camera framework. There device struct is 
> > embedded into the video client object, which are kept as long as the 
> > driver is loaded.
> 
> </quote>

Ok, then that code needs to be fixed :)

> > The patch
> > referenced above had been in linux-next for almost 6 months with no
> > reported problems, so this is news to me :)
> 
> Hm, really 6 months in linux-next? That surprises me too, that I didn't 
> notice it until now. But in any case, the aforementioned commit introduced 
> a regression. If you disagree, that it has to be fixed centrally as per 
> proposed patch, no problem, I'm pushing a patch tonight, that will fix 
> this for soc-camera. No idea about other drivers.

Great, glad to see this being fixed where it should be.  As no one else
has reported a problem, I'm guessing that this is the only incorrect
code.

thanks,

greg k-h
