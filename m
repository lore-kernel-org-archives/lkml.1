Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZEGANn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZEGANn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZEGANe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:13:34 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:47724 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134AbZEGANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:13:34 -0400
Message-ID: <4A0227AD.9030705@snapgear.com>
Date: Thu, 07 May 2009 10:13:33 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
References: <4A00EF23.4050302@snapgear.com> <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com> <30031.1241619079@redhat.com>
In-Reply-To: <30031.1241619079@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Howells wrote:
> Can you try the attached patch, please?

Yes, that fixes it :-)

Regards
Greg


> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] NOMMU: Don't check vm_region::vm_start is page aligned in add_nommu_region()
> 
> Don't check vm_region::vm_start is page aligned in add_nommu_region() because
> the region may reflect some non-page-aligned mapped file, such as could be
> obtained from RomFS XIP.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  mm/nommu.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index cdc6f60..325706b 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -515,8 +515,6 @@ static void add_nommu_region(struct vm_region *region)
>  
>  	validate_nommu_regions();
>  
> -	BUG_ON(region->vm_start & ~PAGE_MASK);
> -
>  	parent = NULL;
>  	p = &nommu_region_tree.rb_node;
>  	while (*p) {
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
