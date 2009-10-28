Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZJ1OhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZJ1OhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZJ1OhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:37:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45487 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZJ1OhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:37:02 -0400
Subject: Re: [PATCH 4/5] intel-iommu: Reinstate RMRRs if a device is
 removed from passthrough domain
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1256658632.5937.7.camel@bling>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	 <20091026232514.9646.58322.stgit@nehalem.aw>
	 <1256631324.9814.14.camel@macbook.infradead.org>
	 <1256658632.5937.7.camel@bling>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 14:36:59 +0000
Message-Id: <1256740619.9814.141.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 09:50 -0600, Alex Williamson wrote:
> On Tue, 2009-10-27 at 08:15 +0000, David Woodhouse wrote:
> > On Mon, 2009-10-26 at 17:25 -0600, Alex Williamson wrote:
> > > When a device is setup for passthrough it has full access to memory
> > > so processing the RMRRs is unnecessary.  However, if we remove the device
> > > from the si_domain, we need to reinstate the associated RMRRs.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> > 
> > If your device is doing DMA to host memory autonomously, you may still
> > have problems with this patch -- you take it out of the si_domain and
> > then there's a period of time before you reapply the RMRRs, during which
> > its DMA may be prevented.
> > 
> > You want to set up the new domain first, then switch the device over to
> > it atomically.
> 
> Yes, good point.  I'm not seeing any convenient ways to setup a new
> domain for a device while it's still a member of the si_domain.  It
> looks like I'd need to extract parts of the get_valid_domain_for_dev()
> path and ignore any bits about using the already existing domain.

That seems like a sane plan. That code wants cleaning up anyway, and
factoring out the 'make new domain' part of get_valid_domain_for_dev()
should be simple enough.

-- 
dwmw2

