Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbZDJDQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbZDJDQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762438AbZDJDQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:16:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762332AbZDJDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:16:30 -0400
Date: Thu, 9 Apr 2009 20:13:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andy Grover <andy.grover@oracle.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, npiggin@suse.de
Subject: Re: [PATCH 1/1] Document get_user_pages_fast()
Message-Id: <20090409201309.db1c2c52.akpm@linux-foundation.org>
In-Reply-To: <20090410110626.7931.A69D9226@jp.fujitsu.com>
References: <1239324283-4279-1-git-send-email-andy.grover@oracle.com>
	<20090410110626.7931.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 11:17:22 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > +/**
> > + * get_user_pages_fast() - pin user pages in memory
> > + * @start:	starting user address
> > + * @nr_pages:	number of pages from start to pin
> > + * @write:	whether pages will be written to
> > + * @pages:	array that receives pointers to the pages pinned.
> > + *		Should be at least nr_pages long.
> > + *
> > + * Attempt to pin user pages in memory without taking mm->mmap_sem.
> > + * If not successful, it will fall back to taking the lock and
> > + * calling get_user_pages().
> > + *
> > + * Returns number of pages pinned. This may be fewer than the number
> > + * requested. If nr_pages is 0 or negative, returns 0. If no pages
> > + * were pinned, returns -errno.
> > + */
> >  int __attribute__((weak)) get_user_pages_fast(unsigned long start,
> >  				int nr_pages, int write, struct page **pages)
> >  {
> 
> There is one problem.
> gup and get_page() don't provide any page pinning.
> 
> get_page() only gurantee not freed. but don't gurantee to prevent page
> reclaim

is_page_cache_freeable() measures page_count()...

> and Cow change owner process.

hm.  buggy userspace? Why is that a problem from a kernel perspective?

> Yes, current all gup caller have serious bug. especially direct-io, aio, bio
> are broken.
> 
> 
> 
> 
