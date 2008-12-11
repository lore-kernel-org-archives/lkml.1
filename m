Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYLKRoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYLKRoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYLKRoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:44:10 -0500
Received: from kroah.org ([198.145.64.141]:44310 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756622AbYLKRoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:44:09 -0500
Date: Thu, 11 Dec 2008 08:32:26 -0800
From: Greg KH <greg@kroah.com>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
       linux kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-ext4@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [stable] [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-ID: <20081211163226.GA15057@kroah.com>
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081207204222.d811c00b.akpm@linux-foundation.org> <1228758923.7096.10.camel@mingming-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1228758923.7096.10.camel@mingming-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 09:55:23AM -0800, Mingming Cao wrote:
> 在 2008-12-07日的 20:42 -0800，Andrew Morton写道：
> > (cc stable)
> > 
> > On Sun, 7 Dec 2008 10:28:21 -0500 Theodore Tso <tytso@mit.edu> wrote:
> > 
> > > On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> > > > 
> > > > I suggest that what we do is to revert both those changes.  We can
> > > > worry about the possibly-unneeded spin_lock later, in a separate patch.
> > > > 
> > > > It should have been a separate patch anyway.  It's conceptually
> > > > unrelated and is not a bugfix, but it was mixed in with a bugfix.
> > > > 
> > > > Mingming, this needs urgent consideration, please.  Note that I had to
> > > > make additional changes to ext4 due to the subsequent introduction of
> > > > the dirty_blocks counter.
> > > 
> > > I've looked the two patches which you've queued in the -mm branch, and
> > > they look correct to me.
> > > 
> > > The bugs fixed by these patches can potentially lead to filesystem
> > > corruption, since we ultimately use these fields to set the superblock
> > > values.  This in my mind makes them stable candidates at the very
> > > least, and if we weren't so late in the 2.6.28 cycle, I'd be strongly
> > > tempted to push them to Linus as a bugfix before the merge window.
> > > 
> > > Andrew, any strong objections for me to grab them for the ext4 tree?
> > > Or would you rather carry them?  I would prefer that they get pushed
> > > to Linus as soon as the merge window opens, which is one reason why
> > > I'd prefer carry them, but we can do this either way.
> > > 
> > 
> > I'm planning on sending them off to Linus for 2.6.28 this week,
> > assuming nobody can think of a plausible reason to not do that.
> > 
> > Now I didn't look _very_ closely at the chronology, but I think that
> > revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch reverts
> > a post-2.6.27 change, and is not needed in stable.
> > 
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > however reverts a pre-2.6.27 change, and should be merged into 2.6.27. 
> > This patch reverts the addition and use of
> > percpu_counter_sum_and_set(), which is racy and can corrupt the
> > counters.
> > 
> > However
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > won't apply to 2.6.27 because the dirty_blocks stuff was added and
> > generates rejects.
> > 
> > So if all the above is correct, I'd propose that if and when
> > revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
> > hits mainline, we should ask the -stable guys to directly revert 
> > 
> 
> Agreed.
> 
> I checked 2.6.27.8, above are correct, the
> revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch is not
> needed for 2.6.27.x stable tree.

Thanks for letting me know, I'll not include it in the 2.6.27-stable
tree then.

greg k-h
