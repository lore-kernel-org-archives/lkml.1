Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZJ1QGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZJ1QGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZJ1QGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:06:54 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:22150 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbZJ1QGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:06:53 -0400
Subject: Re: [PATCH 4/5] intel-iommu: Reinstate RMRRs if a device is
 removed from passthrough domain
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1256740619.9814.141.camel@macbook.infradead.org>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	 <20091026232514.9646.58322.stgit@nehalem.aw>
	 <1256631324.9814.14.camel@macbook.infradead.org>
	 <1256658632.5937.7.camel@bling>
	 <1256740619.9814.141.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Wed, 28 Oct 2009 10:06:55 -0600
Message-ID: <1256746015.5937.128.camel@bling>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 14:36 +0000, David Woodhouse wrote:
> On Tue, 2009-10-27 at 09:50 -0600, Alex Williamson wrote:
> > 
> > Yes, good point.  I'm not seeing any convenient ways to setup a new
> > domain for a device while it's still a member of the si_domain.  It
> > looks like I'd need to extract parts of the get_valid_domain_for_dev()
> > path and ignore any bits about using the already existing domain.
> 
> That seems like a sane plan. That code wants cleaning up anyway, and
> factoring out the 'make new domain' part of get_valid_domain_for_dev()
> should be simple enough.

Ok, I'll work on something along those lines.  FWIW, even though I sent
these as a series, each one stands on it's own.  While I think
reinstating RMRRs is the right thing to do, I don't know of any devices
that break with the current model (the device I know of with the
interesting RMRR usage shouldn't be demoted from the si_domain).  So
please consider pushing patches 2, 3 & 5 upstream (particularly 2).
Thanks,

Alex

