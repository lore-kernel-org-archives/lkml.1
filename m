Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbZJMP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbZJMP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbZJMP2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:28:43 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43085 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753247AbZJMP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:28:42 -0400
Date: Tue, 13 Oct 2009 11:20:57 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
In-Reply-To: <4AD4950A.6050201@kernel.org>
Message-ID: <alpine.DEB.1.10.0910131117060.8088@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
 <4AD4950A.6050201@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Tejun Heo wrote:

> Yeah, widespread use of underscored versions isn't very desirable.
> The underscored versions should notify certain specific exceptional
> conditions instead of being used as general optimization (which
> doesn't make much sense after all as the optimization is only
> meaningful with debug option turned on).  Are you interested in doing
> a sweeping patch to drop underscores from __this_cpu_*() conversions?

Nope. __this_cpu_add/dec cannot be converted.

__this_cpu_ptr could be converted to this_cpu_ptr but I think the __ are
useful there too to show that we are in a preempt section.

The calls to raw_smp_processor_id and smp_processor_id() are only useful
in the fallback case. There is no need for those if the arch has a way to
provide the current percpu offset. So we in effect have two meanings of __
right now.

1. We do not care about the preempt state (thus we call
raw_smp_processor_id so that the preempt state does not trigger)

2. We do not need to disable preempt before the operation.

__this_cpu_ptr only implies 1. __this_cpu_add uses 1 and 2.

