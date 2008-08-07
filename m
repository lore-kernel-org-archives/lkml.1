Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYHGVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYHGVze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYHGVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:55:26 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:50059 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYHGVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:55:25 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Date: Thu, 7 Aug 2008 21:55:24 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g7fr0c$f1h$1@taverner.cs.berkeley.edu>
References: <20080804223249.GA10517@kroah.com> <1218058081.5837.49.camel@localhost.localdomain> <20080806215244.GA21462@mit.edu> <1218118603.5837.101.camel@localhost.localdomain>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1218146124 15409 128.32.168.222 (7 Aug 2008 21:55:24 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 7 Aug 2008 21:55:24 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris  wrote:
>Absolutely, I think that our solution needs worry much less about an
>actively attacking root process than Windows. [...]
>
>1) fileserver with no active attack on system
>2) actively attacking non-root processes (run some process that tries to
>screw people)
>3) accidentally attacking, non-root process. (open a malicious
>openoffice file)
>4) accidentally attacking, properly functioning, root processes (my
>thought on this would be a properly functioning non-exploited yum
>program getting data from a bad repo)
>
>For the purposes of this e-mail discussion can we only discuss #1?

OK, focusing on the case of a Linux fileserver that is serving files
to Windows clients (scenario #1) makes sense to me.  That seems like
progress, because it helps define the problem space better.

Seems like Ted Tso has already responded to that one with his comments
on SMB/NFS, where he suggests that there are good technical solutions to
the case of a Linux Samba fileserver, and argues that this is the case
that matters.  It seems to me the ball is now in your court to respond
to that on a technical level.

>I believe this to be a reasonable goal as it reduces the attack area for
>a number of attacks against linux programs (pdf rendering flaws, jpg
>rendering flaws, etc).  Browser downloads bad pdf, evince tries to open
>that which the browser just downloaded, BLOCKED.

I guess this is scenario #2 which you suggest we should not discuss, so
perhaps I shouldn't respond, but here goes: The weakness is that this
does not really reduce the attack area.  This can filter out exploits
but cannot fix vulnerabilities.  For any one vulnerability there are
likely to be gazillions of ways to exploit the vulnerability, and it is
unlikely that an A/V scanner will be able to detect all of those exploits.
So we can't really say that surface area is closed off.

There are other ways to mitigate this particular example threat (e.g.,
SELinux, Systrace, plash, etc.), so if we wanted to consider this kind
of attack scenario, we should probably also look at those as well.
But since you suggested we focus on scenario #1, not on this scenario,
I won't belabor that point any further.

>I don't see myself wasting time going down the
>GLIBC path since I believe that making systems inhospitable to 'bad'
>data is something that should be done (if reasonably possible) both
>client and server side.

"Making systems inhospitable to 'bad' data" is a slogan, not a
well-defined technical problem.  The slogan sounds full of motherhood
and apple-pie goodness on the surface, but when it comes down to details,
what exactly is meant by the slogan isn't so clear to me (what's the
definition of 'bad'? what's the threat model? is this really the best
approach?).  I guess I agree with others who have suggested focusing
on a well-defined technical problem, and that's going to take more
than slogans.
