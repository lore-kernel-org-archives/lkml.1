Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYE3URn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYE3URn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYE3URf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:17:35 -0400
Received: from saeurebad.de ([85.214.36.134]:32888 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYE3URf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:17:35 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
References: <20080530194220.286976884@saeurebad.de>
	<20080530194739.417271003@saeurebad.de>
Date: Fri, 30 May 2008 22:16:56 +0200
In-Reply-To: <20080530194739.417271003@saeurebad.de> (Johannes Weiner's
	message of "Fri, 30 May 2008 21:42:31 +0200")
Message-ID: <87lk1rmts7.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Weiner <hannes@saeurebad.de> writes:

> The old node-agnostic code tried allocating on all nodes starting from
> the one with the lowest range.  alloc_bootmem_core retried without the
> goal if it could not satisfy it and so the goal was only respected at
> all when it happened to be on the first (lowest page numbers) node (or
> theoretically if allocations failed on all nodes before to the one
> holding the goal).
>
> Introduce a non-panicking helper that starts allocating from the node
> holding the goal and falls back only after all thes tries failed.
>
> Make all other allocation helpers benefit from this new helper.
>
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> CC: Andi Kleen <andi@firstfloor.org>
> ---
>
>  mm/bootmem.c |   77 +++++++++++++++++++++++++++++++----------------------------
>  1 file changed, 41 insertions(+), 36 deletions(-)
>
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -487,11 +487,33 @@ find_block:
>  		memset(region, 0, size);
>  		return region;
>  	}
> +	return NULL;
> +}

Sorry, forgot to update ->last_success handling here.  Update coming soon.

	Hannes
