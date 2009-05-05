Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZEEAUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZEEAUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZEEATv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:19:51 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:26419 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZEEATt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.40,294,1238976000"; 
   d="scan'208";a="180739578"
Date: Mon, 4 May 2009 17:19:50 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 5/5] initdev:kernel: USB and SCSI block init device
	notification, v3
Message-ID: <20090505001950.GC29124@cuplxvomd02.corp.sa.net>
References: <20090502023000.GA16076@cuplxvomd02.corp.sa.net> <20090502115539.396206bc@linux-lm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502115539.396206bc@linux-lm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 11:55:39PM -0400, Ming Lei wrote:
> On Fri, 1 May 2009 19:30:00 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
> 
> > From: Alan Stern <stern@rowland.harvard.edu
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 6f51ca4..735b061 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
...
> > @@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
> >  	struct async_scan_data *data = _data;
> >  	do_scsi_scan_host(data->shost);
> >  	scsi_finish_async_scan(data);
> > +	initdev_probe_done(BOOTDEV_BLOCK_MASK);
> 
> Which code are waiting for the block device's probe done?

None yet. That remains to be done.

> > diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> > index 8060b85..ea7abab 100644
> > --- a/drivers/usb/storage/usb.c
> > +++ b/drivers/usb/storage/usb.c
> > @@ -837,6 +837,7 @@ static int usb_stor_scan_thread(void * __us)
> >  		/* Should we unbind if no devices were detected? */
> >  	}
> >  
> > +	initdev_probe_done(BOOTDEV_BLOCK_MASK);
> 
> the same question with above.

Same answer.

> > @@ -937,10 +938,12 @@ int usb_stor_probe2(struct us_data *us)
> >  	}
> >  
> >  	/* Start up the thread for delayed SCSI-device scanning */
> > +	initdev_found(BOOTDEV_BLOCK_MASK);
> >  	th = kthread_create(usb_stor_scan_thread, us,
> > "usb-stor-scan"); if (IS_ERR(th)) {
> >  		printk(KERN_WARNING USB_STORAGE 
> >  		       "Unable to start the device-scanning
> > thread\n");
> > +		initdev_probe_done(BOOTDEV_BLOCK_MASK);
> 
> the same question with above.

Same answer.

> Lei Ming

Thanks!

David VomLehn
