Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbYESX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbYESX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYESX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:27:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:12537 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbYESX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:27:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/8] PNP: remove pnp_resource.index
Date: Mon, 19 May 2008 17:27:00 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080505223630.682082986@ldl.fc.hp.com> <20080505223959.374741576@ldl.fc.hp.com> <4831F8BC.3080405@keyaccess.nl>
In-Reply-To: <4831F8BC.3080405@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191727.01487.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 04:01:32 pm Rene Herman wrote:
> On 06-05-08 00:36, Bjorn Helgaas wrote:
> 
> > We used pnp_resource.index to keep track of which ISAPNP configuration
> > register a resource should be written to.  We needed this only to
> > handle the case where a register is disabled but a subsequent register
> > in the same set is enabled.
> > 
> > Rather than explicitly maintaining the pnp_resource.index, this patch
> > adds a resource every time we read an ISAPNP configuration register
> > and marks the resource as IORESOURCE_DISABLED when appropriate.  This
> > makes the position in the pnp_resource_table always correspond to the
> > config register index.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> > -			pnp_res = pnp_add_io_resource(dev, start, end,
> > -						      0);
> > -			if (pnp_res)
> > -				pnp_res->index = nport++;
> > +			pnp_add_io_resource(dev, start, end, 0);
> 
> In the tree after your v2 series, pnp_add_foo_resource() are called as 
> void functions yet still return a struct pnp_resource *. You might have 
> other plans but if not, I guess they can _be_ void functions?

You're right, I still don't do anything with the return value.  It
could be used to check for success/failure, but we currently don't
do that.  Possibly a future cleanup since there's no functional
problem here.

Bjorn
