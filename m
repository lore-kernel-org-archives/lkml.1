Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896Ab0AMPkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0AMPkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292Ab0AMPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:40:18 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31750 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0AMPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:40:17 -0500
Subject: Re: [patch 2/6] hugetlb: Fix section mismatches
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20100113004938.715904356@suse.com>
References: <20100113004855.550486769@suse.com>
	 <20100113004938.715904356@suse.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 13 Jan 2010 10:40:12 -0500
Message-Id: <1263397212.11942.97.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 19:48 -0500, Jeff Mahoney wrote:
> plain text document attachment (patches.rpmify)
> hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
>  __init. Since hugetlb_register_node is only called by
>  hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
>  it's safe to mark both of them as __init.

Actually, hugetlb_register_node() also called, via a function pointer
that hugetlb registers with the sysfs node driver, when a node is hot
plugged.  So, I think the correct approach is to remove the '__init'
from hugetlb_sysfs_add_hstate() as this is also used at runtime.  I
missed this in the original submittal.

Regards,
Lee Schermerhorn

> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  mm/hugetlb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1630,7 +1630,7 @@ void hugetlb_unregister_node(struct node
>   * hugetlb module exit:  unregister hstate attributes from node sysdevs
>   * that have them.
>   */
> -static void hugetlb_unregister_all_nodes(void)
> +static void __init hugetlb_unregister_all_nodes(void)
>  {
>  	int nid;
>  
> @@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
>   * Register hstate attributes for a single node sysdev.
>   * No-op if attributes already registered.
>   */
> -void hugetlb_register_node(struct node *node)
> +void __init hugetlb_register_node(struct node *node)
>  {
>  	struct hstate *h;
>  	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

