Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbXLUIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbXLUIxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 03:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXLUIww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 03:52:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXLUIwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 03:52:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 09/43] compat_sys_ptrace
In-Reply-To: Christoph Hellwig's message of  Friday, 21 December 2007 07:11:02 +0000 <20071221071102.GB4345@infradead.org>
References: <20071220115200.C767E26F98A@magilla.localdomain>
	<20071220115551.73EE026F98B@magilla.localdomain>
	<20071221071102.GB4345@infradead.org>
X-Zippy-Says: Yow!  It's some people inside the wall!  This is better than mopping!
Message-Id: <20071221085216.30E4726F98A@magilla.localdomain>
Date: Fri, 21 Dec 2007 00:52:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nice, we should have unified the compat ptrace code long ago.

There is still more consolidation that can be done, but this is a first step.

> Any chance you could make the ifdef symetric to the native ptrace
> where an arch defines a symbol if it has it's own ptrace?

That would require touching each and every arch's headers so as
not to break it with the generic changes.  I seem to get berated
for that sort of thing more often than asked for it.

> Also when prototyping something like this I was wondering whether we
> really want a separate compat function.  Lots of the ptrace requests
> mostly depend on the target processes abi, not the ptrace caller, [...]

That's not really true of any ptrace request that isn't already
wholly arch-dependent, and not true of any majority of those either.
For all of the things that are likely to be handled in generic code
any time soon, it's the caller of ptrace whose natural data formats
reign.

> [...]  Anyway, that's probably something to worry about
> later one the arch-specific compat ptrace implementations are gone.

Indeed.


Thanks,
Roland
