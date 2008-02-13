Return-Path: <linux-kernel-owner+w=401wt.eu-S933037AbYBMSUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbYBMSUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYBMSUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:20:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYBMSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:20:31 -0500
Date: Wed, 13 Feb 2008 10:19:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
cc: Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
In-Reply-To: <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802131014240.2920@woody.linux-foundation.org>
References: <20080213070215.GA11969@kroah.com>  <20080212.230423.172781444.davem@davemloft.net>  <1202887323.3129.10.camel@localhost>  <20080213165924.GB10129@suse.de> <1202923995.3129.26.camel@localhost>
 <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2008, Linus Torvalds wrote:
> 
> So in that sense, I think both MAINTAINERS and the deprecation schedule 
> are totally uninteresting. Yes, they have merge conflicts. But those merge 
> conflicts are really really easy to handle.

That, btw, includes "automatic merges" for something like a Linux-next 
tree. It's easy to just make something that says: if the merge fails, try 
to fix up these xyz files by just committing them with merge error markers 
and all".

That's fine for testing, exactly because it has no coding impact (and then 
when a _real_ merge happens, you have a human that actually resolves it).

The git script would be something like

	UNIMPORTANT_LIST=MAINTAINERS \
		Documentation/feature-removal-schedule.txt \
		...

	git pull ... ||
		git add $UNIMPORTANT_LIST &&
		git commit -m "Trivially conflicting merge"

which basically says: if the pull fails (leaving a conflicted tree), try 
to just "git add" the files on the unimportant list as-is, and then try to 
commit the merge that way instead.

Git if nothing if not scriptable, and things like this are *trivial*.

		Linus
