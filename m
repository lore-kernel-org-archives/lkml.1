Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbXJ2JQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbXJ2JQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXJ2JQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:16:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38316 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbXJ2JQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:16:46 -0400
Date: Mon, 29 Oct 2007 10:15:19 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
In-Reply-To: <20071029022922.GD10307@fieldses.org>
Message-ID: <Pine.LNX.4.64.0710291011190.18815@twin.jikos.cz>
References: <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org>
 <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu>
 <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org>
 <20071028224157.GC32359@parisc-linux.org> <20071028224833.66dc4243@the-village.bc.nu>
 <20071028225559.GD32359@parisc-linux.org> <20071028233826.24907fba@the-village.bc.nu>
 <20071029022922.GD10307@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, J. Bruce Fields wrote:

> But, OK, if we can identify unshared current->files at the time we put a 
> task to sleep, then a slight modification of our current algorithm might 
> be sufficient to detect any deadlock that involves purely posix file 
> locks and processes.  And we can tell people that avoiding deadlock is 
> their problem as soon as any task with a shared current->files is 
> involved.  (Ditto, I assume, if nfsd/lockd acquires a lock.)

Don't forget that comparing file_lock->fl_owner (i.e. current->files) is 
not the only way how lock ownership could be computed (there could be 
specific file_lock->fl_lmops->fl_compare_owner() and all of them should 
be teached this new semantics, right?).

-- 
Jiri Kosina
