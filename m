Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYFKGzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYFKGzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYFKGzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:55:35 -0400
Received: from gw.goop.org ([64.81.55.164]:36898 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYFKGzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:55:35 -0400
Message-ID: <484F76BB.20507@goop.org>
Date: Wed, 11 Jun 2008 07:54:51 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Isaku Yamahata <yamahata@valinux.co.jp>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
References: <20080610073532.GG24381%yamahata@valinux.co.jp> <200806101741.39871.nickpiggin@yahoo.com.au> <484E33F1.5000503@goop.org> <200806101815.53729.nickpiggin@yahoo.com.au>
In-Reply-To: <200806101815.53729.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 10 June 2008 17:57, Jeremy Fitzhardinge wrote:
>   
>> Nick Piggin wrote:
>>     
>>> On Tuesday 10 June 2008 17:35, Isaku Yamahata wrote:
>>>       
>>>> This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
>>>> Use wmb instead of rmb to enforce ordering between
>>>> evtchn_upcall_pending and evtchn_pending_sel stores
>>>> in xen_evtchn_do_upcall().
>>>>         
>>> There are a whole load of places in the kernel that should be using
>>> smp_ variants of memory barriers. This seemed to me like one of them,
>>> but I could be wrong.
>>>       
>> No, it needs to be an unconditional barrier.  This is synchronizing with
>> the hypervisor - even if the kernel is compiled UP, the SMP hypervisor
>> may be testing/setting the events pending bits from another (physical) cpu.
>>     
>
> OK. What you *really* want is smp_*mb_even_if_compiled_for_UP() ;)
> That is, a small set of primitives that are compiled with CONFIG_SMP
> (and given some xxx_ prefix to distinguish).
>   

We already have a set of sync_* for atomic ops which are always locked.

> IO barriers are probably the best thing you can use for the moment.
>   

It is conceptually similar, I suppose.

       J
