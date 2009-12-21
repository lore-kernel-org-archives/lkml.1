Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZLULJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZLULJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZLULJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:09:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33715 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZLULJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:09:32 -0500
Date: Mon, 21 Dec 2009 12:09:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
Message-ID: <20091221110929.GF25372@basil.fritz.box>
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221091754.GG4489@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 10:17:54AM +0100, Jens Axboe wrote:
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

Agreed. Even if possible thousands of threads waste precious cache.
And they look ugly in ps.

Also the nice thing about dynamically sizing the thread pool
is that if something bad (error condition that takes long) happens 
in one work queue for a specific subsystem there's still a chance 
to make process with other operations in the same subsystem.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
