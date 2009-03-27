Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZC0LZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZC0LZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZC0LYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:24:53 -0400
Received: from thunk.org ([69.25.196.29]:52562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZC0LYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:24:52 -0400
Date: Fri, 27 Mar 2009 07:24:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327112438.GQ6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327062114.GA18290@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 06:21:14AM +0000, Matthew Garrett wrote:
> And, hey, fsync didn't make POSIX proper until 1996. It's not like 
> authors were able to depend on it for a significant period of time 
> before ext3 hit the scene.

Fsync() was in BSD 4.3 and it was in much earlier Unix specifications,
such as SVID, well before it appeared in POSIX.  If an interface was
in both BSD and AT&T System V Unix, it was around everywhere.

> (It could be argued that most relevant Unices implemented fsync() even 
> before then, so its status in POSIX was broadly irrelevant. The obvious 
> counterargument is that most relevant Unix filesystems ensure that data 
> is written before a clobbering rename() is carried out, so POSIX is 
> again not especially releant)

Nope, not true.  Most relevant Unix file systems sync'ed data blocks
on a 30 timer, and metadata on 5 second timers.  They did *not* force
data to be written before a clobbering rename() was carried you;
you're rewriting history when you say that; it's simply not true.
Rename was atomic *only* where metadata was concerned, and all the
talk about rename being atomic was because back then we didn't have
flock() and you built locking primitives open(O_CREAT) and rename();
but that was only metadata, and that was only if the system didn't
crash.

When I was growing up we were trained to *always* check error returns
from *all* system calls, and to *always* fsync() if it was critical
that the data survive a crash.  That was what competent Unix
programmers did.  And if you are always checking error returns, the
difference in the Lines of Code between doing it right and doing
really wasn't that big --- and again, back then fsync() wan't
expensive.  Making fsync expensive was ext3's data=ordered mode's
fault.

Then again, most users or system administrators of Unix systems didn't
tolerate device drivers that would crash your system when you exited a
game, either....  and I've said that I recognize the world has changed
and that crappy application programmers outnumber kernel programers,
which is why I coded the workaround for ext4.  That still doesn't make
what they are doing correct.

     	   	      	     	      	     - Ted
