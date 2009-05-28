Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbZE1M0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbZE1M0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbZE1M0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:26:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:58465 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbZE1M0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:26:05 -0400
Date: Thu, 28 May 2009 14:26:06 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [9/16] HWPOISON: Use bitmask/action code for try_to_unmap behaviour
Message-ID: <20090528122606.GN6920@wotan.suse.de>
References: <200905271012.668777061@firstfloor.org> <20090527201235.9475E1D0292@basil.firstfloor.org> <20090528072703.GF6920@wotan.suse.de> <20090528080319.GA1065@one.firstfloor.org> <20090528082818.GH6920@wotan.suse.de> <874ov5fvm6.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ov5fvm6.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 11:02:41AM +0200, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > There are a set of "actions" which is what the callers are, then a
> > set of modifiers. Just make it all modifiers and the callers can
> > use things that are | together.
> 
> The actions are typically contradictory in some way, that is why
> I made them "actions". The modifiers are all things that could
> be made into flags in a straightforward way.
> 
> Probably it could be all turned into flags, but that would
> make the patch much more intrusive for rmap.c than it currently is,
> with some restructuring needed, which I didn't want to do.

I don't think that's a problem. It's ugly as-is.

 
> Hwpoison in general is designed to not be intrusive.

Some cosmetic or code restructuring is the least intrusiveness that
hwpoison is. It is very intrusive, not for lines added or changed,
but for how it interacts with the mm.

