Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZGHKgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZGHKgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZGHKgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:36:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52324 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZGHKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:36:16 -0400
Date: Sat, 4 Jul 2009 04:46:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: vapier.adi@gmail.com, rgetz@blackfin.uclinux.org, lethal@linux-sh.org,
       gerg@uclinux.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when
	calculating the stack size
Message-ID: <20090704024606.GE1345@ucw.cz>
References: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-01 13:08:14, David Howells wrote:
> Ignore the loader's PT_GNU_STACK when calculating the stack size, and only
> consider the executable's PT_GNU_STACK, assuming the executable has one.
> 
> Currently the behaviour is to take the largest stack size and use that, but
> that means you can't reduce the stack size in the executable.  The loader's
> stack size should probably only be used when executing the loader directly.
> 
> WARNING: This patch is slightly dangerous - it may render a system inoperable
> if the loader's stack size is larger than that of important executables, and
> the system relies unknowingly on this increasing the size of the stack.

The patch seems wrong to me; loader needs the stack, too, right?

What about making sure that the loader specifies reasonable stack
size, instead?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
