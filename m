Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXHNP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXHNP6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762062AbXHNP6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:58:11 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59046 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123AbXHNP6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:58:09 -0400
Message-ID: <46C1CFFE.4000001@gmail.com>
Date: Tue, 14 Aug 2007 17:53:34 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	<200708131933.10125.m.kozlowski@tuxland.pl>	<1187026955.2688.4.camel@laptopd505.fenrus.org>	<1187037445.6628.98.camel@heimdal.trondhjem.org>	<1187054366.2757.0.camel@laptopd505.fenrus.org>	<46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>
In-Reply-To: <20070814102033.604c8695@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 11:20 AM, Alan Cox wrote:

>> MODULE_MAINTAINER() was discussed a while ago but embedding information into 
>> the binary has the problem you can't ever change deployed systems, meaning 
>> it lags by design. If a maintainer changes, people would still be using the 
>> information from their old binaries, meaning a replaced maintainer might get 
>> contacted for potentially years still (and the new one not).
> 
> And as was pointed out at the time, the people whining about that were
> talking out of the wrong equipment. The supplier of the code can no more
> or less easily change the binary as the matching source tree once its been
> shipped. In fact its probably easier to change the binaries as the
> sources will be left on CD.

That's just not a complete argument if one accepts that users can be people 
without _any_ source tree lying around. There's no reason this user would 
believe that any source tree, matching or not, would provide him with beter 
information than the information modinfo just spat at him. The only thing 
that helps is not have modinfo spit _any_ contact information at him so he 
knows to look elsewhere.

And even more importantly ...

PUHLEASE PUHLEASE don't dirty this discussion with binary tags in the first 
place! It isn't about MODULE_FOO() tags, it is about tagging /source/ files 
to help with putting CCs on patch submissals. People who submit patches sort 
of by definition have a current source tree lying around, and do not need to 
grab information from any binaries. As such, putting it in a comment inside 
the source is all that's relevant here, not anything to do with binaries.

So, let's talk source. If we want to link source file foo.c and the 
MAINTAINERS information, we have 3 options:

1. MAINTAINERS --> foo.c

This is what Joe Perches' current 550 piece proposal does. Although I can 
hardly wait for version 2 of the patchset, high potential to turn into an 
incomplete obsolete mess upon adding, removing and moving files around.

2. foo.c --> MAINTAINERS

Putting a copy of the MAINTAINERS entry in a header in a every single source 
file (Joe already nicely provided us with the paths to script something like 
that) works but considering that single "maintenance units" might consist of 
many source files, people might not bother to keep them all updated and in 
sync and really, they shouldn't need to.

Sticking a single backlink to a MAINTAINERS file entry at the top of a 
source file might work:

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ ... @@
+/*
+ * MAINTAINERS: IDE/ATAPI CDROM DRIVER
+ */

[ ... ]

3. foo.c <--> some 3rd file <--> MAINTAINERS

Just for completeness and trying to make sure I'm not inventing an or/or but 
I don't see any use in this linkage, so it's 1 or 2 it seems.

Note, perhaps after we have a MAINTAINERS source tag, we can discuss whether 
or not it could in fact be a MODULE_MAINTAINER() binary tag, but that's then 
about something else at that point...

Rene.

