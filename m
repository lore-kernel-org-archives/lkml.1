Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXJ0Rro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXJ0Rro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXJ0Rr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:47:29 -0400
Received: from 1wt.eu ([62.212.114.60]:3571 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbXJ0Rr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:47:27 -0400
Date: Sat, 27 Oct 2007 19:38:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Marc Lehmann <linux-kernel@tst.eu>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll design problems with common fork/exec patterns
Message-ID: <20071027173828.GY10199@1wt.eu>
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de> <Pine.LNX.4.64.0710270950170.12127@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710270950170.12127@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 09:59:07AM -0700, Davide Libenzi wrote:
> On Sat, 27 Oct 2007, Marc Lehmann wrote:
> 
> > > Please provide some code to illustrate one exact problem you have.
> > 
> >    // assume there is an open epoll set that listens for events on fd 5
> >    if (fork () = 0)
> >      {
> >        close (5);
> >        // fd 5 is now removed from the epoll set of the parent.
> >        _exit (0);
> >      }
> 
> Hmmm ... what? I assume you know that:
> 
> 1) A file descriptor is a userspace view/handle of a kernel object
> 
> 2) The kernel object has a use-count for as many file descriptors that 
>    have been handed out to userspace
> 
> 3) A close() decreases the internal counter by one
> 
> 4) The kernel object gets effectively closed when the internal counter 
>    goes to zero
> 
> 5) A fork() acts as a dup() on the file descriptors by hence bumping up 
>    its internal counter
> 
> 6) Epoll removes the file from the set, when the *kernel* object gets 
>    closed (internal use-count goes to zero)
> 
> With that in mind, how can the code snippet above trigger a removal from 
> the epoll set?

Davide,

from what I understand, Marc is not asking for the code above to remove
the fd from the epoll set, but he's in fact complaining that he *observed*
that the fd was removed from the epoll set in the *parent* process when
the child closes it, which is of course not expected at all. As strange
as it looks like, this might need investigation. It is possible that there
is some strange bug somewhere in some kernel versions.

Marc, I think that if you indicate the last kernel version on which you
observed this and provide a very short and easy reproducer, it would
help everyone investigating this. Basically something which reports "OK"
or "KO".

Regards,
Willy

