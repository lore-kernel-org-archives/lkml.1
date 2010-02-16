Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0BPBaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:30:02 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35036 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0BPBaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:30:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Feb 2010 10:26:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm: add comment about deprecation of __GFP_NOFAIL
Message-Id: <20100216102626.5f6f0e11.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002151712290.23480@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com>
	<20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
	<20100216092147.85ef7619.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151712290.23480@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 17:13:57 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > As I already explained when you first brought this up, the possibility of 
> > > not invoking the oom killer is not unique to GFP_DMA, it is also possible 
> > > for GFP_NOFS.  Since __GFP_NOFAIL is deprecated and there are no current 
> > > users of GFP_DMA | __GFP_NOFAIL, that warning is completely unnecessary.  
> > > We're not adding any additional __GFP_NOFAIL allocations.
> > >
> > 
> > Please add documentation about that to gfp.h before doing this.
> > Doing this without writing any documenation is laziness.
> > (WARNING is a style of documentation.)
> > 
> 
> This is already documented in the page allocator, but I guess doing it in 
> include/linux/gfp.h as well doesn't hurt.
> 
I want warning when someone uses OBSOLETE interface but...

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I hope no 3rd vendor (proprietary) driver uses __GFP_NOFAIL, they tend to
believe API is trustable and unchanged.

> 
> 
> mm: add comment about deprecation of __GFP_NOFAIL
> 
> __GFP_NOFAIL was deprecated in dab48dab, so add a comment that no new 
> users should be added.
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/gfp.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -30,7 +30,8 @@ struct vm_area_struct;
>   * _might_ fail.  This depends upon the particular VM implementation.
>   *
>   * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
> - * cannot handle allocation failures.
> + * cannot handle allocation failures.  This modifier is deprecated and no new
> + * users should be added.
>   *
>   * __GFP_NORETRY: The VM implementation must not retry indefinitely.
>   *
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

