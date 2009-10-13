Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZJMOtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZJMOtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbZJMOtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:49:07 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43610 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760031AbZJMOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:49:06 -0400
Date: Tue, 13 Oct 2009 10:41:18 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
In-Reply-To: <4AD3E23B.8020103@kernel.org>
Message-ID: <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Tejun Heo wrote:

> The only difference between this_cpu_ptr() and __this_cpu_ptr() is the
> usage of my_cpu_offset and __my_cpu_offset which in turn are only
> different in whether they check preemption status to make sure the cpu
> is pinned down when called.

Correct.

> The only places where the underbar prefixed versions should be used
> are places where cpu locality is nice but not critical and preemption
> debug check wouldn't work properly for whatever reason.  The above is
> none of the two and the conversion is buried in a patch which is
> supposed to do something else.  Am I missing something?

I used __this_cpu_* whenever the context is already providing enough
safety that preempt disable or irq disable would not matter. The use of
__this_cpu_ptr was entirely for consistent usage here. this_cpu_ptr would
be safer because it has additional checks that preemption really is
disabled. So if someone gets confused about logic flow later it can be
dtected.
