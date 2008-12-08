Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbYLHRzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbYLHRzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 12:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLHRza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 12:55:30 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34910 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYLHRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:55:29 -0500
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Mingming Cao <cmm@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-ext4@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20081207204222.d811c00b.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081207204222.d811c00b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Mon, 08 Dec 2008 09:55:23 -0800
Message-Id: <1228758923.7096.10.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2008-12-07日的 20:42 -0800，Andrew Morton写道：
> (cc stable)
> 
> On Sun, 7 Dec 2008 10:28:21 -0500 Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> > > 
> > > I suggest that what we do is to revert both those changes.  We can
> > > worry about the possibly-unneeded spin_lock later, in a separate patch.
> > > 
> > > It should have been a separate patch anyway.  It's conceptually
> > > unrelated and is not a bugfix, but it was mixed in with a bugfix.
> > > 
> > > Mingming, this needs urgent consideration, please.  Note that I had to
> > > make additional changes to ext4 due to the subsequent introduction of
> > > the dirty_blocks counter.
> > 
> > I've looked the two patches which you've queued in the -mm branch, and
> > they look correct to me.
> > 
> > The bugs fixed by these patches can potentially lead to filesystem
> > corruption, since we ultimately use these fields to set the superblock
> > values.  This in my mind makes them stable candidates at the very
> > least, and if we weren't so late in the 2.6.28 cycle, I'd be strongly
> > tempted to push them to Linus as a bugfix before the merge window.
> > 
> > Andrew, any strong objections for me to grab them for the ext4 tree?
> > Or would you rather carry them?  I would prefer that they get pushed
> > to Linus as soon as the merge window opens, which is one reason why
> > I'd prefer carry them, but we can do this either way.
> > 
> 
> I'm planning on sending them off to Linus for 2.6.28 this week,
> assuming nobody can think of a plausible reason to not do that.
> 
> Now I didn't look _very_ closely at the chronology, but I think that
> revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch reverts
> a post-2.6.27 change, and is not needed in stable.
> 
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> however reverts a pre-2.6.27 change, and should be merged into 2.6.27. 
> This patch reverts the addition and use of
> percpu_counter_sum_and_set(), which is racy and can corrupt the
> counters.
> 
> However
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> won't apply to 2.6.27 because the dirty_blocks stuff was added and
> generates rejects.
> 
> So if all the above is correct, I'd propose that if and when
> revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> hits mainline, we should ask the -stable guys to directly revert 
> 

Agreed.

I checked 2.6.27.8, above are correct, the
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch is not
needed for 2.6.27.x stable tree.

Thanks again.

Mingming
>     commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
>     Author: Mingming Cao <cmm@us.ibm.com>
>     Date:   Fri Jul 11 19:27:31 2008 -0400
> 
>         percpu_counter: new function percpu_counter_sum_and_set
> 
> which should be all that 2.6.27.x needs.
> 
> Agree?  If so, can you please take care of getting that patch over to
> stable@kernel.org?  (I added the cc:stable to the diff, so there's
> probably nothing which you need to do..)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

