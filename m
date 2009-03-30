Return-Path: <linux-kernel-owner+w=401wt.eu-S1751114AbZC3M3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbZC3M3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZC3M3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:29:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:45130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbZC3M3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:29:05 -0400
Date: Mon, 30 Mar 2009 14:29:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/14] fs: use RCU / seqlock logic for reverse and multi-step operaitons
Message-ID: <20090330122902.GG31000@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090329155749.609663166@nick.local0.net> <874oxbnr2m.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874oxbnr2m.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:16:49PM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> > operations over the directory tree by excluding modifications to the tree.
> > Also, to walk in the leaf->root direction in the tree where we don't have
> > a natural d_lock ordering. This is the hardest bit.
> 
> General thoughts: is there a way to add a self testing infrastructure
> to this. e.g. by having more sequence counts per object (only enabled
> in the debug case, so it doesn't matter when cache line bounces) and lots of 
> checks? 
> 
> I suppose that would lower the work needed of actually fixing this to 
> work significantly.

Might be a good idea. I'll think about whether it can be done.

Note that I *think* the idea is pretty sound, but I'm just not
quite sure about checking for parent being deleted when we're 
walking back up the tree -- d_unhashed() doesn't seem to work
because we can encounter unhashed parents by design. We might
just need another d_flag...

