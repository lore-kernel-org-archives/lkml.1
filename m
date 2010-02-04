Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab0BDOHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:07:50 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:9361 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932167Ab0BDOHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:07:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0BAAdkaktLd/sX/2dsb2JhbAAIgyvDa5AEgS6CQ1oE
X-IronPort-AV: E=Sophos;i="4.49,404,1262581200"; 
   d="scan'208";a="55306498"
Message-ID: <4B6AD4B2.7070406@teksavvy.com>
Date: Thu, 04 Feb 2010 09:07:46 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sergey Matyukevich <geomatsi@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com>	 <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>	 <4B69B0A0.2040701@teksavvy.com> <1265224535.24887.16.camel@Joe-Laptop.home>	 <4B6A5443.6090804@teksavvy.com> <1265260575.31964.13.camel@Joe-Laptop.home>
In-Reply-To: <1265260575.31964.13.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> If it's ever agreed that all lines > 80 cols are OK or
> new args after column 80 are OK, then sure.  Until then,
> if you want it, you should do it.
..

In case you missed it, it *has* already been "agreed" that
there's nothing magical about 80 anymore.  



-------- Original Message --------
Subject: Re: [PATCH] ptrace: checkpatch fixes
Date: Wed, 8 Apr 2009 10:19:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,	linux-kernel@vger.kernel.org
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>


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
