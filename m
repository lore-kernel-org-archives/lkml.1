Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZBKTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZBKTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZBKTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:03:40 -0500
Received: from sous-sol.org ([216.99.217.87]:56052 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752567AbZBKTDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:03:39 -0500
Date: Wed, 11 Feb 2009 10:59:45 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.sc.intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH]iwlan dma mapping read and write changes
Message-ID: <20090211185945.GQ27684@sequoia.sous-sol.org>
References: <20081001165606.GA21279@linux-os.sc.intel.com> <20090211182648.GA1661@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211182648.GA1661@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fenghua Yu (fenghua.yu@intel.com) wrote:
> When iwlan runs on IOMMU, IOMMU generates a lot of PTE write faults because PTE
> write bit is not set on some of PTE's. This is because iwlan driver calls DMA
> mapping with PCI_DMA_TODEVICE which is read only in mapping PTE. But iwlan device
> actually writes to the mapped page to update its contents. This issue is not
> exposed in swiotlb. But VT-d hardware can capture this fault and stop the fault
> transaction.
> 
> The following patch fixes the issue.

Yes, plain old driver bug!  This fixes the iwlagn vt-d issue.


> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Tested-by: Chris Wright <chrisw@sous-sol.org>

thanks,
chris
