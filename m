Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBTQvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBTQvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZBTQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:50:57 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19033 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZBTQu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:50:56 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "coldwell@redhat.com" <coldwell@redhat.com>
Date: Fri, 20 Feb 2009 16:50:09 +0000
Subject: RE: [GIT PULL] block bits for 2.6.29-rc5
Thread-Topic: [GIT PULL] block bits for 2.6.29-rc5
Thread-Index: AcmTelsVFsEPWa7FQXS1Mgcato5jwQAAFAgw
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77885CA670E6F8@GVW0547EXC.americas.hpqcorp.net>
References: <20090218144105.GZ30821@kernel.dk>
 <20090219170715.47781cc2.akpm@linux-foundation.org>
 <20090220164055.GZ29783@kernel.dk>
In-Reply-To: <20090220164055.GZ29783@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com] 
> Sent: Friday, February 20, 2009 10:41 AM
> To: Andrew Morton
> Cc: torvalds@linux-foundation.org; 
> linux-kernel@vger.kernel.org; Miller, Mike (OS Dev)
> Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
> 
> On Thu, Feb 19 2009, Andrew Morton wrote:
> > On Wed, 18 Feb 2009 15:41:06 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > @@ -3404,6 +3601,24 @@ static int __devinit 
> cciss_init_one(struct pci_dev *pdev,
> > >  	int dac, return_code;
> > >  	InquiryData_struct *inq_buff = NULL;
> > >  
> > > +	if (reset_devices) {
> > > +		/* Reset the controller with a PCI power-cycle */
> > > +		if (cciss_hard_reset_controller(pdev) || 
> cciss_reset_msi(pdev))
> > > +			return -ENODEV;
> > > +
> > > +		/* Some devices (notably the HP Smart Array 5i 
> Controller)
> > > +		   need a little pause here */
> > > +		schedule_timeout_uninterruptible(30*HZ);
> > 
> > little!
> 
> That does qualify as the understatement of the day :-)
> 
> > Perhaps we should do a printk("no, your machine is not dead") here.
> 
> Perhaps we should shrink it to something a little more 
> tolerable and put it in the noop loop instead. 30 seconds is insane...

Some of these controllers do take a long time to recover from the reset because the firmware has to re-initialize. The firmware guys claim that's only a few seconds but that's not true.

Granted, the 5i is old as dirt. Don't know how many are still out there running newer kernels. 

-- mikem