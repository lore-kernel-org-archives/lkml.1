Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZE0Iq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZE0Iq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZE0IqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:46:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47260 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZE0IqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:46:03 -0400
Date: Wed, 27 May 2009 10:52:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527085237.GV846@one.firstfloor.org>
References: <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org> <20090526231428.GK846@one.firstfloor.org> <20090526162821.02e11d5b.akpm@linux-foundation.org> <20090526234109.GL846@one.firstfloor.org> <20090526164532.6c780234.akpm@linux-foundation.org> <20090527001104.GN846@one.firstfloor.org> <20090526172935.fad52c49.akpm@linux-foundation.org> <20090527073136.GT846@one.firstfloor.org> <20090527004525.1d70c134.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527004525.1d70c134.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey, don't look at me - blame Brian Kernighan or George Bush or
> someone.

Heh.

What I meant is: if it makes sense to retry the kernel should do that
on its own. It has better information about the circumstances anyways.
And it would make sense to put all such logic into a single place
instead of all programs.

If it doesn't we shouldn't try to force that to user space. That would be similar
to signal handling without SA_RESTART which I think nearly everyone agrees was one
of the worst APIs in Unix ever.

In most cases (e.g. out of memory) it likely doesn't make much sense to
retry anyways.

So short write always means error.


> > And the same applies to in-kernel users really.
> 
> We could delete a rather nice amount of tricky VFS code if we were to
> make this assumption.  But of course we daren't do that.

What do you mean?

> 
> And as long as we're attempting to correctly handle partial writes all
> over the kernel, it's a bit dopey to deliberately avoid doing this at one
> particular codesite.
> 
> I bet glibc handles partial writes...

I just spent some time nagivating through the glibc stdio me^wmaze 
and I don't see any retry loops.

Also even if it did there would be lots of other users
(google codesearch has >23 million hits for "write")

> > a lot of things start failing.
> 
> The kernel should only fail if it has no other option.

Typically short write means no other option.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
