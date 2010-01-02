Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214Ab0ABXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab0ABXgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468Ab0ABXgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:36:17 -0500
Received: from thunk.org ([69.25.196.29]:44473 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0ABXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:36:16 -0500
Date: Sat, 2 Jan 2010 18:36:03 -0500
From: tytso@mit.edu
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102233603.GO828@thunk.org>
Mail-Followup-To: tytso@mit.edu, Frederic Weisbecker <fweisbec@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Christian Kujau <lists@nerdbynature.de>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
 <87bphc7heo.fsf@basil.nowhere.org>
 <20100102163644.GA5076@nowhere>
 <20100102174311.GA30016@basil.fritz.box>
 <20100102190213.GC5076@nowhere>
 <20100102192337.GB30016@basil.fritz.box>
 <20100102201138.GF5076@nowhere>
 <20100102210101.GN828@thunk.org>
 <20100102210653.GH5076@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102210653.GH5076@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 10:06:55PM +0100, Frederic Weisbecker wrote:
> 
> Thanks! I'm going to test it now. I've been running a stress test
> from Chris Mason which basically checks races on parallel writes/read.

Hmm, which test is this?

> If this testsuite includes more checks, like xattr and some other
> things, then that's exactly what I was searching.

Yes, quite a bit more than that.  One such test (which is used by
xfsqa test) is the fsstress proram, which is quite flexible.  You can
program different combinations of fallocate, direct I/O read/writes,
setxattr, buffered read/writes, symlinks, truncates, renames, etc..
The xfsqa suite will run fsstress in a number of different modes, but
that's not the only test program that it uses.  It also uses the fsx
program which exercises concurrent read/write/mmap operations, as well
as other programs to test acl support, noatime support, etc.

I make a point of running the regression test suite before pushing a
patch series to Linus; it makes me far more comfortable than I haven't
accidentally introduced some problem.

> I guess this is the right place to get it?
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Yep.  You'll need to install a number of packages to compile it,
including libaio-dev, libattr1-dev, libacl1-dev, xfsprogs,
xfslibs-dev, etc.

						- Ted
