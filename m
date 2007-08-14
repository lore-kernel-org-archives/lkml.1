Return-Path: <linux-kernel-owner+w=401wt.eu-S933723AbXHNSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbXHNSnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbXHNSm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:42:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbXHNSm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:42:57 -0400
Date: Tue, 14 Aug 2007 11:40:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
cc: Rene Herman <rene.herman@gmail.com>, git@vger.kernel.org,
       Junio C Hamano <gitster@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
 scripts/get_maintainer.pl
In-Reply-To: <1187116082.32555.122.camel@localhost>
Message-ID: <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl>
  <1187026955.2688.4.camel@laptopd505.fenrus.org>  <1187037445.6628.98.camel@heimdal.trondhjem.org>
  <1187054366.2757.0.camel@laptopd505.fenrus.org>  <46C10AA8.3090505@gmail.com>
 <20070814102033.604c8695@the-village.bc.nu>  <46C1CFFE.4000001@gmail.com>
 <1187110824.32555.76.camel@localhost>  <46C1EE6F.2080807@gmail.com>
 <1187116082.32555.122.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Aug 2007, Joe Perches wrote:

> On Tue, 2007-08-14 at 20:03 +0200, Rene Herman wrote:
> > "git info --maintainer drivers/ide/ide-cd.c" or some such would say "Alan 
> > Cox <alan@...>".
> 
> Perhaps maintainer(s), approver(s), listener(s)?
> 
> I think something like this should be a git-goal.
> What do the git-wranglers think?

The thing is, if you have git, you can basically already do this.

Do a script like this:

	#!/bin/sh
	git log --since=6.months.ago -- "$@" |
		grep -i '^    [-a-z]*by:.*@' |
		sort | uniq -c |
		sort -r -n | head

and it gives you a rather good picture of who is involved with a 
particular subdirectory or file.

A much *better* picture than some manually maintained thing, in fact, 
because it tells you who really does the work, and which way patches go...

(Maybe you want to add a

	grep -v '\(Linus Torvalds\)\|\(Andrew Morton\)'

to avoid seeing the normal chain too much, but hey, we probably want to 
know too. Anyway - the script can certainly be tweaked, the point is 
really just that the git tree _already_ contains the relevant 
information).

		Linus
