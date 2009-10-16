Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZJPQwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZJPQwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZJPQwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:52:04 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53982 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbZJPQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:52:03 -0400
Date: Fri, 16 Oct 2009 12:44:06 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
In-Reply-To: <4AD6D3A0.6040706@kernel.org>
Message-ID: <alpine.DEB.1.10.0910161232420.6120@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org>
 <4AD4950A.6050201@kernel.org> <alpine.DEB.1.10.0910131117060.8088@gentwo.org> <4AD53022.2050309@kernel.org> <alpine.DEB.1.10.0910141008440.28461@gentwo.org> <4AD6D3A0.6040706@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Tejun Heo wrote:

> > Are you defining what __ means for this_cpu_ptr?
>
> I was basically stating the different between raw_smp_processor_id()
> and smp_processor_id() which I thought applied the same to
> __this_cpu_ptr() and this_cpu_ptr().

Ii does apply. __this_cpu_ptr does not use smp_processor_id() but
raw_smp_processor_id(). this_cpu_ptr does not need to disable preempt so
we dont do anything on that level.

> > The vm event counters require both no check and no preempt since they can
> > be implemented in a racy way.
>
> The biggest grief I have is that the meaning of __ is different among
> different accessors.  If that can be cleared up, we would be in much
> better shape without adding any extra macros.  Can we just remove all
> __'s and use meaningful pre or suffixes like raw or irq or whatever?

It currently means that we do not deal with preempt and do not check for
preemption. That is consistent.

Sure we could change the API to have even more macros than the large
amount it already has so that we can check for proper preempt disablement.

I guess that would mean adding

raw_nopreempt_this_cpu_xx  and nopreempt_this_cpu_xx variants? The thing
gets huge. I think we could just leave it. __ suggests that serialization
and checking is not performed like in the full versions and that is true.
