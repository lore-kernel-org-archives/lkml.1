Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYADIFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYADIFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYADIFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:05:09 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:63542 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYADIFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:05:07 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] (Resend part #1) Add the RapidIO support to powerpcarchitecture with memory mapping support.
Date: Fri, 4 Jan 2008 15:02:42 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEACF8A0@zch01exm26.fsl.freescale.net>
In-Reply-To: <20071223093911.3fd4d1e5.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] (Resend part #1) Add the RapidIO support to powerpcarchitecture with memory mapping support.
Thread-Index: AchE65NNXblbuT92RbSkFZ5r81lZHwJs93Wg
References: <11982311233889-git-send-email-wei.zhang@freescale.com> <20071223093911.3fd4d1e5.sfr@canb.auug.org.au>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linuxppc-dev@ozlabs.org>, <paulus@samba.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  

Thanks!

Maybe I should make a clean and split them into small patches.

Cheers!
Wei.

> Hi,
> 
> This is a very large patch.  It may be easier to review if it could be
> split on some logical way, that is at all possible (I don't 
> know either
> way).  This is just a quick note about some more trivial things.
> 
> On Fri, 21 Dec 2007 17:58:43 +0800 Zhang Wei 
> <wei.zhang@FREESCALE.COM> wrote:
> >
> > +struct rio_priv {
> > +	volatile void __iomem *regs_win;
> > +	volatile struct rio_atmu_regs __iomem *atmu_regs;
> > +	volatile struct rio_atmu_regs __iomem *maint_atmu_regs;
> > +	volatile struct rio_atmu_regs __iomem *dbell_atmu_regs;
> > +	volatile void __iomem *dbell_win;
> > +	volatile void __iomem *maint_win;
> > +	volatile struct rio_msg_regs __iomem *msg_regs;
> 
> Paulus has said that any pointer marked __iomem does not need to be
> volatile ...
> 
> > +static int of_cells_get(struct device_node *np, const char *str)
> > +{
> > +	struct device_node *tmp = NULL;
> > +	const int *var = NULL;
> 
> These initializations are unnecessary.
> 
> > +	var = of_get_property(np, str, NULL);
> > +	tmp = of_get_parent(np);
> > +
> > +	while (!var && tmp) {
> > +		var = (int *)of_get_property(tmp, str, NULL);
> 
> While I applaud the number of casts remove by this patch, 
> this one is an
> unnecessary addition.
> 
> > +		of_node_put(tmp);
> > +		tmp = of_get_parent(np);
> 
> You should do the above two line in the opposite order. Also do you
> really want to keep getting the parent of the same node over and over
> (i.e. you never change np)?
> 
> > +	}
> 
> You probably want a final of_node_put(tmp).
> 
> 
> > +	INFO("Phy type: ");
> > +	switch (phy_type) {
> > +	case RIO_PHY_SERIAL:
> > +		printk("serial\n");
> > +		break;
> > +	case RIO_PHY_PARALLEL:
> > +		printk("parallel");
> 
> Missing \n
> 
> > +	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
> > +	if (!port) {
> > +		ERR("Can't alloc memory for 'port'\n");
> > +		rc = -ENOMEM;
> > +		goto err;
> > +	}
> >  	port->id = 0;
> >  	port->index = 0;
> 
> These two could go as you just allocated zeroed memory.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
