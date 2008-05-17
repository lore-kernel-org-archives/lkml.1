Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYEQWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYEQWpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYEQWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:45:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22509 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYEQWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s3FPt9jkTcG7O5O4/jt8BwIozSSknr8W4/cp1mPNI+hCQKIjLfMCfBHgKquS/P/8xN7cdy9hO8khB42qvPQgveYQrhvGjrSd1h50X1mt8Hncw63Hny6W0+RuJ5V7HtYbHctJZ2nonqqIIUOxuRjzF4g04r+c55pLRgJHEYOba7Y=
Message-ID: <9a8748490805171545j1811edc9ja0cd5f84105b71c4@mail.gmail.com>
Date: Sun, 18 May 2008 00:45:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Cc: "Theodore Tso" <tytso@mit.edu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
	 <20080517015705.GA20375@mit.edu>
	 <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/17 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 16 May 2008, Theodore Tso wrote:
>>
>> Why do you consider rebasing topic branches a bad thing?
>
> Rebasing branches is absolutely not a bad thing for individual developers.
>
> But it *is* a bad thing for a subsystem maintainer.
>
<snip very nice description of when to use rebase>
>
> BUT if you're a subsystem maintainer, and other people are supposed to be
> able to pull from you, and you're supposed to merge other peoples work,
> then rebasing is a *horrible* workflow.
>
<snip stuff on fetch + merge>
> In other words, I very heavily would suggest that subsystem maintainers -
> at least of the bigger subsystems, really see themselves as being in the
> same situation I am: rather than doing the work, trying to make it easy
> for *others* to do the work, and then just pulling the result.
>

Linus,

Thank you for some very good descriptions on proper git workflow. That
was very informative.

As new Trivial tree maintainer I'm trying to figure out how I should
manage that tree, and based on your description on git use I have a
few questions.

What I did for my first merge-window was simply clone your tree,
create a for-linus branch, add all the patches to that branch and ask
you to pull. That worked nicely that once, but I guess that wiping the
tree and starting from a fresh clone every merge window wouldn't be a
good idea - especially since I'd like Trivial to also get pulled into
linux-next.

This is what I think I should be doing going forward. I'd appreciate
it if you could comment on whether or not it's the right way to do
things.

Start off with a clone of your tree (master branch).

Pull your tree into 'master' daily (or at least often).

Create a for-linux-2.6.27 branch or the upcomming 2.6.27 merge window
and apply all the patches I currently have pendng in a mailbox to that
branch. Keep the branch reasonably up-to-date by doing a weekly git
fetch + merge from my 'master' branch that tracks your tree.

Once the 2.6.27 merge window opens, ask you to pull the
'for-linux-2.6.27' branch and once you have done so, leave that branch
alone forever.

Branch off a new 'for-linux-2.6.28' branch and repeat.

As for linux-next, I'd create a 'linux-next' branch that I would
update whenever I change one of the 'for-linux-2.6.xx' branches, by
doing a fetch from the branch into 'linux-next' and then a merge.

Does that sound sane or is there a better way?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
