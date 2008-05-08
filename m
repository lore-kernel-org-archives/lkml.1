Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYEHXdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYEHXdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYEHXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:33:08 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:5408 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYEHXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:33:06 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT bisection range errors
References: <48237CA0.4080001@keyaccess.nl>
	<20080508222545.GH22887@cs181133002.pp.htv.fi>
	<48238087.7000509@keyaccess.nl> <20080508225645.GA24725@deepthought>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 May 2008 16:33:04 -0700
In-Reply-To: <20080508225645.GA24725@deepthought> (Ken Moffat's message of
	"Thu, 8 May 2008 23:56:45 +0100")
Message-ID: <adave1oqslr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 May 2008 23:33:04.0613 (UTC) FILETIME=[DCE80150:01C8B163]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > $ git checkout -b rc v2.6.26-rc1
 > > $ git bisect start
 > > $ git bisect bad
 > > $ git bisect good v2.6.25
 > >
 > > Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
 > > as the last two results (both good...).

 >  I reported a similar thing at the beginning of April
 > http://lkml.org/lkml/2008/4/2/390 - 2.6.25-rc1 bad, 2.6.24 good, git
 > dropped me back at 2.6.24-rc4 (again, according to the top level
 > Makefile).

This is normal and expected, due to the distributed nature of git and
the fact that git-bisect operates on the full topology of history and
not just a linear sequence of commits.

Imagine history like:

    A---B---C---D
     \         /
      \       /
       \     /
        E---F

where B is good and D is bad.  Now, when you bisect, there is no way to
know whether, say, E is good or bad and hence the bisect process may
present E as a tree to try.

Now, if B is the 2.6.25 release, then since E branched off before B, it
will have a Makefile that says 2.6.25-rcX.  Which is exactly the
behavior you are seeing.

In short, everything looks fine and is behaving as expected.

 - R.
