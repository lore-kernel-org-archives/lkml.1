Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKGOez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKGOez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYKGOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:34:44 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36283 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751760AbYKGOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:34:43 -0500
Date: Fri, 7 Nov 2008 09:34:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes
Message-ID: <20081107143440.GC9543@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1KyDvc-0007hT-I6@closure.thunk.org> <alpine.LFD.2.00.0811061647130.3451@nehalem.linux-foundation.org> <20081107033315.GB29038@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107033315.GB29038@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 10:33:15PM -0500, Theodore Tso wrote:
> > 
> > Nothing there. Forgot to push out?
> 
> Whoops, sorry.  Just pushed to master.
> 

I see you haven't pulled from it the ext4 tree yet.  In the meantime,
two more bug fixes, one which fixes a rather nasty mmap corruption bug
in low memory situations have come in, so I've updated the repository
to include two more patches.  So for_linus has two more patches than
it does previously.

If you've already pulled from the for_linus branch, by the time read
this, please pull again to get the two commits marked with an '*':

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

						- Ted

Aneesh Kumar K.V (3):
      ext4: fix missing ext4_unlock_group in error path
      ext4: Convert to host order before using the values.
    * ext4: Mark the buffer_heads as dirty and uptodate after prepare_write

Frederic Bohe (1):
    * ext4: add checksum calculation when clearing UNINIT flag in ext4_new_inode

Sami Liedes (1):
      jbd2: deregister proc on failure in jbd2_journal_init_inode

Theodore Ts'o (4):
      jbd: don't give up looking for space so easily in __log_wait_for_space
      jbd2: don't give up looking for space so easily in __jbd2_log_wait_for_space
      ext4: wait on all pending commits in ext4_sync_fs()
      ext4: calculate journal credits correctly

 fs/ext4/ialloc.c     |    2 ++
 fs/ext4/inode.c      |    7 +++++--
 fs/ext4/mballoc.c    |    1 +
 fs/ext4/super.c      |   24 ++++++++++--------------
 fs/jbd/checkpoint.c  |   31 ++++++++++++++++++++++++-------
 fs/jbd2/checkpoint.c |   32 +++++++++++++++++++++++++-------
 fs/jbd2/journal.c    |    2 ++
 7 files changed, 69 insertions(+), 30 deletions(-)
