Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXDPSaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXDPSaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXDPSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:30:52 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:55938 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXDPSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:30:51 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 00/41] AppArmor security module overview
Date: Mon, 16 Apr 2007 18:24:34 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f00f12$th4$1@taverner.cs.berkeley.edu>
References: <20070412090809.917795000@suse.de> <20070412135028.GE5881@ucw.cz> <evm7eh$h12$1@taverner.cs.berkeley.edu> <20070416074612.GB2146@elf.ucw.cz>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176747874 30244 128.32.168.222 (16 Apr 2007 18:24:34 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 16 Apr 2007 18:24:34 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek  wrote:
> David Wagner wrote:
>> There was no way to follow fork securely.
>
>Actually there is now. I did something similar called subterfugue and
>we solved this one.

Yes, I saw that.  I thought subterfugue was neat.  The way that
subterfugue was a clever hack -- albeit too clever by half, in my opinion.
Dynamically re-writing the program on the fly to insert a trap after
the fork() call, right?  When the tracer has to do that kind of thing,
I find it hard to get confidence that it will be secure.  It seems
all too easy to imagine ways that the tracee might be able to escape
the tracing and break security.  There are all sorts of corner cases
to think about.  What if the program is executing from shared memory?
What if there are multiple threads running concurrently?  What if the
program is executing from a region of memory where a DMA is scheduled to
asynchronously write to?  Any of those cases could create a race condition
(TOCTTOU) where the trap after the fork() gets removed before the program
reaches that point of execution.

ptrace() seems like a fine answer for a debugger, but I think it's not
such a great answer for a security tool where you have to be dead-certain
there is no way to escape the sandbox.  When I'm relying upon something
for security, the last thing you want is to have to go through hairy
kludgy kludgy contortions to make up for flaws in the interface.
Complexity is the enemy of security.

I still think that ptrace() is not the best way to implement this kind
of security tool, and I think it's entirely understandable that they did
not use ptrace.  I do not think it is a fair criticism of AppArmor to say
"AppArmor should have used ptrace()".

>>  Handling of signals is a mess: ptrace overloads the
>> signal mechanism to deliver its events, [...]
>
>We got this solved in linux, I believe.

Out of curiousity, how was this solved?  It looked pretty fundamental
to me.

Thanks for your comments...
