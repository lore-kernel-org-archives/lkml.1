Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYCGWUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYCGWUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYCGWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:19:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36691 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754565AbYCGWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:19:54 -0500
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080307161012.GC28439@kroah.com>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
	 <20080307161012.GC28439@kroah.com>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 22:19:51 +0000
Message-Id: <1204928391.13653.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 08:10 -0800, Greg KH wrote:
> On Thu, Mar 06, 2008 at 06:11:54PM +0000, Liam Girdwood wrote:

> > +/**
> > + * struct regulator_cdev
> > + *
> > + * Voltage / Current regulator class device. One for each regulator.
> > + */
> > +struct regulator_cdev {
> > +	struct regulator_desc *desc;
> > +	int use_count;
> > +
> > +	struct list_head list;
> > +	struct list_head consumer_list;
> > +	struct blocking_notifier_head notifier;
> > +	struct mutex mutex; /* consumer lock */
> > +	struct module *owner;
> > +	struct class_device cdev;
> 
> Can you change this to use a "struct device" instead?  We are trying to
> get rid of class_device, and there are only 3 users of it in the kernel
> today (memorystick, infiniband, and scsi), and I have patches pending to
> fix all of these.  For 2.6.26 I would like to be rid of it finally.
> 
> If you want, I would be glad to fix this up for you, it should be a
> pretty simple replacement.
> 

Yes please. Much appreciated :)

> > +	struct regulation_constraints *constraints;
> > +	struct regulator_cdev *parent;	/* for tree */
> 
> And if when you convert, you can get rid of this pointer, it would not
> be needed.

Fwiw, the regulator-parent relationship is established by the platform
code after the regulator driver has registered all the regulator
devices. I assume we can just device_move() to re-parent. 

It may also be nice to have a link like /sys/power/regulator
-> /sys/devices/.../regulator 

> 
> > +	void *reg_data;		/* regulator_cdev data */
> 
> Nor would this one.  Actually I don't think you need this one today
> anyway...
> 

Agreed, this is just driver_data for the regulator driver.

Many Thanks

Liam

