Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYBRM54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYBRM54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYBRM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:57:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYBRM5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:57:44 -0500
Date: Mon, 18 Feb 2008 13:57:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Message-ID: <20080218125702.GB15044@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218114936.GM8905@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> I'm going to NACK it as well.  This kind of code churn where we make 
> symbols static only to make them non-static again in an existing ext4 
> tree is exactly the sort of needless code churn that makes patches 
> start to conflict and where we need different patches depending on 
> whether it is intended for -mm or linux-next or mainline.

Resolving a reject due to a line of code difference is about 10 seconds 
of your or time - and you two already spent 10-100 times more time on 
just fighting that line of code - which is weird. Yes, "naked" exports 
are sometimes OK (and i recently defended and NACK-ed an export removal 
in one such case), but the reason given here, out of tree forks are very 
much not such a case.

Example: recently i got some scheduler stuff not included in time - and 
had to remove an unnecessary export. Stupid me for not having planned it 
right and i deserved looking stupid in the git log. This time you did 
not get the "journal checksum patch" into 2.6.25 by time: tough luck, it 
shows that you suck at getting stuff done in time sometimes.

So please deal with it like most other subsystem maintainers do and stop 
complaining about "code churn" - nobody but you changes the ext3 
codebase, it's one of the codebases least affected by general kernel 
flux, it's an ultimate "leaf" subsystem.

In fact, we only had 5300 lines of code flux in ext3 in the past ~3 
years:

  $ git-log -p -M v2.6.12.. fs/ext3/ | diffstat | tail -1
    45 files changed, 3205 insertions(+), 2043 deletions(-)

with its 16 KLOC's that's a churn rate of ~10% per year. [and 9% out of 
that was ext3's own feature churn, nothing externally inflicted]

As a comparison, the core kernel had a churn of 182,000 lines [and this 
excludes renames] in the past 3 years:

  $ git-log -p -M v2.6.12.. kernel/ | diffstat | tail -1
    284 files changed, 96256 insertions(+), 45277 deletions(-)

and with it being a 91 KLOC codebase that's a _51%_ churn rate per year.

Or take a look at the networking code, with a ~40% 3-year churn rate in 
half a million lines of code. _That_ is a high rate of change - but the 
networking people have learned how to deal with it and Linux has become 
the best OS on the planet in terms of networking technology.

The whole kernel has 8406491 LOC at the moment, in the past 3 years it 
had a churn of 9214017 lines of code (excluding renames), which averages 
to a churn rate of ~35% per year.

	Ingo
