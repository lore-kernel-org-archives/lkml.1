Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZHXQEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZHXQEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZHXQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:04:03 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:22534 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZHXQEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:04:01 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 24 Aug 2009 16:03:59 +0000
Subject: RE: [PATCH] cciss: memory leak in cciss_init_one()
Thread-Topic: [PATCH] cciss: memory leak in cciss_init_one()
Thread-Index: AcokkQ+7slNgN9blRH+O1koydUPRSQAQ10og
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778869529DACD7@GVW0547EXC.americas.hpqcorp.net>
References: <4A7961DE.1090702@gmail.com> <4A91058F.3050708@gmail.com>
 <20090824080115.GA12579@kernel.dk>
In-Reply-To: <20090824080115.GA12579@kernel.dk>
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
> Sent: Monday, August 24, 2009 3:01 AM
> To: Eric Dumazet
> Cc: Andrew Morton; Miller, Mike (OS Dev); linux kernel; 
> stable@kernel.org; FUJITA Tomonori
> Subject: Re: [PATCH] cciss: memory leak in cciss_init_one()
> 
> On Sun, Aug 23 2009, Eric Dumazet wrote:
> > Andrew, I originally sent this 18 days ago and got no reply 
> yet, maybe 
> > could you get the baby ?
> 
> I'll add it for 2.6.32.
> 

I guess I'm missing something. Where is the leak?

-- mikem

> > 
> > Thanks
> > 
> > [PATCH] cciss: memory leak in cciss_init_one()
> > 
> > commit 22bece00dc1f28dd3374c55e464c9f02eb642876
> > (cciss: fix regression firmware not displayed in procfs) 
> added a small 
> > memory leak in cciss_init_one()
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index 
> > a52cc7f..0589dfb 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -3889,7 +3889,7 @@ static int __devinit 
> cciss_init_one(struct pci_dev *pdev,
> >  	int j = 0;
> >  	int rc;
> >  	int dac, return_code;
> > -	InquiryData_struct *inq_buff = NULL;
> > +	InquiryData_struct *inq_buff;
> >  
> >  	if (reset_devices) {
> >  		/* Reset the controller with a PCI power-cycle 
> */ @@ -4029,6 
> > +4029,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
> >  		printk(KERN_WARNING "cciss: unable to determine 
> firmware"
> >  			" version of controller\n");
> >  	}
> > +	kfree(inq_buff);
> >  
> >  	cciss_procinit(i);
> >  
> > @@ -4045,7 +4046,6 @@ static int __devinit 
> cciss_init_one(struct pci_dev *pdev,
> >  	return 1;
> >  
> >  clean4:
> > -	kfree(inq_buff);
> >  	kfree(hba[i]->cmd_pool_bits);
> >  	if (hba[i]->cmd_pool)
> >  		pci_free_consistent(hba[i]->pdev,
> > 
> 
> --
> Jens Axboe
> 
> 