Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbZJMCOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbZJMCOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbZJMCOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:14:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:35785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbZJMCOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:14:45 -0400
Message-ID: <4AD3E23B.8020103@kernel.org>
Date: Tue, 13 Oct 2009 11:13:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910121053240.7932@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 02:13:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 12 Oct 2009, Tejun Heo wrote:
> 
>>> -		c = get_cpu_slab(s, smp_processor_id());
>>> +		c = __this_cpu_ptr(s->cpu_slab);
>> Shouldn't this be this_cpu_ptr() without the double underscore?
> 
> Interrupts are disabled so no concurrent fast path can occur.
> 

The only difference between this_cpu_ptr() and __this_cpu_ptr() is the
usage of my_cpu_offset and __my_cpu_offset which in turn are only
different in whether they check preemption status to make sure the cpu
is pinned down when called.

The only places where the underbar prefixed versions should be used
are places where cpu locality is nice but not critical and preemption
debug check wouldn't work properly for whatever reason.  The above is
none of the two and the conversion is buried in a patch which is
supposed to do something else.  Am I missing something?

-- 
tejun
