Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXHaPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXHaPLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXHaPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:11:11 -0400
Received: from sandeen.net ([209.173.210.139]:23093 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbXHaPLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:11:10 -0400
Message-ID: <46D82F9A.9090606@sandeen.net>
Date: Fri, 31 Aug 2007 10:11:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Chinner <dgc@sgi.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>	 <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins>	 <20070831150511.GA734179@sgi.com> <1188572961.6112.72.camel@twins>
In-Reply-To: <1188572961.6112.72.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:
> 
>>> Trouble is, we'd like to have a sane upper bound on the amount of held
>>> locks at any one time, obviously this is just wanting, because a lot of
>>> lock chains also depend on the number of online cpus...
>> Sure - this is an obvious case where it is valid to take >30 locks at
>> once in a single thread. In fact, worst case here we are taking twice this
>> number of locks - we actually take 2 per inode (ilock and flock) so a
>> full 32 inode cluster free would take >60 locks in the middle of this
>> function and we should be busting this depth couter limit all the
>> time. 
> 
> I think this started because jeffpc couldn't boot without XFS busting
> lockdep :-)
> 
>> Do semaphores (the flush locks) contribute to the lock depth
>> counters? 
> 
> No, alas, we cannot handle semaphores in lockdep.

That explains why 40 was enough for me, I guess :)

-Eric
