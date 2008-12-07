Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYLGUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYLGUcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYLGUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:32:07 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41295 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753174AbYLGUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:32:04 -0500
Date: Sun, 7 Dec 2008 10:28:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-ID: <20081207152821.GA9596@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
> 
> I suggest that what we do is to revert both those changes.  We can
> worry about the possibly-unneeded spin_lock later, in a separate patch.
> 
> It should have been a separate patch anyway.  It's conceptually
> unrelated and is not a bugfix, but it was mixed in with a bugfix.
> 
> Mingming, this needs urgent consideration, please.  Note that I had to
> make additional changes to ext4 due to the subsequent introduction of
> the dirty_blocks counter.

I've looked the two patches which you've queued in the -mm branch, and
they look correct to me.

The bugs fixed by these patches can potentially lead to filesystem
corruption, since we ultimately use these fields to set the superblock
values.  This in my mind makes them stable candidates at the very
least, and if we weren't so late in the 2.6.28 cycle, I'd be strongly
tempted to push them to Linus as a bugfix before the merge window.

Andrew, any strong objections for me to grab them for the ext4 tree?
Or would you rather carry them?  I would prefer that they get pushed
to Linus as soon as the merge window opens, which is one reason why
I'd prefer carry them, but we can do this either way.

        	   	       	      	     - Ted
