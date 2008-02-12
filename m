Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYBLBCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYBLBCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbYBLBCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:02:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760740AbYBLBCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:02:16 -0500
Date: Tue, 12 Feb 2008 12:02:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080212120208.f7168a91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Feb_2008_12_02_08_+1100_V9FK6sIE2SsyyY+v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2008_12_02_08_+1100_V9FK6sIE2SsyyY+v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Andrew was looking for someone to run a linux-next tree that just
contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
moment of madness) volunteered.  So, this is to announce the creating of
such a tree (it doesn't exist yet) which will require some (hopefully)
small amount of work on the part of subsystem maintainers.

Those interested in discussion about this are encouraged to join the
linux-next@vger.kernel.org mailing list.

The first things I need from the subsystem maintainers (you know who you
are) are a contact address (a list address is fine) and at least one git
branch or quilt series that contains all the things you want to see go
into 2.6.26.  I am happy for there to be multiple branches/series (in
fact there probably will need to be in some cases where there are
dependencies on others work).

The tree will be based on the current version of Linus' tree but you may
specify an earlier branch point if you need to (hopefully not - but more
likely for quilters, I guess).

I hope to recreate this tree every day automatically.  In order to do
this, any tree that has a conflict will be dropped from that days tree.
The maintainer will be notified.  I hope to provide some clue as to what
the conflict is with, but probably not initially.

I will attempt to build the tree between each merge (and a failed build
will again cause the offending tree to be dropped).  These builds will be
necessarily restricted to probably one architecture/config.  I will build
the entire tree on as many architectures/configs as seem sensible and
the results of that will be available on a web page (to be announced).

This is just a start ...

Comments?

[I suspect that Andrew's dream includes actual time to dream :-)]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

For reference - Andrew's original musings:

I perceive the following problems with kernel development:

- The 80-odd subsystem trees are developed in isolation, leading to

  - large numbers of patch-time conflicts when I merge them all

  - large numbers of compile-time problems

  - occasional runtime problems as a result of the merging

  This is largely because the subsystem tree owners aren't being
  particularly disciplined in keeping their changes contained to their area=
 of
  responsibility.

- It's a large amount of work to merge all the trees and it is very dull.=20
  This is the main reason why -mm releases are down to one every few weeks
  rather than the old two or more per week.

- Those few -mm releases have a large number of regressions

- Developers aren't particularly responsive in handling those regression
  reports.

- Mainline kernel releases also have a large number of regressions: ones
  which are leaking through the -mm process.

- Very few kernel developers actually bother testing the -mm tree.=20

  - Consequently most code hits mainline without its submitter having done
    much testing of the resulting code combination.

  - Few kernel developers are testing other kernel developers' development
    code.

- Practically the only public testing which the various trees obtain is via
  the -mm process, and that process is collapsing for the above reasons.

- People who develop against a particular tree are not spending sufficient
  time reviewing and testing changes which other developers are committing =
to
  other trees.

- People who raise patches are preparing them against Linus's tree.  But by
  the time we get into the late -rc timeframe, Linus's tree is very differe=
nt
  from the accumulated pending trees.  So many patches fail to apply, or do=
n't
  work correctly and the originator runtime tested them against Linus's tre=
e,
  not against the tree into which they are to be merged.

- Developers are sneaking patches into the mainline merge window at the last
  minute, before they have had a decent period of review and testing.



So what I propose is that we start a formal unified development tree (called
the "linux-next" tree).  It will probably have the following characteristic=
s:

- Once per day it merges all the subsystem trees: 75 git trees, 5-10 quilt
  trees.

- It will need to run compilation tests after applying each tree

  It's unreasonable to do randconfig on arch/kooky-arch/ during linux-next's
  integration, but a basic x86_64 allmodconfig would be good: something whi=
ch
  is well-known by the subsystem maintainers so they can check that it will
  work.

- It will send status messages to a new mailing list and also to individual
  developers when something goes wrong.

- There are several trees which are overtly cross-subsystem and which might
  not fit into this model: mainly the driver tree, the -mm tree and perhaps
  the PCI tree.

  otoh, a lot of the -mm queue is _not_ cross-subsystem: fbdev, uml, various
  new drivers and features, etc.  So I'll need to split -mm into multiple
  queues and feed many of them into linux-next.

- Advanced topic: mechanisms will be put in place to detect a patch which
  hasn't been in linux-next for "long enough".  These patches will be flagg=
ed
  for extra consideration when offered for a mainline merge.

- Note that James is already running a cut-down version of this.  See
  http://lkml.org/lkml/2008/1/17/481



Once the linux-next tree is up and running and is reliable and useful, I wo=
uld
like to see the following policies implemented around it:

- If a tree doesn't automerge it is dropped and a notification is sent

- If a tree breaks the build it is dropped and a notification is sent

- If a tree's server cannot be contacted (a fairly regular event) it is
  dropped and a notification is sent

- If a tree is causing runtime problems (ie: regressions) which impact
  testing of the whole and those problems are not getting appropriately
  resolved, the tree is dropped.  (This will require manual intervention and
  visible decision-making).

- If a tree was dropped for N% of the M days before 2.6.x is released, that
  tree is ineligible for a 2.6.x+1 merge.  This is for good software
  engineering reasons, and to provide an incentive for developers to pay mo=
re
  attention to integration and testing issues.



Other:

- The -mm tree will become a much smaller patchset, based on linux-next.

- People can set up linux-next cross-compilation farms on external servers.=
=20
  Compilation errors can be fed back as regular bug reports.



Advantages:

- Will lead to kernel developers testing (and hopefully reviewing) each
  others code more

- Will lead to kernel developers paying more attention to integration issues

- I expect that tree-owners will be a bit more careful about what they check
  into their trees, knowing that it'll go straight into linux-next.

- Less bugs will hit Linus's tree:

  - I expect we will get a lot of public testing of the linux-next tree

  - Most kernel developers will also need to test linux-next, as that is
    the tree they're integrating into.  And kernel developers are the best
    testers, bug-reporters and bug-fixers.

- It will give me far more time to do useful things like testing, bugfixing
  and reviewing.  Particularly because I don't intend to be the person who
  operates linux-next.

- Patch submitters can now prepare and test against the linux-next tree
  rather than against the relatively out-of-date mainline tree.



Disadvantages

- More work for subsystem maintainers.

  But I don't think it's wasted time - it's largely work which would have
  needed to be done later anyway.

  If the subsystem maintainer is merging non-buggy patches and is staying
  strictly within area-of-responsibility then there should be close to zero
  extra work.

- Subsystem maintainers will need new strategies for those patches which
  touch other subsystems.

  - Ask submitters to split things up better (not a bad thing)

  - Arrange for interface changes to be implemented in a
    temporarily-back-compatible manner if poss (also not a bad thing).

  - Send some patches over to other subsystem maintainers rather than
    merging them locally (also not a bad thing).

- Subsystem maintainers will discover that getting other subsystem
  maintainers to look at and merge their patches can be a right royal pita.=
=20
  Trust me.

  It is inefficient to have 80 subsystem maintainers re-re-re-sending
  patches at each other.

  - People can copy me on them and I can do the re-re-re-send for them,
    while including the patches in the linux-next lineup.

  - Or the subsystem maintainer can set up a standalone "patches from Tom
    to Dick" tree, and include that in the linux-next lineup (staged after
    Dick's tree) until Dick wakes up and merges it.



Open issues:

  I don't want to over-design this at this stage.  This hasn't been done
  before and I'd expect the linux-next owner would be the person who
  encounters and solves most of the problems which crop up.  But I do
  anticipate a few issues:

- Tree prioritisation.  Often, two trees will collide.  Say, git-net and
  git-nfs.  If this happens, which tree will be autodropped?

  I'd suggest that we'll just need to make decisions about which tree is
  most important, and stage that tree ahead of less important ones.

- I'd expect subsystem tree maintainers to decide to start running multiple
  trees (like Jeff's "topic branches").  This way, if there are collisions =
or
  other failures, then not all of their work is dropped.

- Also, a subsystem tree maintainer may have some changes which are
  considered likely to collide with other people's work.  These can be plac=
ed
  in a best-effort standalone branch which is staged late in the linux-next
  merging order and if it breaks, well, no great loss.

- A consequence of all the above is that it should be easy for subsystem
  tree maintainers to add new trees to linux-next, and for them to decide
  where in the merging order those trees are staged.

  They won't want to have to send an email to another developer for this -
  each tree-owner will need the ability to add trees with no turnaround del=
ay.

  - This could be implemented with a world-writeable control file on
    kernel.org

  - Or a world-writeable directory on kernel.org with control files which
    start with a six-digit number

  - Or some fancy web interface or command-line tool on kernel.org

  - Or whatever.

- The need to perform compilation testing at merge-time might cause overload
  at kernel.org, so an upgraded or alternative server might be needed.

  And experience tells me that we _will_ need to perform compilation
  testing.

  I'm assuming that compilation testing will be a linear search: once per
  tree.  One could do bisection searching, but a) that gets tricky when more
  than one tree has a failure and b) it probably means that the whole tree
  needs to be re-merged once the offending tree has been weeded out.

- Ideally, all the subsystem trees are standalone and can be merged by Linus
  in any order.  There will be _some_ trees which are dependent upon other
  subsystem trees, but these are special cases and can be handled by staging
  them late in the linux-next merging order, and by not merging them in
  mainline until the prerequisites are merged.

  Obviously, the safest approach would be to merge trees into mainline in
  the same order as they are merged into linux-next, but this is probably
  impractical.

--Signature=_Tue__12_Feb_2008_12_02_08_+1100_V9FK6sIE2SsyyY+v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsPAVTgG2atn1QN8RAvQ1AKCZQIXxZt/oHKhBSuGw5aS0gSG0VwCfcrDW
eQ5l2QYsa++iA/a/V29O3/I=
=5t5k
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2008_12_02_08_+1100_V9FK6sIE2SsyyY+v--
