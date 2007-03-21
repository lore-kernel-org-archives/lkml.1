Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXCUUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXCUUCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964790AbXCUUB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:01:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:61042 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788AbXCUUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:01:57 -0400
X-AuditID: d80ac287-a106abb000000de9-2b-46018f332691 
Date: Wed, 21 Mar 2007 20:01:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Kees Cook <kees@outflux.net>
cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Marcus Meissner <meissner@suse.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@codemonkey.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: revert PIE randomization?
In-Reply-To: <20070321181730.GV22797@outflux.net>
Message-ID: <Pine.LNX.4.64.0703211940370.24602@blonde.wat.veritas.com>
References: <20070321181730.GV22797@outflux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Mar 2007 20:01:51.0441 (UTC) FILETIME=[C416EC10:01C76BF3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Kees Cook wrote:
> Hugh Dickins said:
> > Inconsistency detected by ld.so: rtld.c: 1217: dl_main:
> >  Assertion `_rtld_local._dl_rtld_map.l_libname' failed!
> 
> I'm trying to reproduce the problem you saw (so that I can then test 
> your proposed fix).  However, I haven't had any luck.  I've got a 
> pie-compiled version of bash, and I've been running it in a loop for a 
> while now with the original randomization patch.  (I can clearly see the 
> base address bouncing around.)
> 
> I'm at just over 10 million exec's, and I haven't hit the problem.  :(
> 
> Do you have any clues on how to trigger this more reliably?

It was in doing kernel builds that I hit it, nothing special: an
overnight cycle of kernel building would collapse in a few hours.
openSUSE 10.2.

If that doesn't reproduce it for you, let me know and I'll try again
with the original patch, to reproduce it here: maybe something else
has changed in 2.6.21-rc to affect it.

> 
> Also, does anyone have any thoughts on why x86 uses a ELF_ET_DYN_BASE 
> below the libraries, where as x86_64 uses one above them?  From this, 
> I'd expect x86_64 to collide with the libraries at times.  I need more 
> help understanding the memory layouts, I guess.  :)

Andi would tell definitively, but I guess it's merely that with so
much more address space to play with, x86_64 can divide up that space
more satisfactorily.

But don't be misled: try "ulimit -s unlimited" and I expect you'll
find i386 allocating mmap addresses (hence libraries) from the
opposite end, below ELF_ET_DYN_BASE.

Hugh
