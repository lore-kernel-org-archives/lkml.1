Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698Ab0ALXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0ALXWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157Ab0ALXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:22:19 -0500
Received: from sous-sol.org ([216.99.217.87]:51492 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754087Ab0ALXWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:22:18 -0500
Date: Tue, 12 Jan 2010 15:21:45 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v4][RESENT] add MAP_UNLOCKED mmap flag
Message-ID: <20100112232145.GA10576@sequoia.sous-sol.org>
References: <20100112145144.GQ7549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112145144.GQ7549@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gleb Natapov (gleb@redhat.com) wrote:
>  v3->v4
>   - return error if MAP_LOCKED | MAP_UNLOCKED is specified
...
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -962,6 +962,12 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  		if (!can_do_mlock())
>  			return -EPERM;
>  
> +        if (flags & MAP_UNLOCKED)
> +                vm_flags &= ~VM_LOCKED;
> +
> +        if (flags & MAP_UNLOCKED)
> +                vm_flags &= ~VM_LOCKED;
> +
>  	/* mlock MCL_FUTURE? */
>  	if (vm_flags & VM_LOCKED) {
>  		unsigned long locked, lock_limit;

Looks like same patch applied twice rather than adding the
(MAP_LOCKED | MAP_UNLOCKED) check.
