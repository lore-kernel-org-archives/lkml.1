Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbXHPLaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbXHPLaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbXHPLaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:30:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:52170 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbXHPL37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:29:59 -0400
Message-ID: <46C43489.2060109@aitel.hist.no>
Date: Thu, 16 Aug 2007 13:27:05 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Craig Ruff <cruff@ucar.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <614991.75774.qm@web52507.mail.re2.yahoo.com>
In-Reply-To: <614991.75774.qm@web52507.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
>
> I am describing a kind of functionality and not tied
> to the method that implements that functionality.
> Perhaps a straight hash of the name isn't the best way
> to implement it. Just because someone tried to do
> something like what I'm suggesting years ago and it
> didn't work doesn't mean that it can't be done. You
> just have to come up with a better method.
>   
Actually, you are the one who have to
come up with a better method. :-)
You implement it, you deploy on your server,
you work out the quirks,
you win the discussion and impress everybody.
> Lets take this example. We are moving a million files
> from one branch if a tree to another. Do we wait for a
> million renames and hashes to occur? Of course not. So
> what to we do? We continue to be innovative.
>
> One must first adopt the attitude that anything can be
> done - you just have to be persistent until you figure
> out how.
>   
Feel free to be persistent and do the work & testing
needed.  People have done so before, which is why
there are so many linux filesystems to choose from.

What you can't do though, is to start with an attitude
that "anything can be done" and then expect to change
the direction of kernel work before everything is
figured out.  Experimental stuff stays in your private
tree till it is proven - for a reason.
> In this case we could have a name translation layer so
> if you want to do a move you change the translation
> layer indicating that a move occurred. Thus access to
> the new files get translated into the old name and
> accessed until the files are rehashed.
>   
That name translation layer has a nasty failure mode.
Let's say I want to move all files in /usr/local/* into /usr/old-local/
The name translation layer makes the transition seem
instant, even though there are now 10 million files queued
for renaming. References to /usr/local now goes to
/usr/old-local/ thanks to translation.

Now the problem.  I did the move in order to fill
/usr/local/ with new improved files. But all references
to /usr/local now goes to /usr/old-local/, so the new
files go there as well.

A translation layer _can_ work around this, by noting
that /usr/local is currently being translated, the
move queue has not finished processing, so further accesses
to /usr/local goes to /usr/local-tmp/ instead, to be moved
into /usr/local when that other batch of moves finishes.

In doing this, you set yourself up for lots of complexity
and lots of behind-the-scenes work. People will
wonder why the server is so busy when nobody is
doing much, and what if there is a power crash
or disk error on a busy server. It'd be an "interesting"
fsck job on a machine that went down while
processing several such deferred moves and translations. :-/
> My point - you start with what you want to do and then
> you figure out how to make it happen. I can't answer
> all the details of how to make it happen but when I do
> something I start with the idea that if this were done
> right it would work this way and then I figure out
> how.
>   
Sure - you don't have to prove that it will work now.
Working it out over time and then showing us is ok.

Helge Hafting
