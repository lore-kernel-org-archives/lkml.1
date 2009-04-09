Return-Path: <linux-kernel-owner+w=401wt.eu-S936748AbZDIVxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936748AbZDIVxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936700AbZDIVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:53:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936348AbZDIVxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:53:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <11730.1239311156@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, catalin.marinas@arm.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Date: Thu, 09 Apr 2009 22:51:37 +0100
Message-ID: <12327.1239313897@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ahh. I've never used stg. It seems to have some bad defaults.
> 
> Also, depending on exactly what "stg" does, it is entirely possible that 
> adding that
> 
> 	[diff]
> 		renames
> 
> to your .gitconfig won't help: those kinds of default configuration values 
> are (very much on purpose) ignored for certain low-level git commands, 
> exactly so that you can do reliable scripting without having to worry 
> about some user-specific config files.

That affects 'stg show' but not 'stg mail'.


It looks like 'stg mail' is generating the stats with git-apply on the results
of a diff:

	def diffstat(files = None, rev1 = 'HEAD', rev2 = None):
	    """Return the diffstat between rev1 and rev2."""
	    return GRun('apply', '--stat', '--summary'
			).raw_input(diff(files, rev1, rev2)).raw_output()

which seems to mean that I can't reduce them from the:

 arch/frv/include/asm/Kbuild              |    5 
 arch/frv/include/asm/atomic.h            |  198 +++++++++++
 arch/frv/include/asm/auxvec.h            |    4 
 arch/frv/include/asm/ax88796.h           |   22 +
 arch/frv/include/asm/bitops.h            |  412 +++++++++++++++++++++++
 arch/frv/include/asm/bug.h               |   53 +++
 ...
 include/asm-frv/Kbuild                   |    5 
 include/asm-frv/atomic.h                 |  198 -----------
 include/asm-frv/auxvec.h                 |    4 
 include/asm-frv/ax88796.h                |   22 -
 include/asm-frv/bitops.h                 |  412 -----------------------
 include/asm-frv/bug.h                    |   53 ---
 ...

to the:

 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0
 {include/asm-frv => arch/frv/include/asm}/auxvec.h |    0
 .../asm-frv => arch/frv/include/asm}/ax88796.h     |    0
 {include/asm-frv => arch/frv/include/asm}/bitops.h |    0
 {include/asm-frv => arch/frv/include/asm}/bug.h    |    0

though it is using git-diff-tree to generate the rest of the patch, which I
can affect with the diff options, it would appear.

Is there a way to get git-diff to produce just the stats and summary and not
the body of the patch?

David
