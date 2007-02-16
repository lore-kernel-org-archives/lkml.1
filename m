Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbXBPKWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbXBPKWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXBPKWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:22:55 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44438 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbXBPKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:22:54 -0500
Message-ID: <45D58531.4010808@vmware.com>
Date: Fri, 16 Feb 2007 02:19:29 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       Dan Hecht <dhecht@vmware.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       virtualization@lists.osdl.org, Steven Hand <steven.hand@cl.cam.ac.uk>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disable unsupported config options.
References: <C1FB336B.98D6%keir@xensource.com>
In-Reply-To: <C1FB336B.98D6%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> On 16/2/07 07:25, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
>
>   
>>> Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  In which case
>>> that preempt_disable() I spotted is wrong-and-unneeded.
>>>
>>> Why doesn't Xen work with preemption??
>>>       
>> I've forgotten the details.  Ian?  Keir?  Steven?  Maybe it can be done.
>>     
>
> It breaks guest save/restore for us currently because threads can be
> sleeping with machine addresses in local storage (registers, stack). There
> are a few ways to achieve an acceptable solution:
>
>  1. Put processes in the freezer when we suspend. This should avoid any
> thread being in a critical section with machine addresses in its hand. We
> haven't yet investigated the performance impact of freezing processes,
> particularly on the downtime of live relocation.
>
>  2. Allow CONFIG_PREEMPT to be compiled in, but disable it at runtime. We
> could do this by, for example, reserving a bit in preempt_count() so that
> most preemption checks do not touch any more cache lines. I guess it would
> need a bit of fixing up (e.g., so that in_atomic() would not be always
> asserted). Even better for us would be to allow switching between
> involuntary and voluntary preemption at runtime. It looks as though the hook
> points for these two techniques are not usually compiled in at the same
> time, however.
>
>   

Doesn't stop_machine_run already take care of getting you out of all 
kernel threads?  So you can only be sleeping, not preempted, in which 
case, this might not be an issue?

Zach

