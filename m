Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYDZJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYDZJb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYDZJbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:31:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYDZJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:31:21 -0400
Date: Sat, 26 Apr 2008 05:30:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080426093048.GA11443@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org> <1209155917.12461.46.camel@localhost.localdomain> <20080425211250.GA13858@infradead.org> <1209158552.12461.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209158552.12461.53.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 02:22:31PM -0700, Daniel Walker wrote:
> If you can make a case for converting some semaphores to spinlocks be my
> guest .. If you have good reasoning I wouldn't stand in the way.. (Real
> time converts all the spinlocks to mutexes anyway ..)

Right at hand I have the XFS inode hash lock was converted from a rw_semaphore
to a rwlock_t becuase the context switch overhead was killing
performance in various benchmarks. This is a very typical scenary for
locks that are taken often and held for a rather short time.  Add to
that fact that a spinlock is compltely optimized away for an UP kernel
while a mutex is not and the amount of memory that any mutex takes
compared to a spinlock you have a clear winner.

