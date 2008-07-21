Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYGUJ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYGUJ7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYGUJ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:59:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYGUJ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:59:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
In-Reply-To: Andrew Morton's message of  Thursday, 17 July 2008 01:51:05 -0700 <20080717015105.f919f615.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080717015105.f919f615.akpm@linux-foundation.org>
X-Zippy-Says: Boy, am I glad it's only 1971...
Message-Id: <20080721095932.B409A15421D@magilla.localdomain>
Date: Mon, 21 Jul 2008 02:59:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo said very well what I think the intrinsic value is.  Indeed, I
think it is of use even if utrace were never merged.  Anyone who
decides tomorrow that my crap is useless and whips up a different
plan instead of utrace, will benefit from reading all the kerneldoc
in tracehook.h.

The practical value of the patch series right now is that it makes
life easier for merging and patch juggling.  The new utrace patches
are indeed coming too, and I'm expecting some vigorous feedback.
Different versions are likely to bounce around for a while.
Meanwhile, there are some people trying to track latest+utrace via
GIT or patching.  The tracehook series makes it so that the utrace
patches proper touch very little core code and few files, so merge
and patch conflicts are rare.  I can tell you from doing it a lot
that there are frequently niggling conflicts to fix up in rebasing
the tracehook patches after miscellaneous core kernel changes.
Things requiring changes to tracehook.h are unlikely, but unrelated
changes textually near the tracehook calls that foul automatic patch
merging are common.

I'll do another few days of polish on utrace first too, but one main
reason I posted tracehook alone first was to see how much shrapnel I
took in the face just for this, before getting to the substantive
bits.  If this much is accepted, that's enough to make it possible
for utrace or another new thing to be added as a config option.  

The new utrace has internal differences from the first version, but
the more essential point here is that it's entirely optional at
config time.  Whatever traits utrace has, it's only a new
non-default config option marked EXPERIMENTAL.  Once the tracehook
series is accepted, then relative to that, no utrace patches will do
anything at all if CONFIG_UTRACE is not chosen.

Another value is for arch folks.  I know at least a few arch
maintainers are interested in adding this support.  The generic
tracehook series sets a base on which all the arch support can be
finished up and ready to enable utrace or something different,
whatever it is.  If this base is in a canonical shared tree to be
merged into, then any interested arch people can fully complete this
work and push it to their arch's users.  This lets people experiment
on utrace (or a replacement) without also juggling arch patches.


Thanks,
Roland
