Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0BWOby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:31:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab0BWObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:31:53 -0500
Message-ID: <4B83E6AC.8030306@redhat.com>
Date: Tue, 23 Feb 2010 09:31:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] vmscan: factor out page reference checks
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <1266868150-25984-2-git-send-email-hannes@cmpxchg.org> <1266932303.2723.13.camel@barrios-desktop> <20100223142158.GA29762@cmpxchg.org>
In-Reply-To: <20100223142158.GA29762@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 09:21 AM, Johannes Weiner wrote:

> From: Johannes Weiner<hannes@cmpxchg.org>
> Subject: vmscan: improve comment on mlocked page in reclaim
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>
> ---
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 674a78b..819fff7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -578,7 +578,10 @@ static enum page_references page_check_references(struct page *page,
>   	if (sc->order>  PAGE_ALLOC_COSTLY_ORDER)
>   		return PAGEREF_RECLAIM;
>
> -	/* Mlock lost isolation race - let try_to_unmap() handle it */
> +	/*
> +	 * Mlock lost the isolation race with us.  Let try_to_unmap()
> +	 * move the page to the unevictable list.
> +	 */
>   	if (vm_flags&  VM_LOCKED)
>   		return PAGEREF_RECLAIM;

Reviewed-by: Rik van Riel <riel@redhat.com>
