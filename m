Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320Ab0AEXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0AEXWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756Ab0AEXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:22:14 -0500
Received: from kroah.org ([198.145.64.141]:43552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab0AEXV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:21:58 -0500
Date: Tue, 5 Jan 2010 15:20:53 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/12] SYSFS: Add attribute array to sysdev classes
Message-ID: <20100105232053.GB815@kroah.com>
References: <201001051247.104464547@firstfloor.org>
 <20100105114802.8240CB17C2@basil.firstfloor.org>
 <20100105145433.GF11732@kroah.com>
 <20100105162451.GF1778@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105162451.GF1778@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:24:51PM +0100, Andi Kleen wrote:
> On Tue, Jan 05, 2010 at 06:54:33AM -0800, Greg KH wrote:
> > On Tue, Jan 05, 2010 at 12:48:02PM +0100, Andi Kleen wrote:
> > > 
> > > Add a attribute array that is automatically registered and unregistered
> > > to struct sysdev_class. This is similar to what struct class has.
> > > 
> > > A lot of drivers add list of attributes, so it's better to do 
> > > this easily in the common sysdev layer.
> > > 
> > > This adds a new field to struct sysdev_class. I audited the 
> > > whole tree and there are no dynamically allocated sysdev classes,
> > > so this is fully compatible. 
> > 
> > I agree, this should be done, but can you use an attribute group
> > instead, like the driver core does?  That way you don't need the new
> > function that you created that duplicates that logic :)
> 
> Actually the attributes use own loops for this too.
> 
> In theory could add a group in the middle, but it would greatly complicate
> the driver interface for little gain.
> 
> In theory the low loops could be shared between the group code
> and sysfs_create_files(), but I'm not sure it's really worth
> it because it's just a few lines of code (which are currently
> duplicated in multiple places anyways, so it's a net-win)
> 
> You still want me to attempt that?

For now, nah, that's ok, I'll take this as-is.  But if you want to make
this change in the future, feel free to.

thanks,

greg k-h
