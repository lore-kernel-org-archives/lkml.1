Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZFXPcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZFXPcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbZFXPba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:31:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760055AbZFXPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:31:29 -0400
Date: Wed, 24 Jun 2009 08:30:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [merged]
 proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from
 -mm tree
Message-Id: <20090624083032.2d250488.akpm@linux-foundation.org>
In-Reply-To: <1245836005.32678.36.camel@wall-e>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	<1245824444.22613.3.camel@wall-e>
	<20090623233247.7ed661b7.akpm@linux-foundation.org>
	<1245825903.23818.4.camel@wall-e>
	<20090624001302.18de9e21.akpm@linux-foundation.org>
	<m1my7ykrs7.fsf@fess.ebiederm.org>
	<1245836005.32678.36.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 11:33:25 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> > > Alexey's point is that follow_page() will return NULL if it hits a
> > > swapped-out stack page and the loop will exit, leading to an incorrect
> > > (ie: short) return value from get_stack_usage_in_bytes().
> > >
> > > Is this claim wrong?
> > 
> 
> No.
> 
> I digged in the kernel source and the only solution i found is to use
> the walk_page_range() like show_smap() in proc/fs/task_mmu.c.
> 
> Maybe there is an easier way, but i dont know.
> 
> So i would implement a similar function like smaps_pte_range() in
> proc/fs/task_mmu.c to detected the high water usage.

Perhaps we could enhance follow_page() so that it can tell the caller
when the target page is "virtually there", but swapped out.  Add a new
FOLL_SWAP, I guess.


How to communicate this back to the caller?  Perhaps add another
argument to follow_page(), perhaps return some magic value such as

#define FOLLOW_PAGE_SWAPPED_PAGE ((struct page *)1)

Adding the additional argument would be nicer.
