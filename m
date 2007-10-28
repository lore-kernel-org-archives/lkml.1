Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXJ1ULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXJ1ULU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXJ1ULE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:11:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41061 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXJ1ULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:11:04 -0400
Date: Sun, 28 Oct 2007 14:11:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028201101.GA32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028184052.49abd092@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 06:40:52PM +0000, Alan Cox wrote:
> NAK. This is an ABI change. It was also comprehensively rejected before
> because
> 
> - EDEADLK behaviour is ABI

Not in any meaningful way.

> - EDEADLK behaviour is required by SuSv3

What SuSv3 actually says is:

	If the system detects that sleeping until a locked region is
	unlocked would cause a deadlock, fcntl() shall fail with an
	[EDEADLK] error.

It doesn't require the system to detect it, only mandate what to return
if it does detect it.

> - We have no idea what applications may rely on this behaviour.

I've never heard of one that does.

> so we need to fix the bugs - the lock usage and the looping. At that
> point it merely becomes a performance concern to those who use it, which
> is the proper behaviour. If you want a faster non-checking one use
> flock(), or add another flag that is a Linux "don't check for deadlock"

You can't fix the false EDEADLK detection without solving the halting
problem.  Best of luck with that.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
