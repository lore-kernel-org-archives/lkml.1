Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXJ1W4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXJ1W4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXJ1W4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:56:39 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42905 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXJ1W4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:56:38 -0400
Date: Sun, 28 Oct 2007 23:55:52 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Matthew Wilcox <matthew@wil.cx>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
In-Reply-To: <20071028224157.GC32359@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710282349470.18815@twin.jikos.cz>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com>
 <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org>
 <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org>
 <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
 <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org>
 <20071028224157.GC32359@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Matthew Wilcox wrote:

> Bzzt.  You get a false deadlock with multiple threads like so:
> Thread A of task B takes lock 1
> Thread C of task D takes lock 2
> Thread C of task D blocks on lock 1
> Thread E of task B blocks on lock 2

	A potential for deadlock occurs if a process controlling a locked 
	region is put to sleep by attempting to lock another process' 
	locked region. If the system detects that sleeping until a locked 
	region is unlocked would cause a deadlock, fcntl() shall fail with 
	an [EDEADLK] error.

This is what POSIX says [1], even after being modified with respect to 
POSIX Threads Extension, right?

So it doesn't deal with threads at all, just processess are taken into 
account. Probably for a reason :)

[1] http://www.opengroup.org/onlinepubs/009695399/functions/fcntl.html

-- 
Jiri Kosina
