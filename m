Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYHLGNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYHLGNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYHLGNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:13:33 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:20284 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267AbYHLGNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:13:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e0nOynr0+Y3ZZG9qNBByXXNsTFPPxkHuhs3EpDYVVlsb/mCcWcOgcT5Adq7q21+B2wO/ZwH+JeHp4s8LaLBY4YQwx7052qihqAZ5JfLNXEEIWXAXU27dI0iYk2xs+awKUW89iuAhwS99lSlfyY/E/BCplgAlNACEQc/zl8DqHm8=  ;
X-YMail-OSG: WQaeGtsVM1n.h1VhlZ6e.D0CG_nHlBe.nNra0flPWKRNPTjopj6rJoVaw3gBbGt9QxVDIAUaLFDV1K7MO2Ux3XZL7BCuEApJVGD45_Zzeb7lIOTayl9YPdDxGFrH00hVLM.t8dzsozKXr1x0z13dWyE2
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Tue, 12 Aug 2008 16:13:24 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu>
In-Reply-To: <20080811222026.GA20579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121613.24846.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> Linus,
>
> Please pull the latest core-fixes-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> core-fixes-for-linus
>
> 90% of the flux comes from lockdep - and most of the fixes are for
> long-standing bugs/weaknesses. (like the quadratic overhead bug David
> uncovered and fixed)
>
> The only non-strictly bugfix change is:
>
>    # f82b217: lockdep: shrink held_lock structure
>
> but Peter wrote and tested/improved that one together with other patches
> so i decided against extracting the commit artificially which would have
> been pretty invasive.
>
> Thanks,
>
> 	Ingo
>
> ------------------>
> Dave Jones (1):
>       lockdep: shrink held_lock structure
>
> David Miller (2):
>       lockdep: fix combinatorial explosion in lock subgraph traversal
>       debug_locks: set oops_in_progress if we will log messages.
>
> Ingo Molnar (2):
>       lockdep: rename map_[acquire|release]() =>
> lock_map_[acquire|release]() lockdep: increase MAX_LOCKDEP_KEYS
>
> Nick Piggin (1):
>       generic-ipi: fix stack and rcu interaction bug in
> smp_call_function_mask()

I'm still not 100% sure that I have this patch right... I might have seen
a lockup trace implicating the smp call function path... which may have
been due to some other problem or a different bug in the new call function
code, but if some more people can take a look at it before merging?
