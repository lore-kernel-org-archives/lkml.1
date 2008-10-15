Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYJOVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYJOVkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYJOVj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbYJOVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:39:56 -0400
Date: Wed, 15 Oct 2008 14:39:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: Re: [METAPATCH] mmotm: fix split-lru bisectability
Message-Id: <20081015143915.cc4395ed.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810140125550.29541@blonde.site>
References: <Pine.LNX.4.64.0810140125550.29541@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 01:32:18 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> There's an unbisectable 24-patch extent in the mmotm series, from
> define-page_file_cache-function to mlock-mlocked-pages-are-unevictable-fix:
> unbisectable because startup gets swamped by "Bad page state" messages
> (with three unrelated build errors and their fixes along the way).
> 
> These bad page states come from when Linus fasttracked the PAGE_FLAGS
> "cleanup" into 2.6.26, conflicting with PG_swapbacked patches already
> queued in -mm, and then the merge was botched.  We fixed up the end
> result at the time, but never got around to fixing the intermediates.
> It would be regrettable if this unbisectability were preserved in git.
> 
> To apply this metapatch, cd into mmotm's broken-out or patches directory
> (before define-page_file_cache-function has been applied), move series
> file there if it's kept elsewhere, apply metapatch with "patch -p1" (one
> file is deleted from series), then move back series file if necessary.
> 
> Based on mmotm .DATE=2008-10-10-19-22.  Doesn't bother to update the
> diffstats: I've tried to keep the diffs minimal, without all the noise
> which a quilt refresh here would have added.  So oddly I'm commenting
> out NORECL_PGRESCUED and NORECL_PGCULLED in one patch, then removing
> those lines in their fix patch - hmm, shouldn't they have got defined
> eventually, and that code restored?  End result is the same as mmotm,
> except that KOSAKI-San's page_referenced() args fix is included.
> 
> I'm pleased to say that checkpatch.pl reports that this metapatch
> has no obvious style problems and is ready for submission :-)
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  series                                                       |    1 
>  define-page_file_cache-function.patch                        |   26 +++++--
>  vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch  |    5 -
>  unevictable-lru-infrastructure.patch                         |   12 +--
>  unevictable-lru-infrastructure-defer-vm-event-counting.patch |    4 -
>  mlock-mlocked-pages-are-unevictable.patch                    |   24 -------
>  mlock-mlocked-pages-are-unevictable-fix.patch                |   33 ----------
>  7 files changed, 32 insertions(+), 73 deletions(-)

OK, thanks, I did that.  Fingers crossed..
