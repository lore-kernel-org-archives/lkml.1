Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZE0ATJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZE0ATJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZE0AS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:18:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZE0AS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:18:57 -0400
Date: Tue, 26 May 2009 20:18:40 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>, airlied@redhat.com,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, eric@anholt.net, stable@kernel.org,
       linux-mm@kvack.org, shaohua.li@intel.com
Subject: Re: [PATCH] drm: i915: ensure objects are allocated below 4GB on
	PAE
Message-ID: <20090527001840.GC16929@bombadil.infradead.org>
References: <20090526162717.GC14808@bombadil.infradead.org> <Pine.LNX.4.64.0905262343140.13452@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905262343140.13452@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:55:50PM +0100, Hugh Dickins wrote:
> I'm confused: I thought GFP_DMA32 only applies on x86_64:
> my 32-bit PAE machine with (slightly!) > 4GB shows no ZONE_DMA32.
> Does this patch perhaps depend on another, to enable DMA32 on 32-bit
> PAE, or am I just in a muddle?
> 

No, you're exactly right, I'm just a muppet and missed the obvious.
Looks like the "correct" fix is the fact that the allocation is thus
filled out with GFP_USER, therefore, from ZONE_NORMAL, and below
max_low_pfn.

Looks like we'll need some additional thinking to get true ZONE_DMA32 on
i386... ugh, I'll look into it tonight.

regards, Kyle

