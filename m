Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYEAKDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYEAKDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYEAKDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:03:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37576 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYEAKDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:03:00 -0400
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tim Bird <tim.bird@am.sony.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080501095822.GL20451@one.firstfloor.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <87bq3rgq40.fsf@basil.nowhere.org> <48190B5F.9010505@am.sony.com>
	 <20080501095822.GL20451@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 11:02:51 +0100
Message-Id: <1209636171.25560.508.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 11:58 +0200, Andi Kleen wrote:
> But I think CONFIG is not the right way to solve this.  The right way
> is for someone to take a look at new core features in linux-next/mm
> and see how much code size growth they have and then complain if they
> are significant and work with the submitter to make it better or offset
> changes by reducing other areas. For example each significant code growth
> should be justified with clear advantages, but right now nobody looks
> at that and challenges people. In fact I commented on that occasionally
> in my reviews and sometimes good pure misunderstanding and unbelief on the i
> ssue.  That is something the embedded stake holders need to change I think.
> 
> CONFIG if anything should be only last resort when everything else failed 
> there. 

To a large extent, I agree. I certainly don't want to focus solely on
code size; there's a lot more to embedded Linux than that. But it _is_
an issue. 

There are some cases where we really _do_ want to have CONFIG options,
but I agree that we should keep them to a minimum. And when we _do_ have
CONFIG options, they don't have to litter the actual code with ifdefs.
We're quite capable of having "function calls" which in some
configurations just turn out to be empty macros, etc...

> Also then not all kernel code growth is the same.  Also there is code growth 
> and code growth anyways.  you don't specify what is resource constrained. Is 
> it flash or is it RAM?

He wasn't talking about one specific system. There'll be an element of
both.

> If it's RAM first I believe you can get much
> more result-for-invested-work-and-maintenance-impact by focussing on dynamic
> memory allocations than on code size. I did a presentation about that a couple 
> of years ago with some numbers 
> (http://halobates.de/memory.pdf and http://halobates.de/memorywaste.pdf) 
> And CONFIG is definitely not the right way to approach that, the right
> way is better data structures, better algorithms to size tables, just
> some general care etc.

Stuff like shrinking the rbtree structure by encoding the colour in the
low bits of the parent pointer, perhaps? :)

> If it's flash that is the problem that is more difficult. First if you
> don't do XIP you can just use a better compression algorithm and get
> a lot of slack for free. 

Potentially at a cost of higher boot time, which is another
commonly-cited issue for such devices.

> If it's XIP then you might need to do some real code size reductions
> (including __init). 

I've never been that convinced about XIP. Flash is more expensive than
RAM, and cheap flash is NAND and not XIP-able these days anyway. The
only really convincing motivation for XIP would be the _power_ budget,
and if your power budget is _that_ tight, then often you'd be better off
with something like eCos instead of Linux anyway.

> I think one solution would be making code size and memory size impact 
> analysis general part of the code review / linux-next/mm testing 
> process. But really focus on the code itself, not on its CONFIG. CONFIG
> is just the easy way out, but it's also the wrong one.

Don't worry -- we're not going to start seeing a flurry of patches
adding CONFIG options and turning Linux into #ifdef hell :)

-- 
dwmw2

