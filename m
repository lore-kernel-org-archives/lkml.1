Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZBUJRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZBUJRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZBUJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:16:37 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45530 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZBUJQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:16:34 -0500
Date: Sat, 21 Feb 2009 10:18:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090221091826.GA30055@uranus.ravnborg.org>
References: <20090219171005.GA27922@elte.hu> <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain> <20090221083212.GA1537@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221083212.GA1537@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> After half an hour of head scratching (including two 
> allyesconfig builds) i found these two gems commits that were 
> merged in the last week or two:
> 
> | commit fa2144ba9a31d1d0dc9607508576c3850e0d95b1
> | Author: Sam Ravnborg <sam@ravnborg.org>
> | Date:   Fri Feb 15 13:53:11 2008 +0100
> |
> |     kbuild: explain why DEBUG_SECTION_MISMATCH is UNDEFINED
> |    
> |     We started to see patches enabling this - so explain why
> |     it is disabled and the condition to enable it again.
> |    
> |     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> |
> | diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> | index a370fe8..ab408aa 100644
> | --- a/lib/Kconfig.debug
> | +++ b/lib/Kconfig.debug
> | @@ -82,6 +82,9 @@ config HEADERS_CHECK
> |  config DEBUG_SECTION_MISMATCH
> |         bool "Enable full Section mismatch analysis"
> |         depends on UNDEFINED
> | +       # This option is on purpose disabled for now.
> | +       # It will be enabled when we are down to a resonable number
> | +       # of section mismatch warnings (< 10 for an allyesconfig build)
> 
> | commit e5f95c8b7700a7bf1c2d24eedc677954d9aa0285
> | Author: Sam Ravnborg <sam@ravnborg.org>
> | Date:   Sat Feb 2 18:57:18 2008 +0100
> |
> |     kbuild: print only total number of section mismatces found
> |    
> |     We have too many section mismatches detected at the moment.
> |     So silence modpost and prevent the option from being
> |     set in a typical allyesconfig build.
> |    
> |     Tell the user how to see all the deteils in the summary
> |     message from modpost.
> |     
> |     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> These commits are an utter joke.

In 2008 when they was applied they were perfectly sensible.
We had far too many secton mismatch warnings at that point
in time and I btw spent quite some time fixing these.

I reached zero warnings on allyesconfig/allmodconfig builds
on x86 in my tree, but I recall that I had warnings left in
diverse arm configs, and some other archs that I build.

After several flames about section mismatch fixes was pure
patch noise and not worth the time to neiter fix the warnings
nor report them I simply lost incentive to do any kind
of follow-up on them.

Before that the above patches was introduced because several people
complained about the additional warnings that was generated and the fear
for this that lkml would be spammed.

I will be happy to merge a patch that makes the warnings become visible
again and also to make them hard errors.
But for now I cannot take the additional work it requires to follow
all the section mismatch warnings that suddenly will pop up for
the different architectures, which is why I hesitate to create
said patch myself.


	Sam
