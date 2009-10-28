Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZJ1KES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZJ1KES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZJ1KES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZJ1KER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:04:17 -0400
Message-ID: <4AE81710.1080103@redhat.com>
Date: Wed, 28 Oct 2009 12:04:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com> <4AE5A336.4010801@gmail.com> <4AE5C26A.9000400@gmail.com>
In-Reply-To: <4AE5C26A.9000400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2009 05:38 PM, Gregory Haskins wrote:
>>> Instead of a lockless attribute, how about a ->set_atomic() method.  For
>>> msi this can be the same as ->set(), for non-msi it can be a function
>>> that schedules the work (which will eventually call ->set()).
>>>
>>> The benefit is that we make a decision only once, when preparing the
>>> routing entry, and install that decision in the routing entry instead of
>>> making it again and again later.
>>>        
>> Yeah, I like this idea.  I think we can also get rid of the custom
>> workqueue if we do this as well, TBD.
>>      
> So I looked into this.  It isn't straight forward because you need to
> retain some kind of state across the deferment on a per-request basis
> (not per-GSI).  Today, this state is neatly tracked into the irqfd
> object itself (e.g. it knows to toggle the GSI).
>    

Yes, and it also contains the work_struct.

What if we make the work_struct (and any additional state) part of the 
set_atomic() argument list?  Does it simplify things?

> So while generalizing this perhaps makes sense at some point, especially
> if irqfd-like interfaces get added, it probably doesn't make a ton of
> sense to expend energy on it ATM.  It is basically a generalization of
> the irqfd deferrment code.  Lets just wait until we have a user beyond
> irqfd for now.  Sound acceptable?
>    

I'll look at v3, but would really like to disentangle this.

> In the meantime, I found a bug in the irq_routing code, so I will submit
> a v3 with this fix, as well as a few other things I improved in the v2
> series.
>
>    


-- 
error compiling committee.c: too many arguments to function

