Return-Path: <linux-kernel-owner+w=401wt.eu-S1161461AbXDLB55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461AbXDLB55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161464AbXDLB55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:57:57 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:25758 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161461AbXDLB54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:57:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GUtzVG0I4aAn+7zIih71itnygVy6M9pVNkVIPRyDLbsLTLBXrWsBDayyVqRuMdzEdAAQ+ZD07wCWOk2ZnOSWZSu7xHee3sojW7sbH5//iSEJM/TPRYxL6+MWD4O5TyoMmBPSXPtGwSLrtRTmUw97UtBsi5DmyiVdXwavGveAHCI=  ;
X-YMail-OSG: FvL1Lr0VM1lBH8ZeMYfo6H63ufZzrBNdCzWPGNh.lFoWuevL.KiOVx6C6iOL6bX0hD821ircuw--
Message-ID: <461D91EE.6020404@yahoo.com.au>
Date: Thu, 12 Apr 2007 11:57:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	<20070405194942.1414c030.dada1@cosmosbay.com>	<20070407104339.6674336b.dada1@cosmosbay.com>	<461764A6.3080703@yahoo.com.au>	<20070407120051.9ed0e69a.dada1@cosmosbay.com>	<461C8CD1.3080707@yahoo.com.au>	<20070411101458.114125ee.dada1@cosmosbay.com>	<461CA90E.3080306@yahoo.com.au> <20070411113525.baf8deb0.dada1@cosmosbay.com>
In-Reply-To: <20070411113525.baf8deb0.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Wed, 11 Apr 2007 19:23:26 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:

>>>As this external thing certainly is not doing the check itself, to be on the safe side we should enforce it in get_futex_key(). I agree with you : If we want to maximize performance, we could say : The check *must* be done by the caller.
>>
>>Well we _control_ the API, so let's make it as clean and performant as possible
>>from the start.
> 
> 
> Take a look at do_futex().
> Adding checks in callers just increase code size. I tried this got only bad results.
> This would speedup only the slow path (ie when some user code want to give us non aligned addrs)
> A single factorized check is cleaner and not slower, since we reduce icache pressure.

1 extra check versus all that additional argument passing? I don't think it
is conclusive.

-- 
SUSE Labs, Novell Inc.
