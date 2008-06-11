Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYFKSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYFKSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYFKSJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:09:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYFKSJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:09:11 -0400
Date: Wed, 11 Jun 2008 14:09:02 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2
Message-ID: <20080611140902.544e59ec@bree.surriel.com>
In-Reply-To: <200806101848.22237.nickpiggin@yahoo.com.au>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<200806101728.27486.nickpiggin@yahoo.com.au>
	<20080610013427.aa20a29b.akpm@linux-foundation.org>
	<200806101848.22237.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 18:48:21 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > The tmpfs PageSwapBacked stuff seems rather broken. For
> > > them write_begin/write_end path, it is filemap.c, not shmem.c,
> > > which allocates the page, so its no wonder it goes bug. Will
> > > try to do more testing without shmem.

Fun, so what does shmem_alloc_page do?

> > rikstuff.  Could be that the merge caused a problem?
> 
> Doesn't look like it, but I hadn't followed the changes too closely:
> rather they just need to test loopback over tmpfs.

Does loopback over tmpfs use a different allocation path?

> Is the plan to merge all reclaim changes in a big hit, rather than
> slowly trickle in the different independent changes?

My original plan was to merge them incrementally, but Andrew is
right that we should give the whole set as much testing as
possible.

I have done all the cleanups Andrew asked and fixed the bugs
that I found after that merge/cleanup.  Your bug is the one
I still need to fix before giving Andrew a whole new set of
split LRU patches to merge.

(afterwards, I will go incremental fixes only - the cleanups
he asked for were just too big to do as incrementals)

-- 
All rights reversed.
