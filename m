Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYKZJhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYKZJhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYKZJhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:37:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23640 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYKZJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:36:59 -0500
X-IronPort-AV: E=Sophos;i="4.33,668,1220241600"; 
   d="scan'208";a="29633598"
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org
In-Reply-To: <20081126115344B.fujita.tomonori@lab.ntt.co.jp>
References: <1227277292.7186.32.camel@zakaz.uk.xensource.com>
	 <20081122104919X.fujita.tomonori@lab.ntt.co.jp>
	 <1227526897.9425.38.camel@zakaz.uk.xensource.com>
	 <20081126115344B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 26 Nov 2008 09:36:49 +0000
Message-Id: <1227692209.9425.117.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2008 09:36:58.0199 (UTC) FILETIME=[86D63670:01C94FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 11:53 +0900, FUJITA Tomonori wrote:
> 
> > +     BUG_ON(max_slots > 1UL << (BITS_PER_LONG - IO_TLB_SHIFT));
> 
> How can this BUG_ON happen? Using u64 for the mask is fine though.

It covers the cases where the previous code would have overflowed. It
can't happen right now because although mask is 64 bits the value
assigned to it is currently sizeof(unsigned long). If someone changes
the type of that field then we would start seeing unexpected values.

Ian.

