Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZLUKhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZLUKhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZLUKhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:37:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:39268 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZLUKhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:37:04 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
In-Reply-To: <20091221091754.GG4489@kernel.dk>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>
	 <4B2B9949.1000608@linux.intel.com>  <20091221091754.GG4489@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 11:35:28 +0100
Message-ID: <1261391728.4314.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 10:17 +0100, Jens Axboe wrote:
> On Fri, Dec 18 2009, Arjan van de Ven wrote:
> > in addition, threads are cheap. Linux has no technical problem with
> > running 100's of kernel threads (if not 1000s); they cost basically a
> > task struct and a stack (2 pages) each and that's about it.  making an
> > elaborate-and-thus-fragile design to save a few kernel threads is
> > likely a bad design direction...
> 
> One would hope not, since that is by no means outside of what you see on
> boxes today... Thousands. The fact that they are cheap, is not an
> argument against doing it right. Conceptually, I think the concurrency
> managed work queue pool is a much cleaner (and efficient) design.

If your only concern is the number if idle threads, and it reads like
that, then there is a much easier solution for that.

But I tend to agree with Arjan, who cares if there's thousands idle
threads around.

The fact is that this concurrent workqueue stuff really only works with
works that don't consume CPU, and that's simply not the case today,
there are a number of workqueue users which really do burn CPU.

But even then, the corner cases introduced by memory pressure and
reclaim just make the whole thing an utterly fragile mess.

