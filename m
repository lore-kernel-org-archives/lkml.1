Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZINJJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZINJJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbZINJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:09:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:50131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbZINJJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:09:45 -0400
Message-ID: <4AAE0841.6000305@kernel.org>
Date: Mon, 14 Sep 2009 18:09:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
References: <20090911174019.1ed02737@infradead.org>	 <20090914004301.105196cc.akpm@linux-foundation.org>	 <4AADF8FE.1060208@kernel.org> <1252916128.5699.41.camel@laptop>
In-Reply-To: <1252916128.5699.41.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 09:09:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Peter Zijlstra wrote:
>> If someone has any better ideas, I would happy to remove the annoying
>> restriction.
> 
> That sounds like a variable __attribute__((no-explicit-relocs)) should
> be proposed to the GCC folks or something. Then we can at least have a
> hope of lifting this restriction some time in the future.
> 
> (Alternatively we build the full alpha kernel with
> --mno-explicit-relocs, but that would be sub-optimal as well)
> 
> Not sure if s390 has anything similar..

If possible, something like __attribute__((dont-expect-it-to-be-near))
would be very nice in this case.

> Alternatively we could file it as a bug, since the symbols are in a
> custom .section, which is a strong indication we're going to play funny
> games anyway.

This sounds quite appealing but I think it has certain possibility of
coming back and bite us in the rear.

Hmmm... Offsets for symbols which fit in the first chunk are
guaranteed to be addressable with the reduced range and thus the weak
trick is only necessary for modules, so a solution we can implement in
kernel proper is to reserve address range for module text and data to
be loaded near the builtin text and data.  Percpu already supports
reservation in the first chunk (for x86-64 for example) so that part
is already there.  Ah... only if s390 and alpha are a little easier to
come by.  :-(

Thanks.

-- 
tejun
