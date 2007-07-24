Return-Path: <linux-kernel-owner+w=401wt.eu-S935341AbXGXLdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341AbXGXLdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXGXLdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:33:07 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:40933 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752171AbXGXLdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:33:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ttCDAPUJcqAGuoWHevblnxN8aloMir7QVBUzV29fX1XfPilo6UvZxNrPRC8VaeJtv+0FQU4Wvvjpu5bu6znDm5BmJxy7WENPoD6AXO5v/dJCgUgn/7aMhwffRecojvd//W5kW1kC+9E1OXvtbrwlTo0y+sZtmu2V3RZAuvOqpp4=  ;
X-YMail-OSG: 6sF8uYgVM1mMu1G2vBSd8wYpYGXf8j8bUIcPITTMRnOZsaHYAclbWei_4woddwp9QgsjfPwzlA--
Message-ID: <46A5E366.8030605@yahoo.com.au>
Date: Tue, 24 Jul 2007 21:32:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <423904.37199.qm@web53810.mail.re2.yahoo.com> <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 

>>For the purpose of this discussion (Linux memory
>>barrier semantics, on WB memory), it is true of CPU
>>and compiler barriers.
> 
> 
> On later Intel processors, if the memory address range being referenced
> (and say written to) by the (locked) instruction is in the cache of a
> CPU, then it will not assert the LOCK signal on the system bus --
> thus not assume exclusive use of shared memory. So other CPUs are free
> to modify (other) memory at that point. Cache coherency will still
> ensure _that_ (locked) memory area is still updated atomically, though.

The system bus does not need to be serialised because the CPU already
holds the cacheline in exclusive state. That *is* the cache coherency
protocol.

The memory ordering is enforced by the CPU effectively preventing
speculative loads to pass the locked instruction and ensuring all
stores reach the cache before it is executed. (I say effectively
because the CPU might do clever tricks without you knowing).


>>Are you saying that it is OK for the store to var to
>>be reordered below the clear_bit? If not, what are you
>>saying?
> 
> 
> I might be making a radical turn-around here, but all of a
> sudden I think it's actually a good idea to put a complete
> memory clobber in set_bit/clear_bit and friends themselves,
> and leave the "__" variants as they are.

Why?

-- 
SUSE Labs, Novell Inc.
