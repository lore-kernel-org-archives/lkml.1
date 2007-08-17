Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbXHQCb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbXHQCb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXHQCbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:31:48 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40552 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751781AbXHQCbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:31:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZfReF3wUO757LZ7SKBtntE4PFDTnWtqsfKy4OYLzHb5toD/e1srWv+EdjgzYMHZy4jQN+TU226IUF3p702O+KnNsBSJdtyKq10sB+/7Za5a12rdd2TKlZkcvErMbqNZdEtidS8UmSV59QM90xpltIGtDMVbQUCYUInCRutoignk=  ;
X-YMail-OSG: hgeUaBEVM1mRvRRh4GaJa2HZ2y4dnKEmcUJmly.6F7rj26aLzzjpPJZ55YK5tzoRWi0lA6lEBg--
Message-ID: <46C50886.90008@yahoo.com.au>
Date: Fri, 17 Aug 2007 12:31:34 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Herbert Xu <herbert.xu@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Paul Mackerras <paulus@samba.org>, Satyam Sharma <satyam@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <18115.45316.702491.681906@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708160800130.24380@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <46C40587.7050708@s5r6.in-berlin.de> <20070816081049.GA1431@gondor.apana.org.au> <46C4AA26.4060707@redhat.com> <20070817000209.GC11594@gondor.apana.org.au> <46C50228.4000004@redhat.com>
In-Reply-To: <46C50228.4000004@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Herbert Xu wrote:
> 
>> On Thu, Aug 16, 2007 at 03:48:54PM -0400, Chris Snook wrote:
>>
>>>> Can you find an actual atomic_read code snippet there that is
>>>> broken without the volatile modifier?
>>>
>>> A whole bunch of atomic_read uses will be broken without the volatile 
>>> modifier once we start removing barriers that aren't needed if 
>>> volatile behavior is guaranteed.
>>
>>
>> Could you please cite the file/function names so we can
>> see whether removing the barrier makes sense?
>>
>> Thanks,
> 
> 
> At a glance, several architectures' implementations of 
> smp_call_function() have one or more legitimate atomic_read() busy-waits 
> that shouldn't be using CPU-relax.  Some of them do work in the loop.

sh looks like the only one there that would be broken (and that's only
because they don't have a cpu_relax there, but it should be added anyway).
Sure, if we removed volatile from other architectures, it would be wise
to audit arch code because arch maintainers do sometimes make assumptions
about their implementation details... however we can assume most generic
code is safe without volatile.

-- 
SUSE Labs, Novell Inc.
