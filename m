Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXDMCu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXDMCu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXDMCu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:50:28 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:34611 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752914AbXDMCu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:50:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=U7Z1tXvnu7pILMXBjNrncFEB0iTIQIo6oNPBf6dPfFbPuQY0vHi2xwhMjlytySWSXVwgYea+3jR7CcUa0VpJiBm8E7ZSWoEec/+XvLa+sY2Jk8aIJk21A/GiDn+UusAHzih6SQ4REknBiKjaRX11zq6f27bPPJ2vSZBntHlSPjI=  ;
X-YMail-OSG: yp2KWSQVM1lfBQcHSRtbBh2o1rSgWTaaI.ElS3w1vUgQWe2QLZrPtOWSPk3SHPBIDUF3IpjeOA--
Message-ID: <461EEFEC.2010205@yahoo.com.au>
Date: Fri, 13 Apr 2007 12:50:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com>	<20070412163235.dd030637.akpm@linux-foundation.org>	<461ECB9C.8060000@yahoo.com.au>	<20070412174201.065068b2.akpm@linux-foundation.org>	<461ED96C.5030606@yahoo.com.au>	<20070412182213.a18cc4a7.akpm@linux-foundation.org>	<461EE005.6070605@yahoo.com.au>	<20070412185723.5a5f0443.akpm@linux-foundation.org>	<461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org>
In-Reply-To: <20070412193255.62a0b8ed.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 13 Apr 2007 12:18:56 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>>I guess one could generate an answer to the static question with systemtap,
>>>by accumulating running counts across the application lifetime and then
>>>snapshotting them.  Sounds hard though.
>>
>>Can't you just traverse arbitrary kernel data structures at a given point
>>in time, exactly like the /proc/ call is doing?
> 
> 
> Do a full pagetable walk, with all the associated locking from within
> a systemtap script?  I'd be surprised.  Maybe if it's mostly hand-coded
> in C, perhaps.

It looks like you can traverse arbitrary data structures, yes.

It definitely seems like you can use some kernel functions, but the
ones I saw may just be systemtap facilities. But what is so surprising
about being able to call a kernel function when running in kernel
context? Perhaps there is some fundamental limitation of kprobes that
I don't understand.

>  Then you just end up with the same thing, don't you?

Well _you_ do, because that happens to be exactly what you want. Bill
ends up with something that displays page_mapcount instead. And I
end up with something that traverses LRU lists rather than pfns. And
none of it goes in /proc/ or linux-2.6/.

So it isn't really the same thing at all.

-- 
SUSE Labs, Novell Inc.
