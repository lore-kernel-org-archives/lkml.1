Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYHIAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYHIAOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 20:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYHIAOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 20:14:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYHIAOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 20:14:22 -0400
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
From: Andi Kleen <andi@firstfloor.org>
References: <20080808193753.GA21964@linux-os.sc.intel.com>
Date: Sat, 09 Aug 2008 02:14:18 +0200
In-Reply-To: <20080808193753.GA21964@linux-os.sc.intel.com> (Venki Pallipadi's message of "Fri, 8 Aug 2008 12:37:53 -0700")
Message-ID: <871w0z3uzp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
>
> One way to solve the problem is to have CPU A wait as long as there is a rcu
> read happening. But, we cannot use synchronize_rcu() here as we cannot block.
> Another way around is to always allocate call_function_data, instead
> of using CPU A's stack. Below patch does this. But, that will still have to
> handle the kmalloc failure case somehow.
>
> Any other ideas on how to solve this problem?

Perhaps it needs a custom RCU cycle? That is possible to define
with some effort.

I would feel uneasy about always allocating. GFP_ATOMIC can fail and I
expect most callers are not prepared to do handle that and in many
cases there is not even a good way. Now that there are patches
floating around even using this for the tlb flush that would be
deadly.

-Andi
