Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbXHONNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbXHONNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbXHONN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:13:26 -0400
Received: from sidhe.atheme.org ([204.15.224.234]:54821 "EHLO sidhe.atheme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbXHONNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:13:25 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 09:13:25 EDT
Message-ID: <46C2F96D.5030908@partiallystapled.com>
Date: Wed, 15 Aug 2007 09:02:37 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070723)
MIME-Version: 1.0
To: alan <alan@clueserver.org>
CC: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org>
In-Reply-To: <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alan wrote:
> Imagine the fun you will have trying to write a file name and being told
> you cannot write it for some unknown reason.  Unbeknownst to you, there
> is a file there, but it is not owned by you, thus invisible.

This jumped out at me right away. In such a system, an attacker with
write permissions on a "sticky" directory like /tmp could probe for
others' files by attempting to create them and recording all cases where
permission was denied due to an existing, hidden file. But of course,
this was just an example of something a less UNIX-y permission scheme
could do, not a key part of such a design.

Personally, what I'd like to see is a better way of dealing with
propagation of ownership. Currently, in order to allow "collaboration"
directories where a directory tree is owned by a certain group and
anyone in that group can write and create files, one has to change the
system umask, use a magical bit on the collaboration directory to
propagate group ownership, and create a group for every user on the
system in order to keep their personal files safe with the new umask.
This seems highly flawed. I suggest that propagation of group ownership
should be the default mode, not a special one, and that the
group-writable permissions should also be propagated to new files and
directories. This way, the user's home directory would remain 0755,
while the collaboration directory could be 0775, without any changing of
umasks.

Of course, this would go against tradition, and cause some mayhem in the
logic responsible for magically determining permissions for new files,
but since we're talking about thinking outside of the box, I think
that's excusable :)

  -- m. tharp
