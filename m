Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZFXP6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZFXP6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZFXP6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:58:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:54132 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZFXP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:58:04 -0400
Subject: Re: [merged]
 proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from
 -mm tree
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090624083032.2d250488.akpm@linux-foundation.org>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	 <1245824444.22613.3.camel@wall-e>
	 <20090623233247.7ed661b7.akpm@linux-foundation.org>
	 <1245825903.23818.4.camel@wall-e>
	 <20090624001302.18de9e21.akpm@linux-foundation.org>
	 <m1my7ykrs7.fsf@fess.ebiederm.org> <1245836005.32678.36.camel@wall-e>
	 <20090624083032.2d250488.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 17:57:48 +0200
Message-Id: <1245859068.13531.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 24.06.2009, 08:30 -0700 schrieb Andrew Morton:
> On Wed, 24 Jun 2009 11:33:25 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > > > Alexey's point is that follow_page() will return NULL if it hits a
> > > > swapped-out stack page and the loop will exit, leading to an incorrect
> > > > (ie: short) return value from get_stack_usage_in_bytes().
> > > >
> > > > Is this claim wrong?
> > > 
> > 
> > No.
> > 
> > I digged in the kernel source and the only solution i found is to use
> > the walk_page_range() like show_smap() in proc/fs/task_mmu.c.
> > 
> > Maybe there is an easier way, but i dont know.
> > 
> > So i would implement a similar function like smaps_pte_range() in
> > proc/fs/task_mmu.c to detected the high water usage.
> 
> Perhaps we could enhance follow_page() so that it can tell the caller
> when the target page is "virtually there", but swapped out.  Add a new
> FOLL_SWAP, I guess.
> 

I currently fixed it by using walk_page_range(). I think this is a quiet
good solution. But if you like i can do it in a future version.

> How to communicate this back to the caller?  Perhaps add another
> argument to follow_page(), perhaps return some magic value such as
> 
> #define FOLLOW_PAGE_SWAPPED_PAGE ((struct page *)1)
> 
> Adding the additional argument would be nicer.

IMHO i think it would be the best to add a new FOLL_NOTIFY_SWAP flag and
if the page is swapped out return the FOLLOW_PAGE_SWAPPED_PAGE magic if
this flag is passed.


