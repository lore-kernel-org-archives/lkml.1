Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZJ0IPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZJ0IPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbZJ0IPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:15:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:59714 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZJ0IPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:15:24 -0400
Subject: Re: [PATCH 4/5] intel-iommu: Reinstate RMRRs if a device is
 removed from passthrough domain
From: David Woodhouse <dwmw2@infradead.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20091026232514.9646.58322.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	 <20091026232514.9646.58322.stgit@nehalem.aw>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 08:15:24 +0000
Message-Id: <1256631324.9814.14.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 17:25 -0600, Alex Williamson wrote:
> When a device is setup for passthrough it has full access to memory
> so processing the RMRRs is unnecessary.  However, if we remove the device
> from the si_domain, we need to reinstate the associated RMRRs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

If your device is doing DMA to host memory autonomously, you may still
have problems with this patch -- you take it out of the si_domain and
then there's a period of time before you reapply the RMRRs, during which
its DMA may be prevented.

You want to set up the new domain first, then switch the device over to
it atomically.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

