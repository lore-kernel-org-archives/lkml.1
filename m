Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbZGIO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbZGIO7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZGIO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:59:06 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1205 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZGIO7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:59:05 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20090709093004.GA32655@sirena.org.uk>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
	 <1247035197.5124.9.camel@Joe-Laptop.home>
	 <1247035481.15919.31.camel@penberg-laptop>
	 <1247035628.5124.11.camel@Joe-Laptop.home>
	 <20090709093004.GA32655@sirena.org.uk>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 07:58:56 -0700
Message-Id: <1247151536.12426.39.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 10:30 +0100, Mark Brown wrote:
> FWIW I've noticed that get_maintainer.pl has a tendency to pick up
> people it probably shouldn't when run on areas that have had few people
> committing to them since it tends to pick up people who've done generic
> cleanups but have no specific interest in that area of code.  I think a
> heuristic based on filtering the git log based on the proportion of
> commits that were done by each committer would help with many of these
> cases.

Hi Mark.

git log "-by:" lines are already sorted by number of commits
before selecting maintainers.  It doesn't matter if the
line is acked-by:, Signed-off-by:, tested-by:, or
brown-paper-bagged-by:, any "by:" signature is used.

get_maintainers does:

    git log --since=${email_git_since} -- ${file} \
    	 | grep -Ei "^[-_ 	a-z]+by:.*\@.*$" \
         | cut -f2- -d":" | sort | uniq -c | sort -rn

There are a few existing options that could be used
to minimize cleanup style committers.

    --git => include recent git *-by: signers
    --git-min-signatures => number of signatures required (default: 1)
    --git-max-maintainers => maximum maintainers to add (default: 5)
    --git-since => git history to use (default: 1-year-ago)

Using --nogit lists just the entries in MAINTAINERS

Using --git-min-signatures=3 or so seems to minimize
the generic cleanups committers.

Using --git-max-maintainers=3 or so, for files with more
changes, seems also to minimize the generic cleanup committers

Using --git-since=6-months-ago reduces the history period

Using --stat on the commit log and weighting for things
for lines changed would probably not be good because generic
cleanups often change more of the code than real logic
changes.

I suppose when the number of committers returned by
the "git log | grep" is low, returning just the 
most frequent committers might be good.

Any suggestions on better heuristics?


