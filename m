Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbXBYF6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbXBYF6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXBYF6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:58:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbXBYF6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:58:32 -0500
Date: Sun, 25 Feb 2007 05:58:28 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, rusty@rustcorp.com.au
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
Message-ID: <20070225055828.GC9137@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>, rusty@rustcorp.com.au
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165454.5845.30875.sendpatchset@localhost.localdomain> <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171976456.4039.21.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 03:00:56PM +0200, Artem Bityutskiy wrote:
> > > +module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
> > > +MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> > > +		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
> > > +		      "Multiple \"mtd\" parameters may be specified.\n"
> > > +		      "MTD devices may be specified by their number or name. "
> > > +		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
> > > +		      "specify UBI VID header position and data starting "
> > > +		      "position to be used by UBI.\n"
> > > +		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
> > > +		      "with name content using VID header offset 1984 and data "
> > > +		      "start 2048, and MTD device number 4 using default "
> > > +		      "offsets");
> > 
> > This is a very odd paramater interface.  We really don't want drivers to use
> > module_param_call directly.  You probably want various module_param_array calls
> > instead.
> 
> Why not? We tried to avoid this but found out that this is the most
> decent interface. Specific advises are welcome.

because this type of compount interface is really painful for the user.
the module.param=foo syntax makes sure paramaters can be used without
endless documentation for each and every single of them, and makes
sure module writers don't introduce bugs in their own parser reimplementations.

Rusty, was it intentional that drivers can use __module_param_call?
Do you think the ubi use here is okay?
