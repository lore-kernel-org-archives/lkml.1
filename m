Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYCSTpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYCSTpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYCSTbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:06 -0400
Received: from phunq.net ([64.81.85.152]:46290 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755331AbYCSTbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:31:03 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] ddtree: A git kernel tree for storage servers
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 19 Mar 2008 00:02:24 -0800
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803190102.25491.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have set up a new git tree to better serve the needs of those 
interested in advanced storage applications and development.

This ddtree git repository aims to provide a congenial forum for 
development of forward looking storage features such as replication and 
clustering; and to provide improved kernels for those who consider it 
important that their storage servers run efficiently under heavy load
without deadlocking.

What will be in this ddtree?

  * Block layer deadlock fixes (Status: production)
  * bio allocation optimizations (Status: functional)
  * bio support for stacking block devices (Status: functional)
  * vm dirty limit eradication (Status: prototype)
  * vm dirty rate balancing (Status: prototype)
  * ddlink generic device driver control library (Status: functional)
  * ddsetup device mapper frontend rewrite (Status: incomplete)
  * ddman kernel cluster harness (Status: upcoming)
  * ddraid distributed raid (Status: prototype)
  * ddsnap replicating snapshot device (Status: alpha)

Patch set tracking

One task that git does not support well at all is maintaining the 
identity of patches and patch sets.  This is no doubt due to the fact 
that Graydon Hoare[1] never implemented the second of my two 
suggestions for improving Monotone's database schema[2], which is to 
say that patches and patch sets should be first class, versioned 
objects in the revision control database.  One could fairly say that 
git caters more to maintainers than submitters, the latter being 
largely left to their own devices when it comes to splitting deltas up 
into the modular form wanted for peer review.  My partial solution to 
this deficiency is to embed the interesting patches in a directory 
called "patches", each named in such a way that:

   ls patches/* | sort -r | xargs cat | patch -p1 -RE

will reverse them, and:

   cat patches/* | patch -p1

will re-apply them.  This is similar to the way Quilt works, less its 
series file, which is replaced by a naming convention that is obvious 
from inspection.  No doubt I should really begin using Quilt, but I can 
always learn that art later.  For now, the important thing is to carry 
along patch identities in a way that makes life easier for me.

At present, ddtree only carries six patches, all in its main "dd" 
branch.  These patches are based off of the "ddbase" branch, which is 
in turn derived from either a two-dot or a three-dot stable kernel 
release.  Thus, I intend to track Linus's tree at coarse intervals and 
selected stable releases at finer intervals, which will most likely
coincide with  significant distributor branch points such as that of
Ubuntu Hardy (long term stable server release).

So for today:

   $ tree patches
   patches
   |-- bio-alloc
   |-- bio-alloc-hide-endio
   |-- bio-alloc-stack
   |-- bio-alloc-stack-reduce-dm-allocs
   |-- ddlink
   `-- ddlink-ddsetup

Other patches expected to land here over the next few days:

   * bio.throttle (avoid bio write deadlock)
   * ddsnap (snapshots and replication)
   * ramback (backing store for ramdisks)

I am still learning git and developing my workflow, so it will take a 
few days for that to settle down, during which period I will tear down
and rebase the content several times.  Currently I have very limited
bandwidth available, so please be gentle and avoid clone - just clone
a linus tree and pull into that instead.  (hpa...?)

To browse ddtree:

   http://phunq.net/ddtree

To pull from ddtree:

   http://phunq.net/git/ddtree (please do not clone for now)

For now there is no git:protocol access because git-daemon manifests 
some strange issue I have not yet had time to track down.  The symptom 
is this:

   $ tail /var/log/git-daemon/current
   2008-03-19_03:49:26.67922 [1068] Request upload-pack for '/ddtree'
   2008-03-19_03:49:26.68142 fatal: packfile ./objects/pack/pack-d37a0c64e9ce1c8b29ad9c02a39636ca9c609c31.pack cannot be mapped.

Invitation

Anybody who wants to participate in the ongoing design, development and 
debugging of lvm3, among other things: we hang out on irc.oftc.net 
#zumastor.  Everybody welcome, and see http://zumastor.org.

Regards,

Daniel

[1] Graydon Hoare: see quicksort, then see grandfather.

[2] Fortunately, Graydon did implement the first suggestion, that 
directories should become first class versioned objects, thus setting 
the stage for the development of git[3].

[3] Monotone, http://en.wikipedia.org/wiki/Monotone_%28software%29
