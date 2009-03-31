Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbZCaGRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbZCaGRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZCaGR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:17:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45079 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbZCaGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:17:27 -0400
Date: Tue, 31 Mar 2009 07:16:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090331061615.GS28946@ZenIV.linux.org.uk>
References: <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903301506310.11454@blonde.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:32:35PM +0100, Hugh Dickins wrote:
> > Anyway, completely untested patchset is in
> > git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ execve-mess
> > (the last 9 changesets of it).
> > 
> > WARNING: that's *NOT* for merge at the moment; this is not a pull request.

> I'm looking now.  Your description of what you intended sounded good.
> 
> First impression is that there's lots of good cleanup in there, but
> it's all too mixed up and misordered at present - though we have friends
> who insist upon doing the cleanup first (and I usually like to work that
> way too), it's going to be tiresome when backporting to 2.6.29.stable
> (luckily not needed earlier, unless you've uncovered more on the way).

Yes, and worse than that; this was basically a code dump - the state at
the moment when I'd been going down.

> I think your new chroot_fs_refs() should have a path_get(new_root)
> just before each path_put(old_root)?

Not just before; at the time it replaces ->root or ->pwd.  And yes,
it's one of the brainos there.

Anyway, I've got that stuff to something reasonably-looking.  See the
same branch (rebased), just 5 changesets now.  Have fun.  Cleanups are
not part of that set.
