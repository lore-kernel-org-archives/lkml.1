Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZJFXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZJFXnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbZJFXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:43:19 -0400
Received: from sous-sol.org ([216.99.217.87]:53261 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757747AbZJFXnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:43:18 -0400
Date: Tue, 6 Oct 2009 16:42:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Allen Kay <allen.m.kay@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org,
       jeremy@goop.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Message-ID: <20091006234208.GB23140@sequoia.sous-sol.org>
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Allen Kay (allen.m.kay@intel.com) wrote:
> +#ifdef CONFIG_DMAR
> +extern int iommu_detected;
> +#endif

This should not be needed.

> +
> +#ifdef CONFIG_XEN
> +extern int xen_domain_type;
> +#endif

Nor this (there's already a check for is dom0 called xen_initial_domain(),
but unclear it's relevant yet for this patch).

> +
> +	/* Enable ACS P2P upstream forwarding if HW iommu is detected */
> +	if (iommu_detected)

I think you'd want iommu_found() instead.  To avoid, e.g., GART
triggering this one.

> +		pci_enable_acs(dev);
> +
> +#ifdef CONFIG_XEN
> +	/* HW iommu is not visible in xen dom0 */
> +	if (xen_domain_type)
> +		pci_enable_acs(dev);

could do this (xen_initial_domain()) above, but it's only relevant for
dom0 (so not needed yet?), and really seems to like it should be done by hv.

thanks,
-chris
