Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZALWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZALWIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZALWGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:06:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbZALWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:06:08 -0500
Date: Mon, 12 Jan 2009 14:06:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090112140606.cd6f208c.akpm@linux-foundation.org>
In-Reply-To: <200901052328.26630.nickpiggin@yahoo.com.au>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<200901052328.26630.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 23:28:26 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 05 January 2009 19:43:00 Andrew Morton wrote:
> > The individual patches are mostly at
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/
> >
> >
> > mm-remove-the-might_sleep-from-lock_page.patch
> >
> >   Need to think about this.
> 
> Removing this reduces a lot of might_sleep coverage scope. Page
> lock isn't contended in a lot of cases. Why would you drop a
> good debugging feature?

For the reasons described in the changelog, of course.

http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-remove-the-might_sleep-from-lock_page.patch

> > mm-direct-io-starvation-improvement.patch
> > fs-remove-wb_sync_hold.patch
> > fs-sync_sb_inodes-fix.patch
> > fs-sys_sync-fix.patch
> > radix-tree-gang-set-if-tagged-operation.patch
> 
> This one is unneeded because you didn't take the fsync livelock avoidance
> patch that makes use of the new function.

OK

> > make-sure-nobodys-leaking-resources.patch
> > releasing-resources-with-children.patch
> 
> Any reason why not to add these upstream?

Dunno.  Are they valuable?  I've never had a report of them triggering,
I don't think.

> > nr_blockdev_pages-in_interrupt-warning.patch
> 
> Lockdep should catch this, I guess.

Yup.  I forget why I added it.

> > put_bh-debug.patch
> 
> This could just be implemented with a VM_BUG_ON (or FS_BUG_ON) like the
> pagecache refcounting. Wouldn't be a bad idea.

yup, I guess so.  Again, no reports of it triggering in ages.

> > add-a-refcount-check-in-dput.patch
> 
> Again, why not an FS_BUG_ON for things like this too?

Ditto.
