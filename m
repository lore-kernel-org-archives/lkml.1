Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbYAaSk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbYAaSk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763763AbYAaSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:40:17 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38441 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbYAaSkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:40:14 -0500
Date: Thu, 31 Jan 2008 19:38:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [Patch] mm: fix a section mismatch warning
Message-ID: <20080131183853.GB2893@uranus.ravnborg.org>
References: <200801311648.43389.alessandro.guido@gmail.com> <20080131172517.GG2471@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131172517.GG2471@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG.

On Fri, Feb 01, 2008 at 01:25:17AM +0800, WANG Cong wrote:
> 
> This patch fix this mismatch warning from mm:
> 
> WARNING: vmlinux.o(.meminit.text+0x37f): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
> modpost: Found 1 section mismatch(es).
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b2838c2..8a9ae3c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3321,7 +3321,7 @@ static inline int pageblock_default_order(unsigned int order)
>   *   - mark all memory queues empty
>   *   - clear the memory bitmaps
>   */
> -static void __meminit free_area_init_core(struct pglist_data *pgdat,
> +static void __init free_area_init_core(struct pglist_data *pgdat,
>  		unsigned long *zones_size, unsigned long *zholes_size)
>  {
>  	enum zone_type j;
> @@ -3445,7 +3445,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
>  #endif /* CONFIG_FLAT_NODE_MEM_MAP */
>  }
>  
> -void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
> +void __init free_area_init_node(int nid, struct pglist_data *pgdat,
This change make me a bit unnerved. HAve you checked all callers?
I simple grep shows 46 hits in the tree.

It is always good to explain why the change you do is OK,
for no other reasons than to show you really thought it through.

	Sam
