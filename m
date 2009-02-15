Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZBOKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZBOKyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZBOKyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:54:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZBOKyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:54:36 -0500
Date: Sun, 15 Feb 2009 11:54:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Damien Wyart <damien.wyart@free.fr>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215105408.GA31351@elte.hu>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <alpine.DEB.2.01.0902150210140.25613@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0902150210140.25613@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Kujau <lists@nerdbynature.de> wrote:

> On Sun, 15 Feb 2009, Ingo Molnar wrote:
> >    http://redhat.com/~mingo/tip.git/tracing-quickstart.txt
> >    http://people.redhat.com/mingo/tip.git/README
> 
> Hm, both URLs gave me a 404, .../tip.git/ seems empty - could these 
> documents find a nice place under Documentation/ perhaps?

Hm, there's a people.redhat.com outage today - find below that file
in plaintext too.

	Ingo

# --------------{ tip.git instructions }---------->

mkdir linux.trees.git || exit -1
cd linux.trees.git

git init
# Add Linus's tree as a remote
git remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# Add the -tip tree as a remote
git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

#
# With that setup, just run the following to get any changes you
# don't have.  It will also notice any new branches Ingo/Linus
# add to their repo.  Look in .git/config afterwards, the format
# to add new remotes is easy to figure out.
#
# This will take a lot of time initially (it downloads the ~150MB
# repository), but will be much faster subsequently as it only
# does delta updates. Note that it may warn you about no common
# commits but you can ignore that:
# 
git remote update

#
# Check out the latest -tip branch to a local branch
# in this example, we create a branch called 'tip-latest'
# You can pick whatever name suits you.
#
git checkout -b tip-latest tip/master

#
# if you need to do bisection of the -tip tree, then do:
# (but first check that linus/master is indeed a 'good' kernel :-)
#
git bisect start
git bisect good linus/master
git bisect bad tip/master

#
# If you want to help out with cleanups, and want to pick some
# low hanging fruits, do this:
#
wget http://redhat.com/~mingo/tip.git/code-quality
chmod +x code-quality

./code-quality `find kernel/ -name '*.c'` | tee quality.txt

#
# Pick the file that looks most interesting to you:
#
sort -n -k 4 quality.txt

#
# and if you do some work based on tip.git, in particular when
# you change x86 specific bits, feel free to talk to the
# maintainers about it (especially if you are about to
# do some bigger chunk of work and think that you'd like to
# ask whether it makes sense or whether anyone else is working
# on it):
#
#  X86 ARCHITECTURE (32-BIT AND 64-BIT)
#  P:      Thomas Gleixner
#  M:      tglx@linutronix.de
#  P:      Ingo Molnar
#  M:      mingo@redhat.com
#  P:      H. Peter Anvin
#  M:      hpa@zytor.com
#
# And this is the mailing list to send patches to:
#
#  L:      linux-kernel@vger.kernel.org
#
# When sending arch/x86 patches, please try to use the following
# subject line format (sample):
#
# Subject: [patch] x86: fix typo in ...
#
