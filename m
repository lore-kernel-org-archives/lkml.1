Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXCMMSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXCMMSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXCMMSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:18:13 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:34538 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030284AbXCMMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:18:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Pjb2772skoaLOX+R2MqgUffdI1VDYmo1zvpDgPo70ngc1/LRjaPCp1/5ooq7r8wYMcFvQCpx7gRYQ2wbEBRoTebr4Qg+Q2vW1ssC5SaDUdxQrQp7CEgiF1LIu90XmnUmRp3X9u867iF24uIwtuFFRgBnay/Tc1zUXWHuYTBYaKA=  ;
X-YMail-OSG: vTq_WigVM1m32tzJPGSx772uvKWX36p.mesCM6u4A8BBfeJmMBt0wE5Qv_XJaC_DTPXFdAb6C8KzI2mPUaI.CfOPRoXkO_5M_QkYHl8T9tTfskBd1Mg0xJKxP7rUuXDUzIVIN1DeiJkgy9szhiRRPEJxsg--
Message-ID: <45F6967F.4020002@yahoo.com.au>
Date: Tue, 13 Mar 2007 23:18:07 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>	<20070313005334.853559ca.akpm@linux-foundation.org>	<45F65ADA.9010501@yahoo.com.au>	<20070313035250.f908a50e.akpm@linux-foundation.org>	<45F685C6.8070806@yahoo.com.au>	<20070313041551.565891b5.akpm@linux-foundation.org>	<45F68B4B.9020200@yahoo.com.au>	<20070313044756.b45649ac.akpm@linux-foundation.org>	<45F69287.8040509@yahoo.com.au> <20070313051109.3215104b.akpm@linux-foundation.org>
In-Reply-To: <20070313051109.3215104b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 13 Mar 2007 23:01:11 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>Andrew Morton wrote:

>>>It would be interesting to look at a) leave the page full of random garbage
>>>if we're releasing the whole mm and b) return it straight to the page allocator.
>>
>>Well we have the 'fullmm' case, which avoids all the locked pte operations
>>(for those architectures where hardware pt walking requires atomicity).
> 
> 
> I suspect there are some tlb operations which could be skipped in that case
> too.

Depends on the tlb flush implementation. The generic one doesn't look like
it is all that smart about optimising the fullmm case. It does skip some
tlb flushing though.

>>However we still have to visit those to-be-unmapped parts of the page table
>>to find the pages and free them. So we still at least need to bring it into
>>cache for the read... at which point, the store probably isn't a big burden.
> 
> 
> It means all that data has to be written back.  Yes, I expect it'll prove
> to be less costly than the initial load.

Still, it is something we could try.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
