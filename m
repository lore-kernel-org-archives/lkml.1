Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZJRDKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZJRDKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 23:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZJRDKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 23:10:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:47529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbZJRDKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 23:10:53 -0400
Message-ID: <4ADA875B.1070102@kernel.org>
Date: Sun, 18 Oct 2009 12:11:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org> <alpine.DEB.1.10.0910121053240.7932@gentwo.org> <4AD3E23B.8020103@kernel.org> <alpine.DEB.1.10.0910131037420.21608@gentwo.org> <4AD4950A.6050201@kernel.org> <alpine.DEB.1.10.0910131117060.8088@gentwo.org> <4AD53022.2050309@kernel.org> <alpine.DEB.1.10.0910141008440.28461@gentwo.org> <4AD6D3A0.6040706@kernel.org> <alpine.DEB.1.10.0910161232420.6120@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910161232420.6120@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Oct 2009 03:10:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

Christoph Lameter wrote:
>> The biggest grief I have is that the meaning of __ is different among
>> different accessors.  If that can be cleared up, we would be in much
>> better shape without adding any extra macros.  Can we just remove all
>> __'s and use meaningful pre or suffixes like raw or irq or whatever?
> 
> It currently means that we do not deal with preempt and do not check for
> preemption. That is consistent.

If you define it inclusively, it can be consistent.

> Sure we could change the API to have even more macros than the large
> amount it already has so that we can check for proper preempt disablement.
> 
> I guess that would mean adding
> 
> raw_nopreempt_this_cpu_xx  and nopreempt_this_cpu_xx variants? The thing
> gets huge. I think we could just leave it. __ suggests that serialization
> and checking is not performed like in the full versions and that is true.

I don't think we'll need to add new variants.  Just renaming existing
ones so that they have more specific pre/suffix should make things
clearer.  I'll give a shot at that once the sparse annotation patchset
is merged.

Thanks.

-- 
tejun
