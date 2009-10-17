Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZJQNyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZJQNyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 09:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZJQNyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 09:54:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:57629 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZJQNyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 09:54:21 -0400
Date: Sat, 17 Oct 2009 22:43:02 +0900
To: akinobu.mita@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, gregkh@suse.de, LW@KARO-electronics.de,
       linux-usb@vger.kernel.org, rolandd@cisco.com, yevgenyp@mellanox.co.il,
       netdev@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear,
	bitmap_find_next_zero_area
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091013091017.GA18431@localhost.localdomain>
References: <20091009164100.85a36188.akpm@linux-foundation.org>
	<20091013021818.GA3898@localhost.localdomain>
	<20091013091017.GA18431@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091017224028V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 17 Oct 2009 22:43:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 18:10:17 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> My user space testing exposed off-by-one error find_next_zero_area
> in iommu-helper. Some zero area cannot be found by this bug.
> 
> Subject: [PATCH] Fix off-by-one error in find_next_zero_area
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  lib/iommu-helper.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> index 75dbda0..afc58bc 100644
> --- a/lib/iommu-helper.c
> +++ b/lib/iommu-helper.c
> @@ -19,7 +19,7 @@ again:
>  	index = (index + align_mask) & ~align_mask;
>  
>  	end = index + nr;
> -	if (end >= size)
> +	if (end > size)

I think that this is intentional; the last byte of the limit doesn't
work.
