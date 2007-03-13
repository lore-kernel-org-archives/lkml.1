Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXCMMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXCMMBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXCMMBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:01:19 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:30641 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965693AbXCMMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:01:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ex02hW9qkXx0xqSZqbj/T/J0OwkGvAy+ZRmU30JT3SlJFBzycNOyinSpWrPyDFubJef2ODblHyvre4ybDSmE5ckwvkr+FRyG9Yfb0XlBBeaDA0TxGWF/L2kTFId7gpH8slWNh6RlsC/tcQ5s7kvNB5R4OqmQqEIFAQtu1sNFr38=  ;
X-YMail-OSG: byC.MbwVM1mx3ZgRk5S1ZAKeFvb.QmQyYpCKw3ATGEgl8Bbd7g6W2hXAQitHGFZJR46EImogf1guzobQ8L7SESkR.bdegy2g3DXQ9t68eVpxRysBY5tLRQg7VA2o6ep6YVZbO2qkBjLD_KNQtMm.17ffuQ--
Message-ID: <45F69287.8040509@yahoo.com.au>
Date: Tue, 13 Mar 2007 23:01:11 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>	<20070313005334.853559ca.akpm@linux-foundation.org>	<45F65ADA.9010501@yahoo.com.au>	<20070313035250.f908a50e.akpm@linux-foundation.org>	<45F685C6.8070806@yahoo.com.au>	<20070313041551.565891b5.akpm@linux-foundation.org>	<45F68B4B.9020200@yahoo.com.au> <20070313044756.b45649ac.akpm@linux-foundation.org>
In-Reply-To: <20070313044756.b45649ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 13 Mar 2007 22:30:19 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>We don't actually have to zap_pte_range the entire page table in
>>order to free it (IIRC we used to have to, before the 4lpt patches).
> 
> 
> I'm trying to remember why we ever would have needed to zero out the pagetable
> pages if we're taking down the whole mm?  Maybe it's because "oh, the
> arch wants to put this page into a quicklist to recycle it", which is
> all rather circular.
> 
> It would be interesting to look at a) leave the page full of random garbage
> if we're releasing the whole mm and b) return it straight to the page allocator.

Well we have the 'fullmm' case, which avoids all the locked pte operations
(for those architectures where hardware pt walking requires atomicity).

However we still have to visit those to-be-unmapped parts of the page table,
to find the pages and free them. So we still at least need to bring it into
cache for the read... at which point, the store probably isn't a big burden.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
