Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZKBKjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZKBKjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZKBKjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:39:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58988 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZKBKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:39:40 -0500
Date: Mon, 2 Nov 2009 11:39:40 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, Mike Rapoport <mike@compulab.co.il>
Subject: Re: Using statically allocated memory for platform_data.
Message-ID: <20091102103940.GA25282@pengutronix.de>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102112316.16163f6a.ospite@studenti.unina.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 02, 2009 at 11:23:16AM +0100, Antonio Ospite wrote:
> Hi,
> 
> I noted that in some mfd drivers (drivers/mfd/ezx-pcap.c and
> drivers/mfd/da903x.c) there is code like this:
> 
> static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
>                                      struct pcap_subdev *subdev)
> {
>         struct platform_device *pdev;
> 
>         pdev = platform_device_alloc(subdev->name, subdev->id);
>         pdev->dev.parent = &pcap->spi->dev;
>         pdev->dev.platform_data = subdev->platform_data;
> 
>         return platform_device_add(pdev);
> }
> 
> Note the _direct_assignment_ of platform data; then in board init code
> there are often global struct pointers passed as subdev platform data,
> see arch/arm/mach-pxa/em-x270.c::em_x270_da9030_subdevs for instance.
> 
> In these cases, whenever the subdev platform device is unregistered,
> the call to platform_device_release() tries to kfree the platform data,
> and being it statically allocated memory this triggers a bug from SLAB:
> 	kernel BUG at mm/slab.c:521!
> In my case this prevented proper device poweroff.
> 
> The question: should these mfd drivers use platform_device_add_data()
> which allocates dynamic memory for *a copy* of platform data? Is this
> simple solution acceptable even if there will be more memory used?
If you move the original data lives in .init there is no duplication.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
