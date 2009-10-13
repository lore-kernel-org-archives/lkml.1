Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZJMO5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZJMO5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbZJMO52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:57:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:48881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbZJMO51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:57:27 -0400
Message-ID: <4AD4950A.6050201@kernel.org>
Date: Tue, 13 Oct 2009 23:56:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 14:56:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 13 Oct 2009, Tejun Heo wrote:
> 
>> The only difference between this_cpu_ptr() and __this_cpu_ptr() is the
>> usage of my_cpu_offset and __my_cpu_offset which in turn are only
>> different in whether they check preemption status to make sure the cpu
>> is pinned down when called.
> 
> Correct.
> 
>> The only places where the underbar prefixed versions should be used
>> are places where cpu locality is nice but not critical and preemption
>> debug check wouldn't work properly for whatever reason.  The above is
>> none of the two and the conversion is buried in a patch which is
>> supposed to do something else.  Am I missing something?
> 
> I used __this_cpu_* whenever the context is already providing enough
> safety that preempt disable or irq disable would not matter. The use of
> __this_cpu_ptr was entirely for consistent usage here. this_cpu_ptr would
> be safer because it has additional checks that preemption really is
> disabled. So if someone gets confused about logic flow later it can be
> dtected.

Yeah, widespread use of underscored versions isn't very desirable.
The underscored versions should notify certain specific exceptional
conditions instead of being used as general optimization (which
doesn't make much sense after all as the optimization is only
meaningful with debug option turned on).  Are you interested in doing
a sweeping patch to drop underscores from __this_cpu_*() conversions?

Thanks.

-- 
tejun
