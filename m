Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752367AbYLRQjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbYLRQjK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYLRQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:38:55 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45179 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbYLRQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:38:55 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <1229597162.1047.48.camel@penberg-laptop>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
	 <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
	 <1229597162.1047.48.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 18 Dec 2008 16:38:28 +0000
Message-Id: <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 16:38:30.0357 (UTC) FILETIME=[0F39C050:01C9612F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 12:46 +0200, Pekka Enberg wrote:
> On Fri, 2008-12-12 at 14:27 +0000, Catalin Marinas wrote:
> > > Do you take care of the per-node lists as well?
> > 
> > I can't figure out what other location should be erased.
> 
> As far as I can tell, you need to tell kmemleak not to scan the alien
> caches and the shared array that is shared by all CPUs that belong to
> one node. I'm adding Christoph to the CC in case he wants to comment on
> this.

In the ____cache_alloc() kmemleak clears the
cachep->array->entry[ac->avail] pointer but this may not be enough as
freed and later re-allocated objects may have pointers in the alien
cache (is that correct?). A better approach (haven't tried it yet) would
be not to scan objects allocated via alloc_arraycache() at all. However,
there is still the initarray_cache/generic which are automatically
scanned via the data section (unless I add an attribute to place them in
a different, not scanned, section).

-- 
Catalin

