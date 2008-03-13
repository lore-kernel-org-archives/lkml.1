Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYCMWFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYCMWFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYCMWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:05:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYCMWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:05:04 -0400
Date: Thu, 13 Mar 2008 15:04:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.de,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] x86_64: free_bootmem should take phy
Message-Id: <20080313150441.014c96f9.akpm@linux-foundation.org>
In-Reply-To: <86802c440803131213i4e19002an859a3f3ffb109727@mail.gmail.com>
References: <86802c440803131213i4e19002an859a3f3ffb109727@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 12:13:23 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86_64: free_bootmem should take phys
> 
> so use nodedata_phys directly.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 0c9b2bd..18267a0 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -221,8 +221,7 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
>  				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
>  	if (bootmap == NULL)  {
>  		if (nodedata_phys < start || nodedata_phys >= end)
> -			free_bootmem((unsigned long)node_data[nodeid],
> -				     pgdat_size);
> +			free_bootmem(nodedata_phys, pgdat_size);
>  		node_data[nodeid] = NULL;
>  		return;
>  	}
> 

Can you please confirm that this change has no dependency upon your other
recent changes?

Thanks.

