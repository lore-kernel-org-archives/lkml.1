Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZFDJT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZFDJT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZFDJTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:19:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46095 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbZFDJTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:19:18 -0400
Date: Thu, 4 Jun 2009 11:26:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v5
Message-ID: <20090604092634.GW1065@one.firstfloor.org>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org> <20090604032441.GC5740@localhost> <20090604051346.GM1065@one.firstfloor.org> <20090604090737.GB18421@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604090737.GB18421@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:07:37PM +0800, Wu Fengguang wrote:
> 
> > > > +        * need this to decide if we should kill or just drop the page.
> > > > +        */
> > > > +       mapping = page_mapping(p);
> > > > +       if (!PageDirty(p) && !PageAnon(p) && !PageSwapBacked(p) &&
> > > 
> > > !PageAnon(p) could be removed: the below non-zero mapping check will
> > > do the work implicitly.
> > 
> > You mean !page_mapped?  Ok.
> 
> I mean to do
>                 mapping = page_mapping(p);
>                 if (!PageDirty(p) && !PageSwapBacked(p) && 
>                     mapping && mapping_cap_account_dirty(mapping)) {
> 
> Because for anonymous pages, page_mapping == NULL.

I realized this after pressing send. Anyways the PageAnon is dropped
> 
> --- sound-2.6.orig/mm/memory-failure.c
> +++ sound-2.6/mm/memory-failure.c
> @@ -660,6 +660,10 @@ static void hwpoison_user_mappings(struc
>  			break;
>  		pr_debug("MCE %#lx: try_to_unmap retry needed %d\n", pfn,  ret);
>  	}
> +	if (ret != SWAP_SUCCESS)
> +		printk(KERN_ERR
> +		       "MCE %#lx: failed to unmap page (mapcount=%d)!\n",
> +		       pfn, page_mapcount(p));

Ok.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
