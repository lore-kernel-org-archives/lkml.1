Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbYBLBhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbYBLBhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYBLBhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:37:05 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55438 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbYBLBhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:37:03 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 19:36:49 -0600
Message-Id: <1202780209.3122.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 12:02 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Andrew was looking for someone to run a linux-next tree that just
> contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> moment of madness) volunteered.  So, this is to announce the creating of
> such a tree (it doesn't exist yet) which will require some (hopefully)
> small amount of work on the part of subsystem maintainers.

Actually, it sort of does.  If you look here:

http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree/

You'll find a merge candidate tree that builds nightly from everyone's
git and quilt trees.  I'm using it to track merge conflicts (so I only
build the patch, I don't check it compiles).

You're welcome to the scripts that do this:

http://www.kernel.org/pub/linux/kernel/people/jejb/build.pl

And the config file that runs it:

http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree-build

I don't plan to do much more than keep it building to check conflicts,
so you're welcome to take it over.

> Those interested in discussion about this are encouraged to join the
> linux-next@vger.kernel.org mailing list.
> 
> The first things I need from the subsystem maintainers (you know who you
> are) are a contact address (a list address is fine) and at least one git
> branch or quilt series that contains all the things you want to see go
> into 2.6.26.  I am happy for there to be multiple branches/series (in
> fact there probably will need to be in some cases where there are
> dependencies on others work).
> 
> The tree will be based on the current version of Linus' tree but you may
> specify an earlier branch point if you need to (hopefully not - but more
> likely for quilters, I guess).
> 
> I hope to recreate this tree every day automatically.  In order to do
> this, any tree that has a conflict will be dropped from that days tree.
> The maintainer will be notified.  I hope to provide some clue as to what
> the conflict is with, but probably not initially.

Actually the experiment with the -mc tree shows that most of the
conflicts are trivial in nature (usually docbook stuff or
feature-removal.txt stuff), so you can do a trivial triage by hand.  You
can't automatically drop them (well, not unless you want to end up
dropping half the trees).

The other problem is that we actually maintain deliberate conflicts with
a last person to merge fixes it type attitude.  Again, it's usually in
minor areas, and the fixups are fairly trivial, but it illustrates why
conflicts can't be a reason to drop a tree, you have to maintain some
sort of automatic fixup (at least I had to with the -mc tree).  The
reason we do this is that it would give the maintainers a nasty web of
included trees (which is almost impossible for the quilt trees anyway)
if we tried to resolve the conflicts and destroy our ability to rebase.

> I will attempt to build the tree between each merge (and a failed build
> will again cause the offending tree to be dropped).  These builds will be
> necessarily restricted to probably one architecture/config.  I will build
> the entire tree on as many architectures/configs as seem sensible and
> the results of that will be available on a web page (to be announced).

Yes, this is the bit I've never dared do ... principally because it's
such a time sink.

James


