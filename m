Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbXJ1Xbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbXJ1Xbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXJ1XbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:31:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33473 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJ1XbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:31:21 -0400
Date: Sun, 28 Oct 2007 17:31:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028233119.GE32359@parisc-linux.org>
References: <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org> <20071028224157.GC32359@parisc-linux.org> <Pine.LNX.4.64.0710282349470.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710282349470.18815@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 11:55:52PM +0100, Jiri Kosina wrote:
> On Sun, 28 Oct 2007, Matthew Wilcox wrote:
> 
> > Bzzt.  You get a false deadlock with multiple threads like so:
> > Thread A of task B takes lock 1
> > Thread C of task D takes lock 2
> > Thread C of task D blocks on lock 1
> > Thread E of task B blocks on lock 2
> 
> 	A potential for deadlock occurs if a process controlling a locked 
> 	region is put to sleep by attempting to lock another process' 
> 	locked region. If the system detects that sleeping until a locked 
> 	region is unlocked would cause a deadlock, fcntl() shall fail with 
> 	an [EDEADLK] error.
> 
> This is what POSIX says [1], even after being modified with respect to 
> POSIX Threads Extension, right?
> 
> So it doesn't deal with threads at all, just processess are taken into 
> account. Probably for a reason :)

Did you have a concrete suggestion, or are you just quoting the spec?

The problem is that it's nonsense -- processes don't sleep, threads do.
I think the key is "would deadlock", not "might deadlock".  Our current
behaviour is clearly in violation of SuSv3.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
