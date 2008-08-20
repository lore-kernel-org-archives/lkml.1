Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYHTTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYHTTGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHTTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:06:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11270 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYHTTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DAkbYfslFjm3OpEqNBdB6WBKeWjZBdshrthNB2N/XhGjRt1pK7FXNtQauoMK/iatQT
         VVLaSsmmB1XobK46oQv8eeMPG56g6bS8wHTQ9Kx+/rOg/NSTcyZ/QjXpYRZOLTquhiBw
         TZWCtPGIpwT+xMwTmfDZmEHGp8KTM9mvKb1pE=
Date: Wed, 20 Aug 2008 21:05:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
Message-ID: <20080820190436.GA5388@joi>
References: <20080820135551.74911cb3@lappy.seanm.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820135551.74911cb3@lappy.seanm.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 01:55:51PM -0400, Sean MacLennan wrote:
> If CONFIG_NEED_MULTIPLE_NODES is *not* set, then you get a section
> mismatch in reference from the variable contig_page_data to the
> variable __initdata bootmem_node_data.
> 
> The simple solution is to just remove the __initdata from
> bootmem_node_data. We could also put an ifdef around the __initdata.
> 
> Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
> ---
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index e023c68..a968ae2 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -31,7 +31,7 @@ unsigned long max_pfn;
>  unsigned long saved_max_pfn;
>  #endif
>  
> -bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
> +bootmem_data_t bootmem_node_data[MAX_NUMNODES];
>  
>  static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
>  
> --

I thought about this warning today and found 2 other solutions:
1) Mark contig_page_data as __ref (but it might hide real bugs).
2) Remove bdata from struct pglist_data and access it directly through
   bootmem_node_data. It requires passing node number to all functions
   which use bdata, but unfortunately arch/ia64/mm/discontig.c handles
   node numbering its own way. I'm still investigating it.

Marcin
