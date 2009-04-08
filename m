Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbZDHRVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbZDHRVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZDHRVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:21:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbZDHRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:21:06 -0400
Date: Wed, 8 Apr 2009 10:19:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: checkpatch fixes
In-Reply-To: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0904081007530.4583@localhost.localdomain>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Roland McGrath wrote:
>
> This fixes all the checkpatch --file complaints about kernel/ptrace.c
> and also removes an unused #include.  I've verified that there are no
> changes to the compiled code on x86_64.

Please don't bother with that insane "line length" option when using 
"--file". At least not if the "fix" is to just mindlessly split the line. 
That is _never_ a fix.

Changes like these:

> -int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
> +int ptrace_readdata(struct task_struct *tsk, unsigned long src,
> +		    char __user *dst, int len)

> -int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len)
> +int ptrace_writedata(struct task_struct *tsk, char __user *src,
> +		     unsigned long dst, int len)

>  	case PTRACE_GETEVENTMSG:
> -		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
> +		ret = put_user(child->ptrace_message,
> +			       (unsigned long __user *) data);

just make the code harder to 'grep'.

Yes, at some point you have to split lines, but that point is not 80
columns any more.  The advantage of getting the whole line when grepping
for function names much outweighs the downside of somebody using those
old 80x24 green phosphorous vt52's.

[ The same thing very much goes for complex if-statements etc.  If
  people can't stand the long lines, the primary solution would be to
  turn a complex conditional into a helper inline functions, or to fix
  excessive indentation by splitting up functions.

  In the above case, the last one could perhaps have been handled
  creating a new variable for and moving the cast to the initialiser,
  for example. Is it worth it to avoid a 85-column line? Probably not.

  And some lines just end up long.  I think 100 characters may be a
  more reasonable limit for "too long", but quite frankly, it depends on
  the line.

  So I think 'checkpatch' is pure crap in this area, and I've told
  people so before, and they keep telling me that it has relaxed it's
  idiotic warnings, but that is apparently just a lie. ]

Oh well.  If I actually read perl, I could parse what the hell those
80-character rules are in checkpath.  It already has random "it's ok if
X" stuff.  But it never seems to really have any "oh, but splitting is
worse" logic. 

			Linus
