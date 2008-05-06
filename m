Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbYEFOUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbYEFOUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYEFOT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:19:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbYEFOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:19:57 -0400
Date: Tue, 6 May 2008 07:19:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: clameter@sgi.com, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
Message-Id: <20080506071943.46641c26.akpm@linux-foundation.org>
In-Reply-To: <482029E7.6070308@cn.fujitsu.com>
References: <4820272C.4060009@cn.fujitsu.com>
	<482027E4.6030300@cn.fujitsu.com>
	<482029E7.6070308@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 17:50:31 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Li Zefan wrote:
> > ---
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> Sorry for the noise, but the signed-off was eaten. :(
> Maybe I should leave a blank line before the signed-off.
> 
> ---
> 
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bdd5c43..d0ba10d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -303,7 +303,7 @@ static void destroy_compound_page(struct page *page, unsigned long order)
>  	for (i = 1; i < nr_pages; i++) {
>  		struct page *p = page + i;
>  
> -		if (unlikely(!PageTail(p) |
> +		if (unlikely(!PageTail(p) ||
>  				(p->first_page != page)))
>  			bad_page(page);
>  		__ClearPageTail(p);

I have a vague memory that the "|" was deliberate.  Most of the time,
"!PageTail" will be false so most of the time we won't take the first
branch so it's probably worth omitting it and always doing the pointer
comparison.

It's a somewhat dopey trick and shouldn't have been done without a comment.

otoh maybe it was a typo.
