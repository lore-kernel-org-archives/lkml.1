Return-Path: <linux-kernel-owner+w=401wt.eu-S1765597AbXHOPOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765597AbXHOPOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761347AbXHOPOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:14:37 -0400
Received: from sidhe.atheme.org ([204.15.224.234]:49366 "EHLO sidhe.atheme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761245AbXHOPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:14:36 -0400
Message-ID: <46C31859.6030306@partiallystapled.com>
Date: Wed, 15 Aug 2007 11:14:33 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070723)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
In-Reply-To: <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Basically any newly-created item in such a directory will get the
> permissions described by the "default:" entries in the ACL, and
> subdirectories will get a copy of said "default:" entries.

This would work well, although I would give write permissions to a group
so the entire dir wouldn't need to be re-ACLed when a user is added. I
may give this a shot; I've been avoiding ACLs because they have always
sounded incomplete/not useful, but the inheritance aspect sounds rather
nice.

> So yes, such functionality is nice; even more so because we already have
> it.  I think if you were really going to "extend" a UNIX filesystem it
> would need to be in 2 directions:
>   (A)  Handling disk failures by keeping multiple copies of important
> files.

This is ZFS' bailiwick, no? I'd love to see the licensing issues
resolved, because if it can control level of redundancy on a
per-file/directory basis, I would be a very happy man.

>   (B)  Have version-control support

This might be pushing it, but hey, we *are* talking about the future here.

>   (C)  Allowing distributed storage (also lazy synchronization and
> offline modification support)

I'd really love to see distributed storage not suck. Everything I've
seen requires myriad daemons and ugly configuration.

> With some appropriate modifications and hooks, GIT actually comes pretty
> close here.  For larger files it needs to use a "list-of-4MB-chunks"
> approach to minimize the computation overhead for committing a
> randomly-modified file.  The "index" of course would be directly read
> and modified by vfs calls and via mapped memory.  Merge handling would
> need careful integration, preferably with allowing custom
> default-merge-handlers per subtree.  There would be lots more design
> issues to work out, but it's something to think about

Now you're just being silly ;)

> Cheers,
> Kyle Moffett

-- m. tharp
