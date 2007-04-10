Return-Path: <linux-kernel-owner+w=401wt.eu-S1030867AbXDJPl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030867AbXDJPl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDJPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:41:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:36902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030867AbXDJPlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,390,1170662400"; 
   d="scan'208"; a="71374294:sNHT19803195"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] NET: Multiqueue network device support implementation.
Date: Tue, 10 Apr 2007 08:41:49 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC329029E448D@orsmsx414.amr.corp.intel.com>
In-Reply-To: <20070410082049.GC16621@2ka.mipt.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] NET: Multiqueue network device support implementation.
Thread-Index: Acd7ST++ZqOhZ59DQ3yPjfZyOlm+UgAPTONg
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <jgarzik@pobox.com>,
       "cramerj" <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>
X-OriginalArrivalTime: 10 Apr 2007 15:41:50.0758 (UTC) FILETIME=[C19E9C60:01C77B86]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 09, 2007 at 02:28:41PM -0700, Peter P Waskiewicz 
> Jr (peter.p.waskiewicz.jr@intel.com) wrote:
> > + 	alloc_size = (sizeof(struct net_device_subqueue) * queue_count);
> > + 
> > + 	p = kzalloc(alloc_size, GFP_KERNEL);
> > + 	if (!p) {
> > + 		printk(KERN_ERR "alloc_netdev: Unable to 
> allocate queues.\n");
> > + 		return NULL;
> 
> I think you either do not want to print it, or want 
> additional details about device...

Ok.  This is essentially the same output printed if the netdev itself
cannot be allocated.  Should I update both strings to have more
device-specific information?

> 
> > + 	}
> > + 
> > + 	dev->egress_subqueue = p;
> > + 	dev->egress_subqueue_count = queue_count;
> > +
> >  	dev->get_stats = maybe_internal_stats;
> >  	setup(dev);
> >  	strcpy(dev->name, name);
> >  	return dev;
> >  }
> > -EXPORT_SYMBOL(alloc_netdev);
> > +EXPORT_SYMBOL(alloc_netdev_mq);
> >  
> >  /**
> >   *	free_netdev - free network device
> > @@ -3345,6 +3358,7 @@ void free_netdev(struct net_device *dev)  {  
> > #ifdef CONFIG_SYSFS
> >  	/*  Compatibility with error handling in drivers */
> > +	kfree((char *)dev->egress_subqueue);
> >  	if (dev->reg_state == NETREG_UNINITIALIZED) {
> >  		kfree((char *)dev - dev->padded);
> >  		return;
> > @@ -3356,6 +3370,7 @@ void free_netdev(struct net_device *dev)
> >  	/* will free via device release */
> >  	put_device(&dev->dev);
> >  #else
> > +	kfree((char *)dev->egress_subqueue);
> 
> Still casting :)

The latest repost removes these casts.


Thanks for the feedback,

-PJ Waskiewicz
