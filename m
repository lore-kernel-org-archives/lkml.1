Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbXDECBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbXDECBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXDECBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:01:15 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44765 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932508AbXDECBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:01:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=LIcOzNjFnpp0xsAsJorXzR+CCpxKh16TPAE7d2+0Wu21xvV5I2fujer0p9JO/su7UdejKzoQwS1i9VoMp8EO62qMyOrESdHBhvnqNDaydhxCLHKBahZihpQGxeSM8IYg7ea1+64IXIeU9wuY1rU+NMtq7OCRHnrQ2fArMWgp2ls=  ;
X-YMail-OSG: 79Ev2lUVM1leWKBM3JO0S9n5.FT8CJHR1WkjtbEW23aiVzsXdzShFQScYte6xG7h_CZFxO6MJw--
Message-ID: <4614585F.1050200@yahoo.com.au>
Date: Thu, 05 Apr 2007 12:01:03 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<4612DCC6.7000504@cosmosbay.com>	<46130BC8.9050905@yahoo.com.au>	<1175675146.6483.26.camel@twins>	<461367F6.10705@yahoo.com.au>	<20070404113447.17ccbefa.dada1@cosmosbay.com>	<46137882.6050708@yahoo.com.au> <20070404135458.4f1a7059.dada1@cosmosbay.com>
In-Reply-To: <20070404135458.4f1a7059.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Wed, 04 Apr 2007 20:05:54 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>>>@@ -1638,7 +1652,7 @@ find_extend_vma(struct mm_struct * mm, u
>>> 	unsigned long start;
>>> 
>>> 	addr &= PAGE_MASK;
>>>-	vma = find_vma(mm,addr);
>>>+	vma = find_vma(mm,addr,&current->vmacache);
>>> 	if (!vma)
>>> 		return NULL;
>>> 	if (vma->vm_start <= addr)
>>
>>So now you can have current calling find_extend_vma on someone else's mm
>>but using their cache. So you're going to return current's vma, or current
>>is going to get one of mm's vmas in its cache :P
> 
> 
> This was not a working patch, just to throw the idea, since the answers I got showed I was not understood.
> 
> In this case, find_extend_vma() should of course have one struct vm_area_cache * argument, like find_vma()
> 
> One single cache on one mm is not scalable. oprofile badly hits it on a dual cpu config.

Oh, what sort of workload are you using to show this? The only reason that I
didn't submit my thread cache patches was that I didn't show a big enough
improvement.

-- 
SUSE Labs, Novell Inc.
