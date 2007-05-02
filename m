Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXEBCF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXEBCF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXEBCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:05:26 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:38925 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751627AbXEBCFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:05:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xPCmwNaQLCdRch+SLhmaPsYCp48XTbKmdw+a028T6oyHY/XQbZeBr+13Blz4XXHfQlcmH4pTj0pjK/q7dHBo9OfCMjry5OU3Hi5QGz+TEAFT0MPo2fOULTpZFEgvXiLNZ0Mk5+E7gMemr4S92SvmvTYQkWnjtWM3MiOv9B/DjNY=  ;
X-YMail-OSG: pTZuvu4VM1lGzbQjvn_MDzfE_qdui85Svkih9b.DJw2qkCUrCEyvI9DtgQ3LJaLySDodaAScxA--
Message-ID: <4637F1DB.2010507@yahoo.com.au>
Date: Wed, 02 May 2007 12:05:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: rohitseth@google.com
CC: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281817.l3SIHu0P001764@smtp.corp.google.com>	 <46372A12.9080802@yahoo.com.au> <1178066180.19466.68.camel@galaxy.corp.google.com>
In-Reply-To: <1178066180.19466.68.camel@galaxy.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
> On Tue, 2007-05-01 at 21:52 +1000, Nick Piggin wrote:
> 
>>Rohit Seth wrote:
>>
>>
>>>>and 
>>>>it's only interested when it's executable i.e. "lazy_mmu_prot_update"
>>>>is a name concealing some overdesign.
>>>
>>>
>>>You are right that ia64 is only interested in whne the execute permissions
>>>kick in (and FWIW ia64 used to use update_mmu_cache API to do what it is now
>>>doing lazy_mmu_prot_update).  Though the idea was to design an API that any
>>>arch can use to know when ever there is change in protections on a mapping.
>>
>>What I think what we should do is audit flush_icache_page coverage, and
>>convert ia64 to use that (because it needs this to happen _before_ the
>>pte is set).
>>
> 
> 
> That doesn't address the underlying requirement that arch specific code
> should be told of change in protections. 

But you would add the flush_icache_page_chprot to address that.


> For ia64, you are right that
> it equates to flushing icache in some cases, but this API is more
> generic.

And it is also broken, because it needs to be done before the set_pte
for ia64. It needs to be done where flush_icache_page is done. And on
ia64 it flushes the icache. So I don't understand why ia64 would not
use flush_icache_page but add something completely new "because it is
more generic".


>>All we should need to do is add a pte argument to flush_icache,
> 
> 
> I'm sure this is doable.  Though it is more of design issue of whether
> that is the right way to do it.  I understand this extra API is
> difficult at this time because of one single consumer.

There is just no point in adding something else if you already have
a hook that seems to do what ia64 wants (or could, with a small amount
of work).

-- 
SUSE Labs, Novell Inc.
