Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZLVSHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZLVSHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZLVSHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:07:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZLVSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:07:04 -0500
Date: Tue, 22 Dec 2009 19:07:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
Message-ID: <20091222180703.GI10314@basil.fritz.box>
References: <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop> <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261504042.4937.59.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've seen those consume significant amounts of cpu, now I'm not going to
> argue that workqueues are not the best way to consume lots of cpu, but
> the fact is they _are_ used for that.

AFAIK they currently have the following problems:
- Consuming CPU in shared work queues is a bad idea for obvious reasons
(but I don't think anybody does that)
- Single threaded work is well, single threaded and does not scale
and wastes cores.
- Per CPU work queues are bound to each CPU so that the scheduler
cannot properly load balance (so you might end up with over/under
subscribed CPUs)

One reason I liked a more dynamic frame work for this is that it
has the potential to be exposed to user space and allow automatic
work partitioning there based on available cores.  User space
has a lot more CPU consumption than the kernel.

I think Grand Central Dispatch does something in this direction. 
TBB would probably also benfit

Short term an alternative for the kernel would be also
to generalize the simple framework that is in btrfs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
