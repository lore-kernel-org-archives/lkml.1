Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZLBNPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZLBNPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZLBNPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:15:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39984 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZLBNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:15:24 -0500
Date: Wed, 2 Dec 2009 14:15:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/24] HWPOISON: make it possible to unpoison pages
Message-ID: <20091202131530.GG18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043045.150526892@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043045.150526892@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that it may leak pages silently - those who have been removed from
> LRU cache, but not isolated from page cache/swap cache at hwpoison time.

It would be better if we could detect that somehow and at least warn.

>  }
>  
> +static int hwpoison_forget(void *data, u64 val)
> +{
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return forget_memory_failure(val);
> +}
> +
>  DEFINE_SIMPLE_ATTRIBUTE(hwpoison_fops, NULL, hwpoison_inject, "%lli\n");
> +DEFINE_SIMPLE_ATTRIBUTE(unpoison_fops, NULL, hwpoison_forget, "%lli\n");

I'll rename it to unpoison, not forget. I think that's a more clear
name.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
