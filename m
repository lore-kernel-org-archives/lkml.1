Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYLaRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYLaRWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYLaRWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:22:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYLaRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:22:00 -0500
Date: Wed, 31 Dec 2008 09:21:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
In-Reply-To: <20081231074356.GA28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
References: <20081231074356.GA28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Al Viro wrote:
>
> Beginning of VFS queue for .29-rc1; that's just the first part. Please pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus.

Al, can you please try to clean up the commit messages? 

There's tons of unnecessary "[PATCH, v5]" things in those commit headers, 
and that seems to mean that you intentionally pass the "--keep" flag to 
git to keep the crap in subject lines, rather than let git clean it up for 
you.

Git by default will try to clean things up, so you literally have done 
extra work to make your commits look like shit!

Similarly, look at commit ef564e5cb82dbadc49949c93d8f7908f58c1016b: not 
only does it have a "[patch][rfc]" at the head of the subject line (it 
sure as hell isn't a rfc any more when you've committed it and intend to 
push it to me!), but the commit message itself contains

    Hi,
    Comments?
    Thanks,
    Nick
    
    --

in front of the actual message (that commit also lacks a sign-off, btw, 
probably exactly because Nick wasn't sure it should be applied).

Those things make sense when people pass around patches for comments, but 
you're supposed to clean the damn things up before applying them! They are 
pure and utter crap if they make it into the git history - they only add 
distracting noise, and look bad.

I can understand _occasional_ cases where you miss something like this, 
but EVERY SINGLE COMMIT is broken in this series. Some just have the 
crappy [PATCH] thing, but there are several that have extra email crud 
that makes sense in an email, but not in a commit message.

I pulled it, but after looking at it, I unpulled it again. It really is 
every single commit that is broken. Even the ones that aren't from emails 
(they seem to be just your own commits) are broken. Look at 
4edb9c1f26c7b7ccd39b7e3fe8aee5096786fdee: it has that [PATCH] header even 
though it's your own commit (so you apparently wrote it by hand), and the 
one-liner thing (the one you see in shortlogs or in the gitk overview) is 
just

	[PATCH] nfsd races, reiserfs

which isn't exactly readable. Why isn't it real proper English, something 
like

	Fix nfsd races in reiserfs

which is a properly capitalized real sentence and thus just more readable? 
And shorter to boot?

Yeah, "git shortlog" will get rid of at least some of these things (it 
will remove the pure "[patch] " prefixes), and yeah, it used to be common 
to see [PATCH] in the git logs back early on before we learnt how to make 
things more readable, so it wouldn't _hurt_ to pull. But I decided to 
unpull just because I don't want to continue to see things like this. 

And btw, feel free to push the pain downward. If they people who send you 
patches send bad changelogs, just tell them to re-send with a better one. 
I end up just always editing the mbox I have by hand in order to fix 
things like this, but I also make sure that people who send me lots of 
patches know to send them in the right format where I no longer need to 
fix things. After a while, the number of messages I need to fix up has 
dropped dramatically, and everybody is happy.

		Linus
