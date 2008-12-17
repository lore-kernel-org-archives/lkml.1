Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757295AbYLQBPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYLQBPy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYLQBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:15:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48191 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYLQBPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:15:42 -0500
Date: Tue, 16 Dec 2008 20:13:34 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Message-ID: <20081217011334.GA5857@localhost.localdomain>
References: <20081210194334.GA25257@hmsreliant.think-freely.org> <200812161042.09345.jbarnes@virtuousgeek.org> <20081216195620.GA10231@hmsreliant.think-freely.org> <200812161252.51191.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161252.51191.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 12:52:50PM -0800, Jesse Barnes wrote:
> On Tuesday, December 16, 2008 11:56 am Neil Horman wrote:
> > On Tue, Dec 16, 2008 at 10:42:08AM -0800, Jesse Barnes wrote:
> > > On Wednesday, December 10, 2008 11:43 am Neil Horman wrote:
> > > > Hey-
> > > > 	I happened to notice that the ibmphp hotplug driver does something
> > > > rather silly in its init routine.  It purposely calls module_put so as
> > > > to underflow its module ref count to avoid being removed from the
> > > > kernel. This is bad practice, and wrong, since it provides a window for
> > > > subsequent module_gets to reset the refcount to zero, allowing an
> > > > unload to race in and cause all sorts of mysterious panics.  If the
> > > > module is unsafe to load, it should inform the kernel as such with a
> > > > call to __unsafe.  The patch below does that.
> > >
> > > Thanks Neil, applied this to my for-linus branch since it sounds
> > > potentially serious (but also low risk since who uses ibmphp anymore? :)
> >
> > Dang it!  Sorry, Jesse.  Yes, youre absolutely right, it is low risk.  It
> > really just a bit of sillyness all around.
> >
> > Unfortunately, I took part in the sillyness.  The problem was reported to
> > me on RHEL, and I tested there, without checking upstream too closely.  As 
> > aresult, the patch I gave you is a bit out of date, and won't compile. 
> > I've tested the new patch here much more closely.  apologies.  I informed
> > akpm who was looking at it, but neglected to copy you.
> >
> > This patch corrects the same problem in that it prevents module unloads in
> > a sane fashion, by not registering an exit routine
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Ah was just doing my testing & building now so I would have caught it in a 
> minute. :)  I'll replace the patch I have with this one, thanks.
> 
> Jesse
> 
Thank you, that matches what Andrew has in his tree.  Apologies for the noise
Neil

