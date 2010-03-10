Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0CJD2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:28:50 -0500
Received: from kroah.org ([198.145.64.141]:59765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0CJD2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:28:47 -0500
Date: Tue, 9 Mar 2010 19:28:46 -0800
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] driver core: Early dev_name() support.
Message-ID: <20100310032846.GC28444@kroah.com>
References: <20100309065753.GA8287@linux-sh.org> <20100310023727.GB26642@kroah.com> <20100310032158.GA19518@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310032158.GA19518@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 12:21:58PM +0900, Paul Mundt wrote:
> On Tue, Mar 09, 2010 at 06:37:27PM -0800, Greg KH wrote:
> > On Tue, Mar 09, 2010 at 03:57:53PM +0900, Paul Mundt wrote:
> > > Presently early platform devices suffer from the fact they are unable to
> > > use dev_xxx() calls early on due to dev_name() and others being
> > > unavailable at the time ->probe() is called.
> > > 
> > > This implements early init_name construction from the matched name/id
> > > pair following the semantics of the late device/driver match. As a
> > > result, matched IDs (inclusive of requested ones) are preserved when the
> > > handoff from the early platform code happens at kobject initialization
> > > time.
> > > 
> > > Since we still require kmalloc slabs to be available at this point, using
> > > kstrdup() for establishing the init_name works fine. This subsequently
> > > needs to be tested from dev_name() prior to the init_name being cleared
> > > by the driver core. We don't kfree() since others will already have a
> > > handle on the string long before the kobject initialization takes place.
> > > 
> > > This is also needed to permit drivers to use the clock framework early,
> > > without having to manually construct their own device IDs from the match
> > > id/name pair locally (needed by the early console and timer code on sh
> > > and arm).
> > 
> > Is this change something that we need for .34?  Or can it wait for .35?
> > 
> If it went in for .34 we would get properly dev_name() resolution in the
> error paths for the existing early platform drivers, but that's obviously
> not critical.
> 
> I have a bunch of work I plan to do on top of it for 2.6.35, so I was
> planning on carrying it in a topic branch once I got your Acked-by.

Sure, that's fine with me.  Feel free to add a:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to the patch.

thanks,

greg k-h
