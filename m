Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbXJ1S16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbXJ1S16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXJ1S1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:27:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55900 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXJ1S1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:27:34 -0400
Date: Sun, 28 Oct 2007 12:27:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028182732.GK27248@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028174321.GB16905@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 01:43:21PM -0400, J. Bruce Fields wrote:
> We currently attempt to return -EDEALK to blocking fcntl() file locking
> requests that would create a cycle in the graph of tasks waiting on
> locks.
> 
> This is inefficient: in the general case it requires us determining
> whether we're adding a cycle to an arbitrary directed acyclic graph.
> And this calculation has to be performed while holding a lock (currently
> the BKL) that prevents that graph from changing.
> 
> It has historically been a source of bugs; most recently it was noticed
> that it could loop indefinitely while holding the BKL.

It can also return -EDEADLK spuriously.  So yeah, just kill it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
