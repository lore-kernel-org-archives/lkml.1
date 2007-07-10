Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXGJEuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXGJEuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXGJEun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:50:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53388 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXGJEum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:50:42 -0400
Date: Mon, 9 Jul 2007 21:49:11 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, akpm@linux-foundation.org, ak@suse.de,
       rientjes@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] try parent numa_node at first before using default
Message-ID: <20070710044911.GB10748@kroah.com>
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org> <200707031731.02456.yinghai.lu@sun.com> <20070710004416.GA6905@kroah.com> <Pine.LNX.4.64.0707091751410.2269@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707091751410.2269@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 05:52:34PM -0700, Christoph Lameter wrote:
> On Mon, 9 Jul 2007, Greg KH wrote:
> 
> > > @@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
> > >  
> > >  void device_initialize(struct device *dev)
> > >  {
> > > +	int node;
> > > +
> > >  	kobj_set_kset_s(dev, devices_subsys);
> > >  	kobject_init(&dev->kobj);
> > >  	klist_init(&dev->klist_children, klist_children_get,
> > > @@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
> > >  	spin_lock_init(&dev->devres_lock);
> > >  	INIT_LIST_HEAD(&dev->devres_head);
> > >  	device_init_wakeup(dev, 0);
> > > -	set_dev_node(dev, -1);
> > > +
> > > +	node = dev->parent ? dev_to_node(dev->parent) : -1;
> > > +	set_dev_node(dev, node);
> > >  }
> > 
> > What is this going to give us?
> > 
> > Doesn't it mean that all devices will end up on the same node?
> 
> It means that the node for the device is the same as the parent device.
> F.e. if the parent device is a bus that is connected to node 4 then all 
> the devices hooked up to the bus are allocated on that node.

Yes, but is someone setting the parent device node information properly?

And this really needs some more changelog information please.  Why is
this needed from how things are done today?

thanks,

greg k-h
