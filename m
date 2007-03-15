Return-Path: <linux-kernel-owner+w=401wt.eu-S1751711AbXCOV3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbXCOV3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXCOV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:29:11 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:44340 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751709AbXCOV3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:29:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=DBql0+X8byVVeGZ18Io0A4hmqS+OxOuYEIWD8hHd3iFmxav4ZkF0tMNa6e01UxbJ1LXg+cq7Ml5jnSBigyBZb5Ru+NIHzal8FJ1K0sdBsiA4TU8OWCmubkZYoKnctYQutXkCN1jZghys4l7zd9Eh5obtMqj/Dg/8zD4vmBClKIY=  ;
X-YMail-OSG: Xgxv3iQVM1nTXe7XNbH5H2CXlv_2rI_0zNNHux6segEaG_Wv56gMF7t1ieRZApUcp6tuH5CTtzKG2Wp7QovTQROY21vwkqIMustjCAsvCvW.FCEWRdQZhKWLWsIt9mYZl8Wugq0XLL3IJVPYlBjAQom01A--
Message-ID: <45F9BAA1.9040803@yahoo.com.au>
Date: Fri, 16 Mar 2007 08:29:05 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] FUTEX : introduce private hashtables
References: <20060808070708.GA3931@localhost.localdomain>	 <200608090826.28249.dada1@cosmosbay.com>	 <200608090843.52893.dada1@cosmosbay.com>	 <200703152016.25703.dada1@cosmosbay.com> <45F9ABD1.70204@yahoo.com.au> <a36005b50703151409x311c2631n1bc10de67b6c6ede@mail.gmail.com>
In-Reply-To: <a36005b50703151409x311c2631n1bc10de67b6c6ede@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 3/15/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> There should be little contention on the memory in the global hash 
>> anyway,
>> because we can roughly reduce contention as a factor of 
>> hash-size/cacheline-size.
>>
>> What we will have are cache misses on the global table... but we're 
>> going to
>> get cache misses on those private tables as well.
> 
> 
> I'm thinking about NUMA cases.  If you have private tables for a
> process which is pinned to some cluster in a NUMA machine the table is
> local to the node.  If you have a global table you cannot optimize
> your application for such a situation because at least some of the
> pages of the global table are remote.
> 

That's true, but it also might be able to be improved in other ways.

At least once we get the basic support in the kernel, and glibc picks
it up, then we have a better base to evaluate these more exotic changes
against.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
