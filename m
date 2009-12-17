Return-Path: <linux-kernel-owner+w=401wt.eu-S1764140AbZLQIeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764140AbZLQIeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764121AbZLQIen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:34:43 -0500
Received: from khc.piap.pl ([195.187.100.11]:47946 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764083AbZLQIel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:34:41 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
Date: Thu, 17 Dec 2009 09:34:35 +0100
In-Reply-To: <20091217061229.GD3946@linux-sh.org> (Paul Mundt's message of
	"Thu, 17 Dec 2009 15:12:30 +0900")
Message-ID: <m3tyvqgfs4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> writes:

> For starters, this is just crap. If you're writing code like this, then
> line wrapping is really the least of your concerns. Take your function
> return value and assign it to a variable before testing it in unlikely()
> as per existing conventions and most of this goes away in this example.
> If you're testing an absurd amount of conditions in a single block with
> needlessly verbose variable names, then yes, you will go over 80
> characters. Consequently, your "clean" example doesn't look much better
> than your purposely obfuscated one.

Then perhaps checkpatch should warn about too complex expressions
instead? Line length is rather weak indication of complexity.
The typical problem being printk() with the printed info approaching
80 chars (but there are others, of course).

BTW I remember we have already agreed that the 80-chars limit is a bad
thing, though apparently nobody bothered to fix the docs and checkpatch.

> The 80 character limit isn't a hard limit, but it's still an excellent
> guideline largely because it stops people from writing code like in your
> above example.

What is more important is it stops people from writing a perfectly
readable code, forcing them to make the code (much) worse.

> Some amount of common sense is necessary, and most
> people in a position of applying patches can work out when to ignore
> checkpatch and when not to.

Precisely - we need common sense instead of artificial limits which are
almost unrelated to the actual problem.

> Aiming to keep things around 80 characters has served us well over the
> years,

I don't think so. I think it made more harm than good. Some people
routinely ignore this "!!!!! ERROR !!!!!" but a large part of developers
make the code (sometimes much) worse for this very reason.
Fortunately the patches are reviewed.

> One only has to take a look through some of the
> staging/ drivers pre-cleanup efforts for examples that clearly benefit
> from triggering these warnings rather than implicitly supporting insane
> tab depths.

Checkpatch doesn't check for sane/insane tab depths. It's not that
trivial. Unfortunately, checking line length is a very poor substitute.

Yes, checkpatch probably could warn about having many long lines (though
I wouldn't mention the "80" number). But it should be clear it's not
about the length but about (possible) complexity.
-- 
Krzysztof Halasa
