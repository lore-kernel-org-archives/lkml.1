Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458Ab0ACBwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0ACBwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 20:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031Ab0ACBwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 20:52:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55607 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0ACBwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 20:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r8UDy5oMmq8kJIvsti3yDA+nju6hcGtouahe7L6JoVOZAhAmGU104XiIRDwbLIr/pa
         hJNNmryuba5aX+mlsvS8s2fvaxiOjJPvDvToIhqfInfTwZFSPw/UqtGkQvbC22mjk6QX
         YQyUSFbC1w6sVVhIB6GI5YRsWuUsyH4nr0ngI=
Date: Sun, 3 Jan 2010 02:52:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100103015208.GJ5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org> <20100102210653.GH5076@nowhere> <20100102233603.GO828@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102233603.GO828@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 06:36:03PM -0500, tytso@mit.edu wrote:
> Yes, quite a bit more than that.  One such test (which is used by
> xfsqa test) is the fsstress proram, which is quite flexible.  You can
> program different combinations of fallocate, direct I/O read/writes,
> setxattr, buffered read/writes, symlinks, truncates, renames, etc..
>
> The xfsqa suite will run fsstress in a number of different modes, but
> that's not the only test program that it uses.  It also uses the fsx
> program which exercises concurrent read/write/mmap operations, as well
> as other programs to test acl support, noatime support, etc.
> 
> I make a point of running the regression test suite before pushing a
> patch series to Linus; it makes me far more comfortable than I haven't
> accidentally introduced some problem.



Hmm, I'm trying to play with it, and some things are not obvious to
me. I can launch fsstress directly, works well, but as I would
like to run all possible tests, I'm trying the check script, as
explained in the README file.

So I've set the partition and ran the script:

export TEST_DEV=/dev/sda3
./check -r

But:

[: 53: ==: unexpected operator
common.rc: Error: $TEST_DEV (/dev/sda3) is not a MOUNTED xfs filesystem
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda3 reiserfs   134797288   2982296 131814992   3% /data


I'm not sure how I can run these tests on a non-xfs partitions.
I must be missing something.

 
> > I guess this is the right place to get it?
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> Yep.  You'll need to install a number of packages to compile it,
> including libaio-dev, libattr1-dev, libacl1-dev, xfsprogs,
> xfslibs-dev, etc.


Thanks.

