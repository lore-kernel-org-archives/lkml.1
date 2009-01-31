Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZAaEpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZAaEpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 23:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZAaEpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 23:45:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZAaEpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 23:45:03 -0500
Date: Fri, 30 Jan 2009 23:44:54 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Bhavesh Davda <bhavesh@vmware.com>
Cc: "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
	'dmar_disabled'
Message-ID: <20090131044454.GA5184@bombadil.infradead.org>
Reply-To: kyle@infradead.org
References: <AF9CD7A487028E428749836D21102612201D323DBB@PA-EXMBX02.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF9CD7A487028E428749836D21102612201D323DBB@PA-EXMBX02.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:54:12PM -0800, Bhavesh Davda wrote:
> 
> intel_iommu_domain_alloc() will try and iommu_alloc_domain(iommu),
> which calls alloc_domain_mem() to allocate out of 'iommu_domain_cache'.
> Unfortunately iommu_domain_cache will not be created if booted with
> "intel_iommu=off", i.e. dmar_disabled = 1.
> 

Hi Bhavesh,

What's the callchain that can result in intel_iommu_domain_alloc
being called? It looks like most possible callsites are checking
intel_iommu_found, which will be 0 since we check dmar_disabled before
calling init_dmars to enumerate the iommus.

(I'm looking at 2.6.28.y right now, is there an interim between when you
 stumbled upon this two weeks ago and git head where it's no longer an
 issue? I guess it probably got missed due to folks travelling for LCA.)

regards, Kyle
