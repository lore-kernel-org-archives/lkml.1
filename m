Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZBYC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZBYC3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZBYC3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:29:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZBYC3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:29:05 -0500
Message-ID: <49A4ACAE.4020104@kernel.org>
Date: Wed, 25 Feb 2009 11:27:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu> <20090224234949.GA1778@cmpxchg.org>
In-Reply-To: <20090224234949.GA1778@cmpxchg.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Feb 2009 02:27:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Johannes Weiner wrote:
> No, when the patch was submitted for review, I pointed out the change
> in semantics and gathered from Tejun's reaction that this wasn't done
> intentionally.  So the problem is the change itself, not the missing
> declaration.

Yeah, I should have regenerated the tree.  Sorry about that.

>>From the original mail:
> 
> 	Johannes Weiner wrote:
> 	> This won't suffice as reserve_bootmem() doesn't use
> 	> alloc_bootmem_core(), so now you effectively removed the
> 	> node-0 restriction for reserve_bootmem() on this
> 	> configuration.
> 
> 	Ah... right.  :-(
> 
> I just wrote again because I didn't understand why Tejun acknowledged
> the error in the patch and then it went into -tip anyway.
> 
> The other part of my email was just suggestions for a cleanup, I
> wasn't referring to that when I said 'broken' - sorry if that is how
> it came over.

It seems that the wrapping thing was broken both before and after the
patch and can lead to panic on free path.  I'll soon post a patch to
fix it.

Thanks.

-- 
tejun
