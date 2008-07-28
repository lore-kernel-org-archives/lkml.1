Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbYG1ROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbYG1ROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYG1ROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:14:05 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26934 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758808AbYG1ROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:14:01 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 12/30] mm: memory reserve management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Neil Brown <neilb@suse.de>,
       cl@linux-foundation.org
In-Reply-To: <1217264374.15724.42.camel@calx>
References: <20080724140042.408642539@chello.nl>
	 <20080724141530.127530749@chello.nl>
	 <1217239564.7813.36.camel@penberg-laptop>  <1217240224.6331.32.camel@twins>
	 <1217240994.7813.53.camel@penberg-laptop>  <1217241541.6331.42.camel@twins>
	 <1217264374.15724.42.camel@calx>
Content-Type: text/plain; charset=utf-8
Date: Mon, 28 Jul 2008 19:13:46 +0200
Message-Id: <1217265226.18049.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 11:59 -0500, Matt Mackall wrote:
> On Mon, 2008-07-28 at 12:39 +0200, Peter Zijlstra wrote:
> > Also, you might have noticed, I still need to do everything SLOB. The
> > last time I rewrote all this code I was still hoping Linux would 'soon'
> > have a single slab allocator, but evidently we're still going with 3 for
> > now.. :-/
> >
> > So I guess I can no longer hide behind that and will have to bite the
> > bullet and write the SLOB bits..
> 
> ﻿I haven't seen the rest of this thread, but I presume this is part of
> your OOM-avoidance for network I/O framework?

Yes indeed.

> SLOB can be pretty easily expanded to handle a notion of independent
> allocation arenas as there are only a couple global variables to switch
> between. ﻿kfree will also return allocations to the page list (and
> therefore arena) from whence they came. That may make it pretty simple
> to create and prepopulate reserve pools.

Right - currently we let all the reserves sit on the free page list. The
advantage there is that it also helps the anti-frag stuff, due to having
larger free lists.

