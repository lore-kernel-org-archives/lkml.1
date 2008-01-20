Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYATLEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYATLEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYATLEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:04:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:57279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYATLE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:04:29 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 12:04:26 +0100
Message-Id: <1200827066.3713.4.camel@queen>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-20 at 02:23 +0200, Pekka Enberg wrote:
> Hi Thomas,
> 
> On Jan 19, 2008 10:00 PM, Thomas Renninger <trenn@suse.de> wrote:
> > +static int pnp_alloc_port(struct pnp_resource_table *res)
> > +{
> 
> [snip]
> 
> > +       res->port_resource = krealloc(res->port_resource,
> > +             (sizeof(struct resource) * res->allocated_ports)
> > +             + (sizeof(struct resource) * PNP_ALLOC_PORT), GFP_KERNEL);
> > +
> > +       if (!res->port_resource)
> > +               return -ENOMEM;
> 
> When krealloc() returns NULL, there wasn't enough memory to fit the
> new size but the original memory region remains unchanged. Therefore
> you must not unconditionally overwrite the res->port_resource with the
> return value of krealloc(); otherwise you might leak memory.
> 
Thanks.
While looking at this I found something else..., I think I sent an old
version.

Please hold off, I will double check and resend soon.

   Thomas

