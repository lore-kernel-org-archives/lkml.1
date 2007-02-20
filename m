Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXBTNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXBTNJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXBTNJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:09:49 -0500
Received: from smtp.nokia.com ([131.228.20.172]:26212 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbXBTNJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:09:48 -0500
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219105927.GB16930@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
	 <20070219105927.GB16930@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 15:00:56 +0200
Message-Id: <1171976456.4039.21.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 13:00:56.0364 (UTC) FILETIME=[28E93EC0:01C754EF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 10:59 +0000, Christoph Hellwig wrote:
> On Sat, Feb 17, 2007 at 06:54:54PM +0200, Artem Bityutskiy wrote:
> > +/* UBI headers must take 64 bytes. The below is a hacky way to ensure this */
> > +static int __ubi_check_ec_hdr_size[(UBI_EC_HDR_SIZE == 64) - 1]
> > +    __attribute__ ((__unused__));
> > +static int __ubi_check_ec_hdr_size[(UBI_VID_HDR_SIZE == 64) - 1]
> > +    __attribute__ ((__unused__));
> 
> please use BUILD_BUG_ON instead.

Will be done, thanks.

> > +
> > +static int ubi_attach_mtd_dev(const char *mtd_dev, int vid_hdr_offset,
> > +			      int data_offset);
> > +static void ubi_destroy_dev(int ubi_num);
> 
> Can you reorder the code to avoid all these forward declarations please?

Could you please submit a CodingStyle patch that would contain a
requirement to use the "higher-level functions at the bottom,
lower-layer at top"? Because I just use the opposite.

> > +	/* Attach MTD devices */
> > +	for (i = 0; i < mtd_devs; i++) {
> > +		struct mtd_dev_param *p = &mtd_dev_param[i];
> > +
> > +		cond_resched();
> > +		err = -EINVAL;
> 
> This looks very odd.

What exactly?

> > +module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
> > +MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> > +		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
> > +		      "Multiple \"mtd\" parameters may be specified.\n"
> > +		      "MTD devices may be specified by their number or name. "
> > +		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
> > +		      "specify UBI VID header position and data starting "
> > +		      "position to be used by UBI.\n"
> > +		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
> > +		      "with name content using VID header offset 1984 and data "
> > +		      "start 2048, and MTD device number 4 using default "
> > +		      "offsets");
> 
> This is a very odd paramater interface.  We really don't want drivers to use
> module_param_call directly.  You probably want various module_param_array calls
> instead.

Why not? We tried to avoid this but found out that this is the most
decent interface. Specific advises are welcome.

Thank you,
Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

