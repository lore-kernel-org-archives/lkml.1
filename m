Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZFQQZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZFQQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZFQQZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:25:48 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:12495
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369AbZFQQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:25:47 -0400
Message-ID: <4A391909.2090609@panasas.com>
Date: Wed, 17 Jun 2009 19:25:45 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] driver core: remove unheeded warning about driver methods
References: <Pine.LNX.4.44L0.0906171158190.2820-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906171158190.2820-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 16:25:47.0953 (UTC) FILETIME=[4590E210:01C9EF68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2009 06:59 PM, Alan Stern wrote:
> This patch (as1263) removes a warning which has been present for so
> long, and consistently ignored, that it obviously is not doing any
> good.  It gets triggered on pretty much every boot by the SCSI disk
> and cdrom drivers.  Evidently nobody cares.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/base/driver.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/driver.c
> +++ usb-2.6/drivers/base/driver.c
> @@ -225,12 +225,6 @@ int driver_register(struct device_driver
>  
>  	BUG_ON(!drv->bus->p);
>  
> -	if ((drv->bus->probe && drv->probe) ||
> -	    (drv->bus->remove && drv->remove) ||
> -	    (drv->bus->shutdown && drv->shutdown))
> -		printk(KERN_WARNING "Driver '%s' needs updating - please use "
> -			"bus_type methods\n", drv->name);
> -
>  	other = driver_find(drv->name, drv->bus);
>  	if (other) {
>  		put_driver(other);
> 
> --


There was a proper and simple fix for that problem here:
http://www.spinics.net/lists/kernel/msg860289.html

Hannes please re push this patch properly. We want it ;)

Boaz

