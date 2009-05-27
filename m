Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbZE0H0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbZE0H0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbZE0HZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:25:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761689AbZE0HZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:01 -0400
Date: Wed, 27 May 2009 09:31:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527073136.GT846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org> <20090526231428.GK846@one.firstfloor.org> <20090526162821.02e11d5b.akpm@linux-foundation.org> <20090526234109.GL846@one.firstfloor.org> <20090526164532.6c780234.akpm@linux-foundation.org> <20090527001104.GN846@one.firstfloor.org> <20090526172935.fad52c49.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526172935.fad52c49.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 05:29:35PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 02:11:04 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > I dunno.  Is this true of all linux filesystems in all cases?  Maybe.
> > 
> > Assuming one of them is not would you rather want to fix that file system
> > or 10 zillion user programs (including the kernel core dumper) that 
> > get it wrong? @)
> > 
> 
> I think that removing one bug is better than adding one.
> 
> Many filesystems will return a short write if they hit a memory
> allocation failure, for example.  pipe_write() sure will.  Retrying
> is appropriate in such a case.

Sorry but are you really suggesting every program in the world that uses
write() anywhere should put it into a loop? That seems just like really
bad API design to me, requiring such contortions in a fundamental
system call just to work around kernel deficiencies.

I can just imagine the programmers putting nasty comments
about the Linux kernel on top of those loops and they would
be fully deserved.

And the same applies to in-kernel users really.

The memory allocation case more sounds like a bug in these fs and
in pipe.

e.g. the network stack sleeps waiting for memory, perhaps these
file systems should too.

Or it should just always return -ENOMEM. Typically when the 
system is badly out of memory you're gonna lose anyways because
a lot of things start failing.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
