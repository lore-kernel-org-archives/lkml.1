Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbXL0XA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbXL0XA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXL0XAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:00:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34138 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXL0XAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:00:21 -0500
Date: Thu, 27 Dec 2007 22:59:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
Message-ID: <20071227225947.GH27894@ZenIV.linux.org.uk>
References: <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com> <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org> <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com> <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com> <20071226221631.GD27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 12:28:14PM -0800, Christoph Lameter wrote:
> Hmmm.. If I separately allocate the kobject then I can no longer get to 
> the kmem_cache structure from the kobject. 
> 
> I need to add a second kobject_del to sysfs_slab_remove() to make sysfs 
> completely forget about the object?
> 
> Probably should track down any remaining symlinks at that point and nuke 
> them too. Isnt there some way to convince sysfs to remove the symlinks 
> if the target vanishes?

Don't bother with separate allocation.

a) remove symlink when slab goes away
b) instead of kfree() in slab removal do kobject_put() if you have sysfs stuff
c) have ->release() of these kobjects do kfree()
