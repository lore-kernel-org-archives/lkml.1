Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbZANAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbZANAXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759860AbZANAXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:23:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759732AbZANAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:23:12 -0500
Date: Tue, 13 Jan 2009 16:23:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: greg@kroah.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [0/7] Distributed storage for drivers/staging merge request
Message-Id: <20090113162307.3805ddc7.akpm@linux-foundation.org>
In-Reply-To: <20090114002008.GD512@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<20090113233932.GA18000@kroah.com>
	<20090113234734.GA32190@ioremap.net>
	<20090114000130.GA20811@kroah.com>
	<20090113161221.b23510b4.akpm@linux-foundation.org>
	<20090114001546.GC512@ioremap.net>
	<20090114002008.GD512@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 03:20:08 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> And while you at it, please shed a
> light on this exports for POHMELFS:
> 
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -513,6 +513,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
>  	}
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(add_to_page_cache_lru);

OK by me.

>  #ifdef CONFIG_NUMA
>  struct page *__page_cache_alloc(gfp_t gfp)
> @@ -627,6 +628,7 @@ int __lock_page_killable(struct page *page)
>  	return __wait_on_bit_lock(page_waitqueue(page), &wait,
>  					sync_page_killable, TASK_KILLABLE);
>  }
> +EXPORT_SYMBOL_GPL(__lock_page_killable);

Needed for modular use of lock_page_killable() - makes sense.

Please maintain these alongside the pohmelfs patchset.
