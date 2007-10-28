Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXJ1XiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXJ1XiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXJ1XiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:38:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59650 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbXJ1XiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:38:16 -0400
Date: Sun, 28 Oct 2007 17:38:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028233814.GF32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <20071028213855.769741b6@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028213855.769741b6@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 09:38:55PM +0000, Alan Cox wrote:
> > It doesn't require the system to detect it, only mandate what to return
> > if it does detect it.
> 
> We should be detecting at least the obvious case.

What is the obvious case?  A task that has never called clone()?

> If SYSV only spots simple AB - BA deadlocks or taking the same lock twice
> yourself then that ought to be sufficient for us too.

You can't deadlock against yourself -- either with POSIX locks or BSD
locks (POSIX simple upgrades/downgrades the lock; each byte in a file
can only be in either read-locked state or write-locked state for a
given process.  BSD locks release the lock and wake all waiters before
attempting to acquire the lock in its new state).  In my other post, I
showed a simple AB-BA deadlock that can't be easily detected.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
