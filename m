Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZE0Am7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZE0Am7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZE0Amv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:42:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:12405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbZE0Amv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:42:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,255,1241420400"; 
   d="scan'208";a="460655571"
Date: Wed, 27 May 2009 08:42:50 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "airlied@redhat.com" <airlied@redhat.com>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "eric@anholt.net" <eric@anholt.net>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] drm: i915: ensure objects are allocated below 4GB on
	PAE
Message-ID: <20090527004250.GA11835@sli10-desk.sh.intel.com>
References: <20090526162717.GC14808@bombadil.infradead.org> <Pine.LNX.4.64.0905262343140.13452@sister.anvils> <20090527001840.GC16929@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527001840.GC16929@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:18:40AM +0800, Kyle McMartin wrote:
> On Tue, May 26, 2009 at 11:55:50PM +0100, Hugh Dickins wrote:
> > I'm confused: I thought GFP_DMA32 only applies on x86_64:
> > my 32-bit PAE machine with (slightly!) > 4GB shows no ZONE_DMA32.
> > Does this patch perhaps depend on another, to enable DMA32 on 32-bit
> > PAE, or am I just in a muddle?
> > 
> 
> No, you're exactly right, I'm just a muppet and missed the obvious.
> Looks like the "correct" fix is the fact that the allocation is thus
> filled out with GFP_USER, therefore, from ZONE_NORMAL, and below
> max_low_pfn.
> 
> Looks like we'll need some additional thinking to get true ZONE_DMA32 on
> i386... ugh, I'll look into it tonight.
For i386, GFP_USER is enough. But 945G GART can only map to physical page < 4G,
so for x64, we need GFP_DMA32. This is the reason I add extra GFP_DMA32.

Thanks,
Shaohua
