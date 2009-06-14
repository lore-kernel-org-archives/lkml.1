Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZFNNEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZFNNEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZFNNEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:04:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZFNNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:04:45 -0400
Message-ID: <4A34F564.2010500@redhat.com>
Date: Sun, 14 Jun 2009 16:04:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>	<alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>	<alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>	<4A34E4A5.3040306@redhat.com> <18996.60235.178618.531664@cargo.ozlabs.ibm.com>
In-Reply-To: <18996.60235.178618.531664@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Avi Kivity writes:
>
>   
>> An alternative implementation using 64-bit cmpxchg will recover most of 
>> the costs of hashed spinlocks.  I assume most serious 32-bit 
>> architectures have them?
>>     
>
> Have a 64-bit cmpxchg, you mean?  x86 is the only one I know of, and
> it already has an atomic64_t implementation using cmpxchg8b (or
> whatever it's called).
>   

Yes (and it is cmpxchg8b).  I'm surprised powerpc doesn't have DCAS support.

> My thinking is that the 32-bit non-x86 architectures will be mostly
> UP, so the overhead is just an interrupt enable/restore.  Those that
> are SMP I would expect to be small SMP -- mostly just 2 cpus and maybe
> a few 4-way systems.
>   

The new Nehalems provide 8 logical threads in a single socket.  All 
those threads share a cache, and they have cmpxchg8b anyway, so this 
won't matter.

-- 
error compiling committee.c: too many arguments to function

