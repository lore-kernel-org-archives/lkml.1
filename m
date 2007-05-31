Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbXEaTwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbXEaTwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbXEaTwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:52:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbXEaTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:52:15 -0400
Date: Thu, 31 May 2007 12:51:33 -0700
From: Zach Brown <zach.brown@oracle.com>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 2/4] CONFIG_STABLE: Switch off kmalloc(0) tests in slab allocators
Message-ID: <20070531195133.GK5488@mami.zabbo.net>
References: <20070531002047.702473071@sgi.com> <20070531003012.532539202@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531003012.532539202@sgi.com>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifndef CONFIG_STABLE
>  	/*
>  	 * We should return 0 if size == 0 (which would result in the
>  	 * kmalloc caller to get NULL) but we use the smallest object
> @@ -81,6 +82,7 @@ static inline int kmalloc_index(size_t s
>  	 * we can discover locations where we do 0 sized allocations.
>  	 */
>  	WARN_ON_ONCE(size == 0);
> +#endif

> +#ifndef CONFIG_STABLE
>  	WARN_ON_ONCE(size == 0);
> +#endif

I wonder if there wouldn't be value in making a WARN_*() variant that
contained the ifdef internally so we could lose these tedious
surrounding ifdefs in call sites.  WARN_DEVELOPER_WHEN(), or something.
I don't care what it's called.  

- z 
