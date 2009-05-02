Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZEBBeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZEBBeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZEBBef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:34:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36425 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZEBBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:34:35 -0400
Date: Sat, 2 May 2009 02:34:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Bullshit commit messages (Re: [PATCH] fs: Remove sparse errors in
	bio.c)
Message-ID: <20090502013433.GQ8633@ZenIV.linux.org.uk>
References: <1241188402-19332-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241188402-19332-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 04:33:22PM +0200, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> fs/bio.c:720:13: warning: incorrect type in assignment (different address spaces)
> fs/bio.c:720:13:    expected char *iov_addr
> fs/bio.c:720:13:    got void [noderef] <asn:1>*
> fs/bio.c:724:36: warning: incorrect type in argument 2 (different address spaces)
> fs/bio.c:724:36:    expected void const [noderef] <asn:1>*from
> fs/bio.c:724:36:    got char *iov_addr
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

I'm sorry, but I've had it.  Resend with sane commit message and don't do that
kind of crap again; I'm beyond being sick and tired of mail with subjects that
say nothing about what's going on, not to mention flat-out untruth in attempt
to make them look more impressive (for crying out loud, you couldn't even have
reported what kind of message does the tool generate, let alone being more
specific than "warning").

Folks, that's got to end.  I've pondered replying to the previous one like
that from the same source (what with having sent a reply to yet another
such submission saying "don't do that" just before), but this one is over
the top.  And this kind of thing is getting more and more common.  For
a while it used to be about "checkpatch errors", but it seems to be spreading.

I'm sorry if that'll drive somebody to whinging about unkindness to newbies.
However, I really believe that this needs to be said plainly:

	* Thou Shalt Not Forget The Tail Of Boy Who Cried "Wolf".  Don't
pass warnings for errors and don't hide the information about the kind
of warning in the mail itself.

	* Tools Are Not Deities To Be Appeased.  Subject saying in effect
"$TOOL is upset!!!" is bloody useless.

	* Thy Mail Will Be Triaged.  Live with it.  Volume on l-k is huge
and the best strategy is to get mail recognized as relevant and to have
reviewers' estimate of priority before looking into the thing more or less
close to that after.  We all have heuristics; defeat these too often and
you will *become* one.

	* Thou Shalt Give Relevant Information In Subject.  Is that patch
correcting a misannotation?  Is it fixing a bug?  What kind of ...?

	* If Thou Hast No Better Message Than Quoted Warning, Thou Hast
No Message At All.  Either we are getting the $TOOL to STFU (in which
case you should've said so in the subject), or everything is really,
really obvious from the (short) patch itself, *OR* you are making a
change that ought to have an understandable goal.  In which case you
should put _that_ into commit message, not the $TOOL output.  Tools are
just that; tools, not oracles.  "This patch removes these warnings from
$TOOL" is neither a good explanation of what's going on nor, per se,
a good reason to apply the patch.


	In case of this patch, you have a __user misannotation in bio.c
and patch fixes that misannotation.  Correctly.  In case of proc/devtree
patch you've got NULL noise from sparse and said noise has been kinda-sorta
removed.  And I'd argue that blind replacement of if (p == 0) with
if (p == NULL) is the wrong thing to do; in particular, in these cases
if (!p) would be more idiomatic, but that's really up to Alexey.
