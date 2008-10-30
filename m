Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYJ3GqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYJ3GqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYJ3GqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:46:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48188 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYJ3GqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:46:06 -0400
Date: Thu, 30 Oct 2008 15:45:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: do not recalculate section unnecessarily in
 init_section_page_cgroup
Message-Id: <20081030154532.ad97ec93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1225341530.3135.26.camel@sebastian.kern.oss.ntt.co.jp>
References: <1225341530.3135.26.camel@sebastian.kern.oss.ntt.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 13:38:50 +0900
Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
Thanks, but please add patch description "what this patch fixes".
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> diff -urNp linux-2.6.28-rc2-mm1-orig/mm/page_cgroup.c linux-2.6.28-rc2-mm1/mm/page_cgroup.c
> --- linux-2.6.28-rc2-mm1-orig/mm/page_cgroup.c	2008-10-30 12:49:27.000000000 +0900
> +++ linux-2.6.28-rc2-mm1/mm/page_cgroup.c	2008-10-30 12:52:41.000000000 +0900
> @@ -99,13 +99,11 @@ struct page_cgroup *lookup_page_cgroup(s
>  
>  int __meminit init_section_page_cgroup(unsigned long pfn)
>  {
> -	struct mem_section *section;
> +	struct mem_section *section = __pfn_to_section(pfn);
>  	struct page_cgroup *base, *pc;
>  	unsigned long table_size;
>  	int nid, index;
>  
> -	section = __pfn_to_section(pfn);
> -
>  	if (section->page_cgroup)
>  		return 0;
>  
> @@ -131,7 +129,6 @@ int __meminit init_section_page_cgroup(u
>  		__init_page_cgroup(pc, pfn + index);
>  	}
>  
> -	section = __pfn_to_section(pfn);
>  	section->page_cgroup = base - pfn;
>  	total_usage += table_size;
>  	return 0;
> 
> 
> 

