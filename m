Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbXGJB67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbXGJB67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbXGJB6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:58:52 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:42334 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757257AbXGJB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:58:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=t9fsTRvaSu6QdgIIDHKBRIut9Gu+fyBkKciLVobf553H71/SvHVjbGwFgk6c6ipuz8W4KngIJSKHKZx0ga5vaGgm9TX+X7SOwVsAy8FsFihbY4cvWq4/6/NDVzBQhJlUAE5racvExj0DzaUj7UEv6BBb5Xlqr15qAAd7bB2AeCc=  ;
X-YMail-OSG: bmFTfM4VM1mFWi1MJqna.R.TjQ7a2MB4aUgur8RpXWsZCWFbswBi14sUnJr85g6fm7F.lcKrTA--
Message-ID: <4692E7D4.6060909@yahoo.com.au>
Date: Tue, 10 Jul 2007 11:58:44 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <4692E3BF.9010305@yahoo.com.au> <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> 
>>>O(n) memory savings? What is that?
>>
>>Allocate n things and your memory waste is proportional to n (well that's
>>O(n) waste, so I guess by savings I mean that SLOB's memory saving compared
>>to SLUB are proportional to n).
> 
> 
> n is the size of the object?

n things -- n number of things (n calls to kmem_cache_alloc()).

Just a fancy way of saying roughly that memory waste will increase as
the size of the system increases. But that aspect of it I think is
not really a problem for non-tiny systems anyway because the waste
tends not to be too bad (and possibly the number of active allocations
does not increase O(n) with the size of RAM either).

-- 
SUSE Labs, Novell Inc.
