Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZJZVTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZJZVTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZJZVTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:19:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41172 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZJZVTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:19:01 -0400
Date: Mon, 26 Oct 2009 22:19:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform_device_add_data(pdev, NULL, 0)
Message-ID: <20091026211903.GA27094@pengutronix.de>
References: <20091023202622.GA11843@pengutronix.de> <20091026164807.GC28072@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091026164807.GC28072@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Oct 26, 2009 at 09:48:07AM -0700, Greg KH wrote:
> On Fri, Oct 23, 2009 at 10:26:22PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > mfd_add_device() (defined in drivers/mfd/mfd-core.c) is a wrapper do
> > allocate platform_devices.
> > 
> > It contains:
> > 
> > 	ret = platform_device_add_data(pdev,
> > 			cell->platform_data, cell->data_size);
> > 
> > If cell->data_size is 0 (and so likely cell->platform_data == NULL),
> > still pdev->dev.platform_data get assigned ZERO_SIZE_PTR.
> > 
> > IMHO the result should better be that pdev->dev.platform_data ends being
> > NULL, too.  Agreed?
> 
> Why?  Is this causing problems somewhere?
The "problem" I as follows:  I have a driver that doesn't use
platform_data and I want to change that.  As both the driver and the
device probably go via different trees and I want to do the following in
the driver:

	if (platform_data != NULL)
		/* use it */
	else
		/* use the old data */

OK, I could simply use:

	if (platform_data != NULL && platform_data != ZERO_SIZE_PTR)
		...

but it feels ugly.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
