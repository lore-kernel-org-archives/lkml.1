Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760808AbYLQMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbYLQMim (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbYLQMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:32:08 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38889 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbYLQMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:32:07 -0500
Date: Wed, 17 Dec 2008 07:32:04 -0500
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217123204.GO10590@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
References: <20081217001625.GA3250@x61> <20081217005210.GA889@dose.home.local> <20081217032517.GE10590@mit.edu> <20081217091003.GA26609@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217091003.GA26609@dose.home.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:10:03AM +0100, Tino Keitel wrote:
> On Tue, Dec 16, 2008 at 22:25:17 -0500, Theodore Tso wrote:
> 
> > I *thought* mutt had a patch which sorted the files returned by
> > readdir() by inode number, and then opened the files sorted by inode
> > number order; maybe it was a distro-specific patch that was never
> > pushed back to mainline, though.  In any case, sorting list of
> 
> It is in mutt upstream, and enabled by default, but only if
> maildir_header_cache_verify is set. If not, the inode list is kept
> unsorted. maildir_header_cache_verify is enabled by default, but I
> disabled it in my muttrc.

I just checked mutt 1.5.17 in Ubunty Hardy, and it sorts the inodes
even if maildir_header_cache_verify is unset.  (It sorts it earlier if
that option is set, but a little later in the function, if it wasn't
sorted earlier, it sorts it then.)  Check for calls to maildir_sort()
that use md_cmp_inode(); in my version of mutt, there are two such
calls in mh.c:maildir_delayed_parsing().

						- Ted
