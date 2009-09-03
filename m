Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbZICM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbZICM2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZICM2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:28:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZICM2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:28:44 -0400
Subject: Re: [RFC v6][PATCH 1/4] intel_txt: Intel(R) TXT boot support
From: David Woodhouse <dwmw2@infradead.org>
To: joseph.cihula@intel.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
In-Reply-To: <4A4ACA63.2000708@intel.com>
References: <4A4ACA63.2000708@intel.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 13:28:34 +0100
Message-Id: <1251980914.4483.494.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 19:30 -0700, Joseph Cihula wrote:
> 
> +int tboot_force_iommu(void)
> +{
> +       if (!tboot_enabled())
> +               return 0;
> +
> +       if (no_iommu || swiotlb || dmar_disabled)
> +               pr_warning("Forcing Intel-IOMMU to enabled\n");
> +
> +       dmar_disabled = 0;
> +#ifdef CONFIG_SWIOTLB
> +       swiotlb = 0;
> +#endif
> +       no_iommu = 0;
> +
> +       return 1;
> +}

Ick. The logic for selecting which IOMMU is used is convoluted enough
already, without adding this here.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

