Return-Path: <linux-kernel-owner+w=401wt.eu-S965156AbXBYWIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156AbXBYWIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 17:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXBYWIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 17:08:48 -0500
Received: from ozlabs.org ([203.10.76.45]:50285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965156AbXBYWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 17:08:47 -0500
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070225055828.GC9137@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
	 <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron>
	 <20070225055828.GC9137@infradead.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 09:03:50 +1100
Message-Id: <1172441030.13541.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 05:58 +0000, Christoph Hellwig wrote:
> On Tue, Feb 20, 2007 at 03:00:56PM +0200, Artem Bityutskiy wrote:
> > > > +module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
> > > > +MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> > > > +		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
> > > > +		      "Multiple \"mtd\" parameters may be specified.\n"
> > > > +		      "MTD devices may be specified by their number or name. "
> > > > +		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
> > > > +		      "specify UBI VID header position and data starting "
> > > > +		      "position to be used by UBI.\n"
> > > > +		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
> > > > +		      "with name content using VID header offset 1984 and data "
> > > > +		      "start 2048, and MTD device number 4 using default "
> > > > +		      "offsets");
> > > 
> > > This is a very odd paramater interface.  We really don't want drivers to use
> > > module_param_call directly.  You probably want various module_param_array calls
> > > instead.
> > 
> > Why not? We tried to avoid this but found out that this is the most
> > decent interface. Specific advises are welcome.
> 
> because this type of compount interface is really painful for the user.
> the module.param=foo syntax makes sure paramaters can be used without
> endless documentation for each and every single of them, and makes
> sure module writers don't introduce bugs in their own parser reimplementations.
> 
> Rusty, was it intentional that drivers can use __module_param_call?
> Do you think the ubi use here is okay?

The reason drivers can use __module_param_call is that they can
implement their own "types" for module parameters, which will end up
requiring this.

Using it directly is only really for backwards compatibility (which is
important!), but for new parameters, this multi-part self-parsing is
nasty.  Standard (but admittedly suboptimal) way to do this is having
three parameters module_param_array(name, ...),
module_param_array(header_offset, ...),
module_param_array(data_start, ...).

Hope that helps,
Rusty.



