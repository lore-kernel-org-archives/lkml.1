Return-Path: <linux-kernel-owner+w=401wt.eu-S936601AbYD1RRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601AbYD1RRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936411AbYD1RQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:16:44 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24361 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936406AbYD1RQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:16:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 26/54] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
Date: Mon, 28 Apr 2008 11:15:54 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183929.396758295@ldl.fc.hp.com> <48139F9C.6050609@keyaccess.nl>
In-Reply-To: <48139F9C.6050609@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281115.54997.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 03:33:16 pm Rene Herman wrote:
> On 25-04-08 20:38, Bjorn Helgaas wrote:
> 
> >  void pnp_init_resources(struct pnp_dev *dev)
> >  {
> > -	struct pnp_resource_table *table = &dev->res;
> > +	struct resource *res;
> >  	int idx;
> >  
> >  	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
> > -		table->irq_resource[idx].name = NULL;
> > -		table->irq_resource[idx].start = -1;
> > -		table->irq_resource[idx].end = -1;
> > -		table->irq_resource[idx].flags =
> > -		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
> > +		res = &dev->res.irq_resource[idx];
> > +		res->flags = IORESOURCE_IRQ;
> 
> ACK as commented earlier but pnp_clean_resource_table would seem to want the 
> same treatment of setting the type, at least to again guarantee current 
> behaviour:

We always initialize the type in pnp_init_resources(), and while we
do fiddle with some of the other bits in the flags element, I can't
see anyplace where we would clear the type.

But I did add code to set the type in pnp_clean_resource_table(),
just in case.  It could be hard to debug a problem there, and it's
harmless to set it again.

Bjorn
