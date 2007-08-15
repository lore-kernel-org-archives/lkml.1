Return-Path: <linux-kernel-owner+w=401wt.eu-S936820AbXHOVVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936820AbXHOVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933362AbXHOVVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:21:12 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32938 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057AbXHOVVL (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:21:11 -0400
To: Marc Perkel <mperkel@yahoo.com>
cc: Phillip Susi <psusi@cfl.rr.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       valdis@turing-police.cc.vt.edu
Subject: Re: Thinking outside the box on file systems
In-reply-to: Your message of "Wed, 15 Aug 2007 13:50:17 PDT."
             <920558.27414.qm@web52504.mail.re2.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <920558.27414.qm@web52504.mail.re2.yahoo.com>
Date: Wed, 15 Aug 2007 17:20:37 -0400
Message-ID: <21905.1187212837@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 13:50:17 PDT, Marc Perkel said:
> I don't see it as being any worse that what we have
> now. To open a file you have to start at the bottom
> and open each directory and evaluate the permissions
> on the way to the file. In my system you have to look
> up the permission of the string at each "/" separator.
> Seems to me that every system would have these same
> steps.

No - you need to look at the *whole* string - that's the
whole *point* of your system, remember?

Just a few msgs back, you gave a nice example of
having a file with \ in the name rather than / because
it came from a Windows user. So you *do* need to check *every*
pattern against the filename, because it *could* match.
In a system with several hundred thousand or more patterns,
that could be painful.

Also, you need to figure out how to deal with all the various
silly corner cases that people will end up trying to do.

Consider the rules:

peter '*a*' can create
peter '*b*' cannot create

Peter tries to create 'foo-ab-bar' - is he allowed to or not?

For an exersize, either write a program or do by hand:

Create a list of patterns that correctly express the ownership
and permissions of *every* file on your current Linux box.

Then repeat on a large box with multiple users and a few Oracle
databases or webservers.

Then write a small tool, that given that list, a username,
a filename, and the operation (read, write, open, unlink, etc),
says "Yes or No".

Then run 'strace /bin/ls' in a large directory, take all the
filenames listed in the strace output, and see if your tool can
answer "yes or no" fast enough to make 'ls' feasible.

Come back when you get that part done, and we'll discuss how it
would have to work in the kernel.
