Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZKQX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZKQX0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZKQX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:26:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:53193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZKQX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:26:38 -0500
Subject: Re: [regression] [drm:i915_gem_execbuffer] *ERROR* Execbuf while
 wedged
From: David Woodhouse <dwmw2@infradead.org>
To: "schnitzelkuchen@googlemail.com" <schnitzelkuchen@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
In-Reply-To: <200911151048.13777.schnitzelkuchen@googlemail.com>
References: <200911151048.13777.schnitzelkuchen@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 23:26:41 +0000
Message-ID: <1258500401.6132.88.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 01:48 -0800, Michael wrote:
> 
> After bisecting i got to the following commit:
> 
> 176616814d700f19914d8509d9f65dec51a6ebf7 is the first bad commit
> commit 176616814d700f19914d8509d9f65dec51a6ebf7
> Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
> Date:   Mon Jul 27 12:59:57 2009 +0100
> 
>     intel_agp: Use PCI DMA API correctly on chipsets new enough to
> have IOMMU

There are later commits which fixed some handling of addresses >4GiB --
it's not _entirely_ unexpected that that particular point in time didn't
work. It'll be using swiotlb instead of just addressing the page
directly.

Can you apply the patch in commit 135cbc4e (just the second part; the
addition) and check whether it still fails?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

