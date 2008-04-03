Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYDCQn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYDCQn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYDCQns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:43:48 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:49136 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYDCQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:43:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/37] PNP resource_table cleanups, v2
Date: Thu, 3 Apr 2008 10:43:41 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080401151634.730901933@ldl.fc.hp.com> <200804021535.22011.bjorn.helgaas@hp.com> <47F4FDCB.2000803@keyaccess.nl>
In-Reply-To: <47F4FDCB.2000803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031043.43068.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 09:54:51 am Rene Herman wrote:
> However, now that you made me look closer and in context -- there's actually 
> a possibly somewhat serious problem here.
> 
> isapnp_read_resources() stores the resources as read from the hardware at 
> the index in the table that matches the actual index in the hardware and 
> isapnp_set_resources() stores them back into those same hardware indices.
> 
> Now by using pnp_add_foo_resource() which just scans for the first _UNSET 
> resource, the resources might not end up in the same linear position in 
> table/list if intermediate resources were unset in hardware (!ret). A 
> subsequent isapnp_set_resources() would them restore the value to the wrong 
> hardware index.
> 
> The IORESOURCE_ flags currently reserve too few bits (IORESOURCE_BITS,  8) 
> to be able to store the hardware index: IORESOURCE_MEM and IORESOURCE_DMA 
> need 2 and 1 respectively and there are 1 and 0 available respectively. It's 
> ofcourse possible to hijack a few more bits in IORESOURCE_ flags but you're 
> turning this into a list. I suppose the idea is to make it a simple list of 
> struct resource, but perhaps a resource-private "driver_data" sort of field 
> comes in handy for more than this already? Swiping more of IORESOURCE_ is a 
> bit ugly...
> 
> In any case, I missed this, but ISAPnP is still (at least in principle) 
> broken with the current set therefore.

Hmm...  you're right.  And I think it could bite PNPBIOS and PNPACPI
as well -- they don't read/write hardware registers directly, but the
firmware still depends on preserving the resource order.  I'll have to
ponder that for a while.

Bjorn
