Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZC3M1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZC3M1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZC3M1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:27:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbZC3M1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:27:15 -0400
Date: Mon, 30 Mar 2009 14:27:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
Message-ID: <20090330122712.GF31000@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090329155750.062096365@nick.local0.net> <878wmnnr73.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wmnnr73.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:14:08PM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > We can turn the dcache hash locking from a global dcache_hash_lock into
> > per-bucket locking.
> 
> Per bucket locking is typically a bad idea because you get far too
> many locks and you increase cache footprint with all of them. It's
> typically better to use a second much smaller hash table that only has
> locks (by just shifting the hash value down some more) 
> Just need to be careful to avoid too much false sharing.

It's interesting. I suspect that with the size of the dcache hash,
if we assume pretty random distribution of access patterns, then
it might be unlikely to get much common cache lines (ok, birthday
paradox says we'll get a few common cachelines but how many?). So
then if we have to go to a 2nd lock hash table then that might
actually increase our cacheline footprint.

Of course RAM footprint will be more.

Anyway, I did think of this and it is something to discus in
future, but for now at least it is a demonstration of how it becomes
quite easy to change locking after we have broken the locking into
these components.
