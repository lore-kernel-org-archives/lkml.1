Return-Path: <linux-kernel-owner+w=401wt.eu-S1423491AbXBHWWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423491AbXBHWWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423493AbXBHWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:22:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423491AbXBHWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:22:50 -0500
Date: Thu, 8 Feb 2007 14:22:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
Message-ID: <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Roman Zippel wrote:
> 
> Sorry for the delay, but the git server were gone.
> 
> - the define command is inappropriate (it's primarily for rule 
>   definitions)

Looks fine. Especially considering the strange whitespace issues.

> - execute commands in the current dir as all other commands
> - .*.tmp (but not .*.null) files are also removed up by "make clean"
> - printf has other side effects, instead stop pretending we support 
>   something else than bash

However, this one I have problems with .The problem is, many people 
probably _do_ have bash, but it's in /bin/sh. That used to be a fairly 
common setup a long time ago. Maybe it's not any more, but the whole "fall 
back to sh" actually came from that.

The $BASH variable is only defined if you use bash as your *interactive* 
shell, ie if you started "make" from a bash shell.

Historically, people used to do:
 - /bin/sh was the "standard shell" (bash)
 - /bin/[t]csh is what clueless weenies use for interactive work.

(Yeah, I'm not a [t]csh fan ;)

And you did break that.

It's quite possible that all modern distributions will install /bin/bash 
as a link to /bin/sh, but I don't see the point of that particular change. 
We aren't even all that bash-centric any more. If you have a 
POSIX-compatible shell in /bin/sh, it really _should_ work. It just can't 
be something really broken.

> - proper quoting
> - proper indentation

One thing I'm wondering about is whether we could have a "does this warn" 
test. I guess you can do it with -Werror, but it might be nice to have 
some tests for "does the -Wxyzzy flag warn also for proper code"

		Linus
