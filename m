Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZJFRpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZJFRpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZJFRpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:45:49 -0400
Received: from thunk.org ([69.25.196.29]:40896 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbZJFRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:45:48 -0400
Date: Tue, 6 Oct 2009 13:44:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006174450.GC24677@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
	Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 08:42:18AM -0700, Linus Torvalds wrote:
> Now, that's not actually true, because (a) people rebase and (b) even in 
> the absense of rebases I do merge with people like Andrew by email, so we 
> actually end up having statistics like these:
> 
>      32 SUBLEVEL = 29
>     383 SUBLEVEL = 30
>    8795 SUBLEVEL = 31
>       1 SUBLEVEL = 32
> 
> which is actually a bit sad in itself (showing just _how_ many people 
> rebased their work on top of a release), but is still showing that we 
> actually had 32 new commits in there that were based on a 2.6.29 kernel

It's actually not quite so bad.  If you take into account
Extraversion, the stats that you get look like this[1]:

      4 29-rc2
     28 29-rc8
    331 30
      4 30-rc2
     48 30-rc5
   3867 31
    561 31-rc1
    895 31-rc2
    190 31-rc3
    278 31-rc4
   1245 31-rc5
    521 31-rc6
    515 31-rc7
    387 31-rc8
    336 31-rc9
      1 32-rc2

That actually shows that well over half of the commit based off of
2.6.31 were actually based off of some 2.6.31-rc release, based on
something *before* 2.6.31 released.

Of the 3867 that were based on something between 2.6.31 and
2.6.31-rc1, that may be explained by people (like me) who will do a
test merge, and if the test merge has conflicts, prefer to resolve the
conflicts via a rebase and a re-run of the regression test suite, as
opposed to either (a) having the upstream maintainer (you) do handle
the merge, or (b) having two merges in the history; one merge by the
maintainer to resolve the merge conflict, and another by the upstream
maintainer when they pull in the topic branch.

Some (probably small percentage of the commits based on something
between 2.6.31 and 2.6.31-rc1 can probably be explained by on bug
fixes after an initial merge, but granted that's probably a pretty
small set.

					- Ted

\[1] Generated using:

git rev-list v2.6.31..v2.6.32-rc1 |
while read a
      do
	git show $a:Makefile | head -4 > /tmp/foo
	    awk '/^SUBLEVEL/ {printf("%s", $3)}; /^EXTRAVERSION/ {print $3}' < /tmp/foo
	    done | sort | uniq -c

