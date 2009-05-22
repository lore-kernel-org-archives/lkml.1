Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZEVLp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZEVLp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZEVLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:45:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16184 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbZEVLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:45:17 -0400
X-IronPort-AV: E=Sophos;i="4.41,233,1241409600"; 
   d="scan'208";a="4394176"
Subject: Re: [PATCH] swiotlb: make range_needs_mapping architecture-specific
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "jeremy@goop.org" <jeremy@goop.org>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "xendevel@lists.xensource.com" <xendevel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090522200140Q.fujita.tomonori@lab.ntt.co.jp>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-3-git-send-email-ian.campbell@citrix.com>
	 <20090522200140Q.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 12:45:16 +0100
Message-ID: <1242992716.22654.276.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> On Thu, 21 May 2009 17:15:23 +0100
> Ian Campbell <ian.campbell@citrix.com> wrote:
> > +static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
> > +{
> > +	return 0;
> > +}
> > +
> 
> Adding a swiotlb specific function to asm/dma-mapping.h is wrong.

This one is unnecessary with the dma_map_range proposal.

> > +int (*x86_swiotlb_force_mapping)(phys_addr_t paddr, size_t size);
> > +
[...]
> And using a function pointer for the architecture abstraction is worse
> than __weak.

This specific hook is unnecessary with the dma_map_range proposal but in
general we use function pointers quite extensively for abstraction in
the kernel.

This case is internal to the x86 arch code and I'd really like to hear
the x86 maintainer's opinion of the general approach.

Ian.

