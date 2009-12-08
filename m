Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZLHLs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZLHLs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZLHLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:48:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:48239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZLHLsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:48:55 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1E378A.5050101@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>
	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 12:48:05 +0100
Message-ID: <1260272885.3935.1189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 20:24 +0900, Tejun Heo wrote:
> 
> Let me augment the above sentence.  Yes, that's all I need *during
> CPU_DOWN*.  During CPU_UP, I need to migrate back left running workers
> which survived from the last CPU_DOWN.  In the original patch, the
> down path is worker_maybe_bind_and_lock() and the latter path is
> trustee_unset_rogue(). 

Why bother with that?

workqueue's CPU_POST_DEAD will flush the workqueue and destroy all
threads under cpu_add_remove_lock, which excludes the cpu from coming
back up before its fully destroyed.

So there's no remaining tasks to be migrated back.

Changing that semantics is not worthwhile.

