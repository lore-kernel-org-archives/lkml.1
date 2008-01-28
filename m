Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYA1S2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYA1S2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYA1S17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:27:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYA1S16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:27:58 -0500
Date: Mon, 28 Jan 2008 10:25:56 -0800
From: Greg KH <greg@kroah.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Message-ID: <20080128182556.GA19791@kroah.com>
References: <20080108163305.GB10026@in.ibm.com> <20080110173418.GA14728@kroah.com> <200801181016.49128.ossthema@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181016.49128.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 10:16:48AM +0100, Jan-Bernd Themann wrote:
> Hi,
> 
> sorry for answering so late, I'm only tracking netdev and ppc mailing list.
> 
> On Thursday 10 January 2008 18:34, Greg KH wrote:
> > > The structure device_driver(in device.h) has a member struct driver_private which
> > > contains the member kobj (according to drivers/base/base.h).
> > > But in device.h struct driver_private has been declared localy and 
> > > neither defined nor included from base.h.
> > > So my effort to use driver->driver_private->obj also does not work.
> > > (I am surprised from where do you access the struct device_driver)
> > 
> > That is because a driver should not be accessing such a field.
> > 
> > And especially not in this manner, why would this driver be creating a
> > symlink that has already been created by the driver core?  This whole
> > thing can just be removed with no problems.  Can you try just removing
> > the ehea_driver_sysfs_add and ehea_driver_sysfs_remove functions to
> > verify this as I don't have the hardware present to test it out.
> 
> The eHEA driver tries to orginize its sys-entries as close as possible to
> other ethernet drivers. Each eHEA NIC has multiple ports which is not that
> common in PCI. This means that each port is represented by a subdirectory
> which has not the "driver" sys-link, only the root directory has.
> Some tools expect to have this driver link in each port directory.
> That is the reason why this link is created manually.
> 
> Are there any other ways to create this link?

The driver core already creates this link for you.  Don't try to
duplicate what is already there for you.

It should just be a matter of deleting the code, and everything should
be fine.  See the patch that I just sent.

thanks,

greg k-h
