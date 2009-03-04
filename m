Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCDQlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCDQlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 11:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZCDQkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 11:40:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:50189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZCDQkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:40:52 -0500
Message-ID: <49AEAEF2.7040908@kernel.org>
Date: Thu, 05 Mar 2009 01:40:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: percpu allocator vs reclaim
References: <1236184563.5330.8074.camel@laptop>
In-Reply-To: <1236184563.5330.8074.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 16:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Hi Tejun,
> 
> Thomas hit the below on recent -tip kernels.
> 
> Which basically states that we could deadlock due to reclaim lock
> recursion.
> 
> Looking at the code I don't see a quick solution, other than using
> GFP_NOFS, which is a bit of a bother (as I suspect it might easily grow
> __GFP_IO inversion too, if it doesn't already have it).

Ah... maybe percpu allocator should just swallow @gfp.  Any better
ideas? :-(

-- 
tejun
