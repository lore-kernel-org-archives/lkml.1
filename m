Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZBMNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZBMNJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZBMNJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:09:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:46362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZBMNJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:09:14 -0500
Date: Fri, 13 Feb 2009 14:09:11 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090213130911.GC22743@wotan.suse.de>
References: <1234529407.6519.28.camel@twins> <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins> <1234530311.6519.42.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234530311.6519.42.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 02:05:11PM +0100, Peter Zijlstra wrote:
> On Fri, 2009-02-13 at 14:02 +0100, Peter Zijlstra wrote:
> > Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> > ops yell louder at violations of these rules.
> 
> Something like so?

Couldn't hurt :)


> 
> ---
>  mm/vmalloc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 75f49d3..8516cea 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1249,6 +1249,7 @@ EXPORT_SYMBOL(vfree);
>  void vunmap(const void *addr)
>  {
>  	BUG_ON(in_interrupt());
> +	might_sleep();
>  	__vunmap(addr, 0);
>  }
>  EXPORT_SYMBOL(vunmap);
> @@ -1268,6 +1269,8 @@ void *vmap(struct page **pages, unsigned int count,
>  {
>  	struct vm_struct *area;
>  
> +	might_sleep();
> +
>  	if (count > num_physpages)
>  		return NULL;
>  
