Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZIUJyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZIUJyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZIUJyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:54:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:47427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZIUJyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:54:23 -0400
Message-ID: <4AB74D16.8050802@kernel.org>
Date: Mon, 21 Sep 2009 18:53:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Sachin Sant <sachinp@in.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie> <4AB740A6.6010008@kernel.org> <20090921094406.GI12726@csn.ul.ie>
In-Reply-To: <20090921094406.GI12726@csn.ul.ie>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 09:53:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mel Gorman wrote:
> On Mon, Sep 21, 2009 at 06:00:22PM +0900, Tejun Heo wrote:
>> Hello,
>>
>> Mel Gorman wrote:
>>>>> Can you please post full dmesg showing the corruption? 
>>> There isn't a useful dmesg available and my evidence that it's within the
>>> pcpu allocator is a bit weak.
>> I'd really like to see the memory layout, especially how far apart the
>> nodes are.
>>
> 
> Here is the console log with just your patch applied. The node layouts
> are included in the log although I note they are not far apart. What is
> also important is that the exact location of the bug is not reliable
> although it's always in accessing the same structure. This time it was a
> bad data access. The time after that, a BUG_ON triggered when locking a
> spinlock in the same structure. The third time, it locked up silently.
> Forth time, it was a data access error but a different address and so
> on.

One likely possibility is something accessing wrong percpu offset.
Can you please attach .config?

Thanks.

-- 
tejun
