Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZLHKfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZLHKfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZLHKfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:35:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZLHKfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:35:08 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1E189B.1070204@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 11:34:13 +0100
Message-ID: <1260268453.3935.1106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 18:12 +0900, Tejun Heo wrote:
> > So its only needed in order to flush a workqueue from CPU_DOWN_PREPARE?
> > And all you need it to place a new kthread on a !active cpu?
> 
> Yes, that's all I need. 

Then you don't need most of that patch, you don't need to touch the
migration stuff since a new kthread isn't running.

All you need to do is make a kthread_bind/set_cpus_allowed variant that
checks against cpu_online_mask instead of cpu_active_mask.

It might even make sense to have kthread_bind() always check with
cpu_online_mask as the kernel really ought to know what its doing
anyway.

You also don't need to play trickery with PF_THREAD_BOUND, since a new
kthread will not have that set.

In fact, your patch is against a tree that still has cpu_online_mask in
all those places, so you wouldn't have needed any of that, confused.. ?!

