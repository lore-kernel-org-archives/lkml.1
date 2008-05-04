Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYEDNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYEDNrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYEDNrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:47:08 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:39818 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbYEDNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:47:07 -0400
Message-ID: <481DBE81.8000608@keyaccess.nl>
Date: Sun, 04 May 2008 15:47:45 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PNP: set IRQ index in sysfs "set irq" interface
References: <200805011539.58705.bjorn.helgaas@hp.com>
In-Reply-To: <200805011539.58705.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-05-08 23:39, Bjorn Helgaas wrote:

> We have to set the ISAPNP register index when setting an IRQ via
> the sysfs interface.  We already do it for IO, MEM, and DMA
> resources; I just missed the IRQ one.
> 
> This needs to be in 2.6.26.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: work10/drivers/pnp/interface.c
> ===================================================================
> --- work10.orig/drivers/pnp/interface.c	2008-05-01 15:26:28.000000000 -0600
> +++ work10/drivers/pnp/interface.c	2008-05-01 15:26:39.000000000 -0600
> @@ -424,7 +424,7 @@
>  				start = simple_strtoul(buf, &buf, 0);
>  				pnp_res = pnp_add_irq_resource(dev, start, 0);
>  				if (pnp_res)
> -					nirq++;
> +					pnp_res->index = nirq++;
>  				continue;
>  			}
>  			if (!strnicmp(buf, "dma", 3)) {

Ha, my ack wasn't on that one...

But what I wanted to ask -- judging from my .gitconfig (as opposed to my 
memory) I haven't done anything special to get the -p (--show-c-function) 
functionality from git-diff. Do you do anything special to not get it? It 
really helps when looking at patches.

Rene.
