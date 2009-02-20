Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZBTQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZBTQng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZBTQn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:43:26 -0500
Received: from brick.kernel.dk ([93.163.65.50]:17184 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZBTQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:43:25 -0500
Date: Fri, 20 Feb 2009 17:40:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mike.miller@hp.com
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090220164055.GZ29783@kernel.dk>
References: <20090218144105.GZ30821@kernel.dk> <20090219170715.47781cc2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219170715.47781cc2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19 2009, Andrew Morton wrote:
> On Wed, 18 Feb 2009 15:41:06 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > @@ -3404,6 +3601,24 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
> >  	int dac, return_code;
> >  	InquiryData_struct *inq_buff = NULL;
> >  
> > +	if (reset_devices) {
> > +		/* Reset the controller with a PCI power-cycle */
> > +		if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
> > +			return -ENODEV;
> > +
> > +		/* Some devices (notably the HP Smart Array 5i Controller)
> > +		   need a little pause here */
> > +		schedule_timeout_uninterruptible(30*HZ);
> 
> little!

That does qualify as the understatement of the day :-)

> Perhaps we should do a printk("no, your machine is not dead") here.

Perhaps we should shrink it to something a little more tolerable and put
it in the noop loop instead. 30 seconds is insane...

-- 
Jens Axboe

