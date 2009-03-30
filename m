Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbZC3SCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbZC3SCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZC3SCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:02:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZC3SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:02:09 -0400
Date: Mon, 30 Mar 2009 14:00:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
Message-ID: <20090330180031.GB1041@infradead.org>
References: <20090329155539.275927173@nick.local0.net> <20090329155750.062096365@nick.local0.net> <878wmnnr73.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wmnnr73.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
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

Yeah, I'm also not too happy about it.  I think we're better off
replacing the global hash with more fine-grained structures.  That might
even some sort of simplistic tree hanging of directory dentries.

The hard part in getting anything like this done was always the amount
of different things dcache_lock protects besiseds the hash, but Nick's
earlier patches when actually fully implemented should sort that out.
