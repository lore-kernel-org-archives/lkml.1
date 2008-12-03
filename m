Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYLCROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYLCROb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYLCROX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:14:23 -0500
Received: from mga12.intel.com ([143.182.124.36]:22364 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343AbYLCROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:14:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,708,1220252400"; 
   d="scan'208";a="86034184"
Message-ID: <4936BE6B.9080000@linux.intel.com>
Date: Wed, 03 Dec 2008 09:14:19 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       tytso@mit.edu
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref
 of 0x20)
References: <4935C03A.7030603@gmail.com>	 <20081202153336.7b765ec7.akpm@linux-foundation.org>	 <1228261328.3196.174.camel@calx>  <4935C9CC.8070308@linux.intel.com> <1228324020.3255.24.camel@calx>
In-Reply-To: <1228324020.3255.24.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, 2008-12-02 at 15:50 -0800, Arjan van de Ven wrote: 
>> Matt Mackall wrote:
>>> If we oops or warn while picking a timesource, we'll have lots of fun?
>>>
>> we really only need to mix in the tsc; ktime_get() is just an arch friendly way to get that
>> I supposed (wrongly).
>>
>> but yes we need to do a few things
>> 1) seed on demand with a platform time source
> 
> Currently we use jiffies + get_cycles(). That's going to have somewhere
> between, oh, 3 bits of entropy (very stable boot with only jiffies) and
> 25 bits of entropy (TSC with lots of waiting for hardware) at boot. 
> Ideally, we'd have access to a wall clock of some sort as well. But
> that's also a fairly limited source - wall clocks are both low
> resolution and predictable/collision-prone.

tsc taken quite some time appart in the boot, we will get multiple times a bunch of entropy.
This comes from variations in time various hardware things take (due to spread spectrum clocks)
and because of cpu speculation not being deterministic to this level of multi-milliseconds.
