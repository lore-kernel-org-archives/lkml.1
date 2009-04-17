Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbZDQWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbZDQWD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761214AbZDQWDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:03:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbZDQWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:03:15 -0400
Date: Fri, 17 Apr 2009 14:58:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Perches <joe@perches.com>, randy.dunlap@oracle.com, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
In-Reply-To: <20090417144117.4ac8828f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904171446500.4042@localhost.localdomain>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost> <20090417144117.4ac8828f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Andrew Morton wrote:
> 
> : fatal: Not a git repository
> 
>     it whines about not being run in a git directory, but does a decent
>     job anyway.  

The default options are: --email --git --m --l --multiline, and the 
"--git" part basically does a

	git log --since=${email_git_since} -- ${file}

to see the logs, and greps and counts sign-offs.

So the "fatal: Not a git repository" is from git saying it can't do that.

And as a result, it _only_ looks at your MAINTAINERS file, rather than 
trying to figure it out from other sources too.

For example:

	[torvalds@nehalem linux]$ ./scripts/get_maintainer.pl --no-git -f kernel/exit.c
	linux-kernel@vger.kernel.org

would be what you see. And then if you have git, you'd also see

	[torvalds@nehalem linux]$ ./scripts/get_maintainer.pl --git -f kernel/exit.c
	Andrew Morton <akpm@linux-foundation.org>
	Ingo Molnar <mingo@elte.hu>
	Oleg Nesterov <oleg@tv-sign.ru>
	Oleg Nesterov <oleg@redhat.com>
	Roland McGrath <roland@redhat.com>

because it literally looked at sign-offs of patches that touched 
kernel/exit.c in the last year, and noticed that those tive people had the 
top five spots.

(Ok, so I have the top spot, but I'm a penguin chief and as such get 
excused. You were _originally_ on that list too, but apparently you like 
getting email, so now you're listed too).

And yeah, I personally find the git statistics more relevant than the 
MAINTAINERS list. I just tend to do it by hand, although I tend to use a 
six-month cutoff:

	git log --since=6.months.ago kernel/exit.c |
		grep 'Signed-off-by: ' |
		sort | uniq -c | sort -n

works beautifully on just about any set of files and doesn't need no 
steenking perl.

		Linus

