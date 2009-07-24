Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZGXK6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZGXK6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZGXK6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:58:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZGXK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:58:34 -0400
Date: Fri, 24 Jul 2009 12:58:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever
	possible when changing mapping
Message-ID: <20090724105831.GB2045@basil.fritz.box>
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> <87ocra1jn6.fsf@basil.nowhere.org> <4A698B3E.4020208@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A698B3E.4020208@vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 12:21:50PM +0200, Thomas Hellstrom wrote:
> Andi Kleen wrote:
>> Thomas Hellstrom <thellstrom@vmware.com> writes:
>>
>>   
>>> The current code uses wbinvd() when the area to flush is > 4MB. Although this
>>> may be faster than using clflush() the effect of wbinvd() on irq latencies
>>> may be catastrophical on systems with large caches. Therefore use clflush()
>>>     
>>
>> may be? You seem to miss some hard data here.
>>
>>   
> Admittedly.

So was it motivated by a real problem?

> However, the concept of flushing and invalidating the caches completely on 
> systems with many
> processors and huge caches when we intend to only flush only small piece of 
> the cache also sounds like a big overkill.

The other CPUs will not block (just flush their caches in the background or
in parallel), so the latency shouldn't scale with the number of sockets.
Also number of cores also shouldn't impact it because these tend
to have shared cache hierarchies.

That's just a theory, but not necessarily a worse one than yours :-)

>
> Furthermore, since the wbinvd() has been introduced as an optimization of 
> the general clflush() case, did somebody ever check the effects on systems 
> with many processors and huge caches?

Typically systems with large caches flush faster too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
