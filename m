Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYIHQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYIHQDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIHQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:03:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46911 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752665AbYIHQDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:03:05 -0400
Message-ID: <48C54CB6.5010707@sgi.com>
Date: Mon, 08 Sep 2008 09:03:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 09/13] genapic: reduce stack pressuge in io_apic.c step
 1 temp cpumask_ts
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>	<20080906235038.148283000@polaris-admin.engr.sgi.com> <8763p6vr3b.fsf@basil.nowhere.org>
In-Reply-To: <8763p6vr3b.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>>   * Step 1 of cleaning up io_apic.c removes local cpumask_t variables
>>     from the stack.
> 
> Sorry that patch seems incredibly messy. Global variables
> and a tricky ordering and while it's at least commented it's still a mess
> and maintenance unfriendly.
> 
> Also I think set_affinity is the only case where a truly arbitary cpu
> mask can be passed in anyways. And it's passed in from elsewhere. 
> 
> The other cases generally just want to handle a subset of CPUs which
> are nearby. How about you define a new cpumask like type that 
> consists of a start/stop CPU and a mask for that range only 
> and is not larger than a few words?
> 
> I think with that the nearby assignments could be handled 
> reasonably cleanly with arguments and local variables.
> 
> And I suspect with some restructuring set_affinity could
> be also made to support such a model.
> 
> -Andi

Thanks for the comments.  I did mull over something like this early on
in researching this "cpumask" problem, but the problem of having different
cpumask operators didn't seem worthwhile.  But perhaps for a very limited
use (with very few ops), it would be worthwhile.

But how big to make these?  Variable sized?  Config option?  Should I
introduce some kind of MAX_CPUS_PER_NODE constant?  (NR_CPUS/MAX_NUMNODES
I don't think is the right answer.)

Thanks,
Mike
