Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZJZVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZJZVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZJZVYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:24:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:49035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZJZVYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:24:33 -0400
Date: Mon, 26 Oct 2009 14:21:32 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform_device_add_data(pdev, NULL, 0)
Message-ID: <20091026212132.GA11973@suse.de>
References: <20091023202622.GA11843@pengutronix.de>
 <20091026164807.GC28072@suse.de>
 <20091026211903.GA27094@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091026211903.GA27094@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:19:03PM +0100, Uwe Kleine-König wrote:
> Hi Greg,
> 
> On Mon, Oct 26, 2009 at 09:48:07AM -0700, Greg KH wrote:
> > On Fri, Oct 23, 2009 at 10:26:22PM +0200, Uwe Kleine-König wrote:
> > > Hello,
> > > 
> > > mfd_add_device() (defined in drivers/mfd/mfd-core.c) is a wrapper do
> > > allocate platform_devices.
> > > 
> > > It contains:
> > > 
> > > 	ret = platform_device_add_data(pdev,
> > > 			cell->platform_data, cell->data_size);
> > > 
> > > If cell->data_size is 0 (and so likely cell->platform_data == NULL),
> > > still pdev->dev.platform_data get assigned ZERO_SIZE_PTR.
> > > 
> > > IMHO the result should better be that pdev->dev.platform_data ends being
> > > NULL, too.  Agreed?
> > 
> > Why?  Is this causing problems somewhere?
> The "problem" I as follows:  I have a driver that doesn't use
> platform_data and I want to change that.  As both the driver and the
> device probably go via different trees and I want to do the following in
> the driver:
> 
> 	if (platform_data != NULL)
> 		/* use it */
> 	else
> 		/* use the old data */
> 
> OK, I could simply use:
> 
> 	if (platform_data != NULL && platform_data != ZERO_SIZE_PTR)
> 		...
> 
> but it feels ugly.

Yes, that would be ugly.  How about just sending the driver and device
through the same trees to prevent this from happening?

thanks,

greg k-h
