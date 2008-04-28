Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbYD1UhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbYD1UhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937405AbYD1UgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:36:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17913 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937386AbYD1UgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:36:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 41/54] PNP: remove pnp_resource_table references from resource decoders
Date: Mon, 28 Apr 2008 14:36:20 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183932.457629051@ldl.fc.hp.com> <4813AC7D.9000006@keyaccess.nl>
In-Reply-To: <4813AC7D.9000006@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281436.21061.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 04:28:13 pm Rene Herman wrote:
> On 25-04-08 20:38, Bjorn Helgaas wrote:
> 
> > Index: work10/drivers/pnp/pnpacpi/rsparser.c
> > ===================================================================
> > --- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:08.000000000 -0600
> > +++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:09.000000000 -0600
> > @@ -82,8 +82,8 @@
> >  						u32 gsi, int triggering,
> >  						int polarity, int shareable)
> >  {
> > -	struct pnp_resource_table *res = dev->res;
> > -	int i = 0;
> > +	struct resource *res;
> > +	int i;
> >  	int irq;
> >  	int p, t;
> >  	static unsigned char warned;
> > @@ -91,9 +91,11 @@
> >  	if (!valid_IRQ(gsi))
> >  		return;
> >  
> > -	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
> > -	       i < PNP_MAX_IRQ)
> > -		i++;
> > +	for (i = 0; i < PNP_MAX_IRQ; i++) {
> > +		res = &dev->res->irq_resource[i];
> > +		if (res->flags & IORESOURCE_UNSET)
> > +			break;
> > +	}
> 
> Another possible user of pnp_resource_valid.

I changed this, and also changed the array lookups to use
pnp_get_resource().  And I made similar changes in ISAPNP.

And I replaced many of these &dev->res->irq_resource[] things
with pnp_get_resource().  This change rippled through several
subsequent patches, but it's just more mechanical changes.

Bjorn

