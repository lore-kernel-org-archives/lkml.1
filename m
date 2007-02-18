Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881AbXBRMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbXBRMjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXBRMjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:39:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:39398 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXBRMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dZgTp6OGvi66q2RN1wCwFfV7l2iGywoHMNFflfIUEvPRdbsvGZcZ0ZHi/b50v30X6DQrM9v2TBKD1yIrgr1IuU50bsGs3Bt//TTuk1+d+/ZlZpK02280IDQL9OZq4Z/NR1KMtRXRV1xNgC2+unz/IPzlyWaq1+mAgeMzaWTyz9M=
Date: Sun, 18 Feb 2007 15:36:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218123636.GD10865@cvg>
References: <20070217212918.GA26554@localdomain> <20070218104222.GC10865@cvg> <20070218112903.GA5102@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218112903.GA5102@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 01:29:03PM +0200, Dan Aloni wrote:
| On Sun, Feb 18, 2007 at 01:42:22PM +0300, Cyrill Gorcunov wrote:
| > Hi,
| > 
| > here is a patch attached to the mail. You may test it. Actually
| > I have no 64bit machine to test it and I'm worried about the
| > patch accuracy. So be carefull testing it. I sent a copy of the
| > message to Andi Kleen (who is a maintainer of X86-64 port) may be
| > we should wait for its answer ;)
| 
| Thanks, I'll give it a try soon.
| 
| BTW, wouldn't it be better just to change the type of phys and size
| to u32?
| 
| > diff --git a/drivers/mtd/maps/esb2rom.c b/drivers/mtd/maps/esb2rom.c
| > index a9d808a..d63c060 100644
| > --- a/drivers/mtd/maps/esb2rom.c
| > +++ b/drivers/mtd/maps/esb2rom.c
| > @@ -214,6 +214,9 @@ static int __devinit esb2rom_init_one(struct pci_dev *pdev,
| >  
| >  	/* reserved  0x0020 and 0x0010 */
| >  	window->phys -= 0x400000UL;
| > +#ifdef CONFIG_64BIT
| > +	window->phys &= 0xffffffffUL;
| > +#endif
| >  	window->size = (0xffffffffUL - window->phys) + 1UL;
| >  
| >  	/* Enable writes through the rom window */
| 
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| 

Hi,

actually - I don't know... I think this could be done
by kernel developer specialist only (as Andi Kleen is).
So lets wait until his answer ;) Nevertheless, write
me if the patch resolve the problem.

-- 

		Cyrill

