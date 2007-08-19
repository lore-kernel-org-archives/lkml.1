Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbXHSHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbXHSHaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXHSHa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:30:26 -0400
Received: from 1wt.eu ([62.212.114.60]:1744 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbXHSHaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:30:25 -0400
Date: Sun, 19 Aug 2007 09:21:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [OT] Re: The vi editor causes brain damage
Message-ID: <20070819072135.GQ6002@1wt.eu>
References: <964583.28477.qm@web52504.mail.re2.yahoo.com> <46C7EE0A.2030601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C7EE0A.2030601@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 09:15:22AM +0200, Jiri Slaby wrote:
> Marc Perkel napsal(a):
> > Let me give you and example of the difference between
> > Linux open source world brain damaged thinking and
> > what it's like out here in the real world.
> > 
> > Go to a directory with 10k files and type:
> > 
> > rm *
> > 
> > What do you get?
> > 
> > /bin/rm: Argument list too long
> 
> What does this have to do with rm command?

Nothing, and no more with linux development. Marc confuses shell and rm.
Under DOS, when he types "del *", the shell calls the builtin function
"del" and passes it only one argument "*". The del function is then
responsible for iterating through the files using getfirst/getnext.

This is also why mostly only builtin shell commands support "*", while
most external commands do not support it, since they have to re-implement
the same code to iterate through the files (try "debug c*.com", it will
not work).

Under unix, the shell resolves "*" and passes the 10000 file names to
the "rm" command. Now, execve() may fail because 10000 names in arguments
can require too much memory. That's why find and xargs were invented!

The solution is easy : find . -maxdepth 1 | xargs rm

So this has nothing to do with rm, nor with rm being open-source, and
even less with rm being written with vi, and Marc's rant is totally
wrong and off-topic. Maybe he was drunk when posting, or maybe someone
used his keyboard to make him look like a complete fool. Or maybe he
really is.

Willy
(please do not follow up on this OT thread, responses to /dev/null)

