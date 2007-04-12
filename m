Return-Path: <linux-kernel-owner+w=401wt.eu-S2992549AbXDLN1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992549AbXDLN1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992550AbXDLN1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:27:32 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:22713 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992549AbXDLN1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:27:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=e/JiKA+b3NsBLLN9dPELpThplOCO7ZTP7hSN0QNKiyKdKaNVmHL8TBU/CZE8RQdkFiD8ig6uoN/HG/beeoa9y1AntIplnsXoqTsKXcPblwfI7VUZk1a4ymTPrI94FJJS3kCw0j6mPAwXhSbbFbuhvHRcQEj4+KfPsCAdKSLPeac=  ;
X-YMail-OSG: PGiR_HsVM1kI4G7DlDoiCmIlbOByDyfjoBs6OJP.50VZhHLxEF1QaM8nZ6gOR.t6k8MnlYePow--
Message-ID: <461E33BA.2030104@yahoo.com.au>
Date: Thu, 12 Apr 2007 23:27:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Buytaert_Steven@emc.com
CC: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: sched_yield proposals/rationale
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Buytaert_Steven@emc.com wrote:
>>-----Original Message-----
>>From: Andi Kleen
>>[ ... about use of sched_yield ...]
>>On the other hand when they fix their code to not rely on sched_yield
>>but use [...]
> 
> 
> Agreed, but $ find . -name "*.[ch]" | xargs grep -E "yield[ ]*\(" | wc over
> the 2.6.16 kernel yields 105 hits, note including comments...

Most of these (in core code, anyway) seem to use yield when they really don't
care about running for a while.

> An interesting spot is e.g. fs/buffer.c free_more_memory()

This one should be pretty rare (actually I think it is dead code in practice,
due to the way the page allocator works).

Avoiding sched_yield is a really good idea outside realtime scheduling. Since
we have gone this far with the current semantics, I think it would be sad to
back down now.

It would be nice if you could pressure those other components to adapt :)

-- 
SUSE Labs, Novell Inc.
