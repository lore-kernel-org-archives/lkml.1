Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYESXVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYESXVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYESXVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:00 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48783 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYESXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:00 -0400
Message-ID: <4831F8BC.3080405@keyaccess.nl>
Date: Tue, 20 May 2008 00:01:32 +0200
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
Subject: Re: [patch 3/8] PNP: remove pnp_resource.index
References: <20080505223630.682082986@ldl.fc.hp.com> <20080505223959.374741576@ldl.fc.hp.com>
In-Reply-To: <20080505223959.374741576@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 00:36, Bjorn Helgaas wrote:

> We used pnp_resource.index to keep track of which ISAPNP configuration
> register a resource should be written to.  We needed this only to
> handle the case where a register is disabled but a subsequent register
> in the same set is enabled.
> 
> Rather than explicitly maintaining the pnp_resource.index, this patch
> adds a resource every time we read an ISAPNP configuration register
> and marks the resource as IORESOURCE_DISABLED when appropriate.  This
> makes the position in the pnp_resource_table always correspond to the
> config register index.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

> -			pnp_res = pnp_add_io_resource(dev, start, end,
> -						      0);
> -			if (pnp_res)
> -				pnp_res->index = nport++;
> +			pnp_add_io_resource(dev, start, end, 0);

In the tree after your v2 series, pnp_add_foo_resource() are called as 
void functions yet still return a struct pnp_resource *. You might have 
other plans but if not, I guess they can _be_ void functions?

Otherwise:

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

