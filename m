Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZE3HVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZE3HVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZE3HVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:21:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZE3HVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:21:07 -0400
Date: Sat, 30 May 2009 09:27:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: More thoughts about hwpoison and pageflags compression
Message-ID: <20090530072758.GL1065@one.firstfloor.org>
References: <200905291135.124267638@firstfloor.org> <20090529225202.0c61a4b3@lxorguk.ukuu.org.uk> <20090530063710.GI1065@one.firstfloor.org> <20090529235302.ccf58d88.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529235302.ccf58d88.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 11:53:02PM -0700, Andrew Morton wrote:
> On Sat, 30 May 2009 08:37:10 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > So using a separate bit is a sensible choice imho.
> 
> Could you make the feature 64-bit-only and use one of bits 32-63?

We could, but these systems can run 32bit kernels too (although
it's probably not a good idea). Ok it would be probably possible
to make it 64bit only, but I would prefer to not do that.

Also even 32bit has still flags free and even if we run out there's an easy 
path to free more (see my earlier writeup)

So I don't see the pressing need to conserve every bit on 32bit.

> Did you consider making the poison tag external to the pageframe?  Some
> hash(page*) into a bitmap or something?  If suitably designed, such
> infrastructure could perhaps be reused to reclaim some existing page
> flags.  Dave Hansen had such a patch a few years back.  Or maybe it
> was Andy Whitcroft.

I considered it at some point, but it would have complicated the code
and I preferred to keep it simple. The poison handler should be relatively
straight forward and do its work quickly otherwise it might not isolate
the page before it's actually used.
 
-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
