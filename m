Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYHZJdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYHZJdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHZJdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:33:35 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:58443 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYHZJde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:33:34 -0400
Date: Tue, 26 Aug 2008 10:33:35 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, wli@holomorphy.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/hugetlb.c: make resv_map_{alloc,release}()
	static
Message-ID: <20080826093335.GE29207@brain>
References: <20080819134657.GD8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819134657.GD8852@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:46:57PM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global resv_map_{alloc,release}()
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Andy Whitcroft <apw@shadowen.org>

> 99bcfd48d93a0c6286b6345f52d10a0a1a43f8c4 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 28a2980..c3bb4d6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -262,7 +262,7 @@ struct resv_map {
>  	struct list_head regions;
>  };
>  
> -struct resv_map *resv_map_alloc(void)
> +static struct resv_map *resv_map_alloc(void)
>  {
>  	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
>  	if (!resv_map)
> @@ -274,7 +274,7 @@ struct resv_map *resv_map_alloc(void)
>  	return resv_map;
>  }
>  
> -void resv_map_release(struct kref *ref)
> +static void resv_map_release(struct kref *ref)
>  {
>  	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);

-apw
