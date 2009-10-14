Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbZJNB7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbZJNB7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbZJNB7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:59:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760077AbZJNB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:59:14 -0400
Message-ID: <4AD53022.2050309@kernel.org>
Date: Wed, 14 Oct 2009 10:57:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org> <4AD4950A.6050201@kernel.org> <alpine.DEB.1.10.0910131117060.8088@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910131117060.8088@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 01:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

Christoph Lameter wrote:
>> Yeah, widespread use of underscored versions isn't very desirable.
>> The underscored versions should notify certain specific exceptional
>> conditions instead of being used as general optimization (which
>> doesn't make much sense after all as the optimization is only
>> meaningful with debug option turned on).  Are you interested in doing
>> a sweeping patch to drop underscores from __this_cpu_*() conversions?
> 
> Nope. __this_cpu_add/dec cannot be converted.

Right.

> __this_cpu_ptr could be converted to this_cpu_ptr but I think the __ are
> useful there too to show that we are in a preempt section.

That doesn't make much sense.  __ for this_cpu_ptr() means "bypass
sanity check, we're knowingly violating the required conditions" not
"we know sanity checks will pass here".

> The calls to raw_smp_processor_id and smp_processor_id() are only useful
> in the fallback case. There is no need for those if the arch has a way to
> provide the current percpu offset. So we in effect have two meanings of __
> right now.
> 
> 1. We do not care about the preempt state (thus we call
> raw_smp_processor_id so that the preempt state does not trigger)
> 
> 2. We do not need to disable preempt before the operation.
> 
> __this_cpu_ptr only implies 1. __this_cpu_add uses 1 and 2.

Yeah, we need to clean it up.  The naming is too confusing.

Thanks.

-- 
tejun
