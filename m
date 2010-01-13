Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0AMJ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0AMJ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203Ab0AMJ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:28:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0AMJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:28:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pL4qMseI24D5MXvgt1cls8/Hlg7keJBP4sCrkTQGYNUcHMfnEhUNk2VvGlJDpBb5G
	Kpao9CI/qRsXw/M/IUb0Q==
Date: Wed, 13 Jan 2010 01:28:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeff Mahoney <jeffm@suse.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 2/6] hugetlb: Fix section mismatches
In-Reply-To: <20100113004938.715904356@suse.com>
Message-ID: <alpine.DEB.2.00.1001130127450.469@chino.kir.corp.google.com>
References: <20100113004855.550486769@suse.com> <20100113004938.715904356@suse.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010, Jeff Mahoney wrote:

>  hugetlb_register_node calls hugetlb_sysfs_add_hstate, which is marked with
>  __init. Since hugetlb_register_node is only called by
>  hugetlb_register_all_nodes, which in turn is only called by hugetlb_init,
>  it's safe to mark both of them as __init.
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

This is wrong, you want to move hugetlb_register_all_nodes() to 
.init.text, not hugetlb_unregister_all_nodes().

> @@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
>   * Register hstate attributes for a single node sysdev.
>   * No-op if attributes already registered.
>   */
> -void hugetlb_register_node(struct node *node)
> +void __init hugetlb_register_node(struct node *node)
>  {
>  	struct hstate *h;
>  	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
