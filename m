Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbXCWBB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbXCWBB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934259AbXCWBB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:01:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934258AbXCWBB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:01:28 -0400
Date: Thu, 22 Mar 2007 17:01:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-Id: <20070322170122.ee2589a1.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 17:51:11 -0700 "Ken Chen" <kenchen@google.com> wrote:

> +#ifdef CONFIG_HIGHMEM
> +#define pipe_kmap		kmap
> +#define pipe_kmap_atomic	kmap_atomic
> +#else	/* CONFIG_HIGHMEM */
> +static inline void *pipe_kmap(struct page *page)
> +{
> +	return (void *) page->private;
> +}
> +static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
> +{
> +	pagefault_disable();
> +	return pipe_kmap(page);
> +}
> +#endif

If we're going to do this then we should also implement pipe_kunmap_atomic().
Relying upon kunmap_atomic() internals like this is weird-looking, and is fragile
against future changes to kunmap_atomic().
