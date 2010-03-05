Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0CET4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:56:03 -0500
Received: from tenax.loup.net ([209.169.16.66]:51958 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab0CET4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:56:00 -0500
Date: Fri, 5 Mar 2010 12:43:54 -0700
Message-Id: <201003051943.o25Jhs6w012994@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: jmoyer@redhat.com
CC: mvds.00@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <x49sk8ezrfq.fsf@segfault.boston.devel.redhat.com> (message from
	Jeff Moyer on Fri, 05 Mar 2010 11:03:37 -0500)
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com> <x49sk8ezrfq.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

 > I guess I should note that I've suggested nonblocking I/O for files
 > before:
 > 
 >   http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-10/0290.html
 > 
 > I'll also note that enabling such a patch broke apps that accessed cd
 > burners, for example, since O_NONBLOCK had some preexisting semantics
 > there that I fail to recall.

Sounds like nonblocking read/write calls are strongly tied to threads
instead of state related to a file descriptor.  I haven't poked around
in there, but perhaps the current linux io architecture is just too
set in stone to design an efficient non blocking mechanism.  It would
be a shame not to fix it simply because some broken apps depend upon
blocking behavior when they have been explicitly specifying O_NONBLOCK
via open or fcntl.

At least for now we can describe it's actual behavior in the man
pages; I will be submitting a man page patch for consideration later
today.

- Mike
