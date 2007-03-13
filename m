Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXCML4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXCML4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXCML4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:56:41 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:21964 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933190AbXCML4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:56:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=qQ53R7ZiPaYaPEo/XUCPbSgnXszwNk1FIrxJyCqeZXKpKdLCwHLI2XnEN0wy3/YuMUcm2ZQXe1P9s3TqD+vbqZQRJkH7wSP+tEaxEANA3MzO8nKnzjnd15yw7FirE9WOhDBReCzOQrTXLwDBe5v9tlmk5a4pWsfbw0PB/JN37Cg=  ;
X-YMail-OSG: fhmN2h8VM1lGVlu.6NGcaNh5pm4OJlcsHCia3_yfdHLxkWTfcx1pTx1isBaQ3eKU2mFWCyIceld_b3Pekuv4P7TOrV4_wHUARZHy9NOjUhcD9J.aBrwZUzAwXchLF8WlmlkAbxq5nFMkd4s-
Message-ID: <45F69173.3050202@yahoo.com.au>
Date: Tue, 13 Mar 2007 22:56:35 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrea Arcangeli <andrea@suse.de>, Anton Blanchard <anton@samba.org>,
       Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au> <200703131240.47785.dada1@cosmosbay.com>
In-Reply-To: <200703131240.47785.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Tuesday 13 March 2007 12:12, Nick Piggin wrote:
> 
>>I guess googlemalloc (tcmalloc?) isn't suitable for a general purpose
>>glibc allocator. But I wonder if there are other improvements that glibc
>>can do here?
> 
> 
> I cooked a patch some time ago to speedup threaded apps and got no feedback.

Well that doesn't help in this case. I tested and the mmap_sem contention
is not an issue.

> http://lkml.org/lkml/2006/8/9/26
> 
> Maybe we have to wait for 32 core cpu before thinking of cache line 
> bouncings...

The idea is a good one, and I was half way through implementing similar
myself at one point (some java apps hit this badly).

It is just horribly sad that futexes are supposed to implement a
_scalable_ thread synchronisation mechanism, whilst fundamentally
relying on an mm-wide lock to operate.

I don't like your interface, but then again, the futex interface isn't
exactly pretty anyway.

You should resubmit the patch, and get the glibc guys to use it.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
