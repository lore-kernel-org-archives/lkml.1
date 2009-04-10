Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZDJCRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZDJCRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZDJCR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:17:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48260 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZDJCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:17:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Grover <andy.grover@oracle.com>
Subject: Re: [PATCH 1/1] Document get_user_pages_fast()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       mingo@redhat.com, npiggin@suse.de, akpm@linux-foundation.org
In-Reply-To: <1239324283-4279-1-git-send-email-andy.grover@oracle.com>
References: <1239324283-4279-1-git-send-email-andy.grover@oracle.com>
Message-Id: <20090410110626.7931.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 10 Apr 2009 11:17:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * get_user_pages_fast() - pin user pages in memory
> + * @start:	starting user address
> + * @nr_pages:	number of pages from start to pin
> + * @write:	whether pages will be written to
> + * @pages:	array that receives pointers to the pages pinned.
> + *		Should be at least nr_pages long.
> + *
> + * Attempt to pin user pages in memory without taking mm->mmap_sem.
> + * If not successful, it will fall back to taking the lock and
> + * calling get_user_pages().
> + *
> + * Returns number of pages pinned. This may be fewer than the number
> + * requested. If nr_pages is 0 or negative, returns 0. If no pages
> + * were pinned, returns -errno.
> + */
>  int __attribute__((weak)) get_user_pages_fast(unsigned long start,
>  				int nr_pages, int write, struct page **pages)
>  {

There is one problem.
gup and get_page() don't provide any page pinning.

get_page() only gurantee not freed. but don't gurantee to prevent page
reclaim and Cow change owner process.

Yes, current all gup caller have serious bug. especially direct-io, aio, bio
are broken.





