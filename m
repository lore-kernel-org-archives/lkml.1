Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXDMBms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXDMBms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXDMBms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:42:48 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:29633 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752858AbXDMBms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:42:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Nj0posjL8TamsxCQHRz0osT7RKs7miN9MpDOtKhWJzLUjF5n9WdVp+h5aQ9Pw31+ZSmNTTP+NrqloP/fzKpu8sXQehOa/CXsjD9evdTWcsvz1kUMtp0f76KC2iYzRbvUVvFsAdRbQGQxV4r/iPUMmprrJpaZZWS/B083HzaREdc=  ;
X-YMail-OSG: xL_MbHIVM1n4DWeRGIxi06ONzEVarI8BDroci3HUPYR4s9z_jqn.4BnCPp5d8yGsQ3vmbMQcpw--
Message-ID: <461EE005.6070605@yahoo.com.au>
Date: Fri, 13 Apr 2007 11:42:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com>	<20070412231050.GN2986@holomorphy.com>	<20070412163235.dd030637.akpm@linux-foundation.org>	<461ECB9C.8060000@yahoo.com.au>	<20070412174201.065068b2.akpm@linux-foundation.org>	<461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org>
In-Reply-To: <20070412182213.a18cc4a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 13 Apr 2007 11:14:20 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Andrew Morton wrote:

>>>It *will* be viable.  If the application wants to know if a page is dirty,
>>>it looks up "PG_dirty" in /proc/pg_foo-to-bitnumber and uses PG_dirty's
>>>numerical offset when inspecting fields in /proc/kpagemap.  If correctly
>>>designed, such a monitoring application will be able to report upon page
>>>flags which we haven't even thought up yet.
>>
>>Ooh, you wanted a _runtime_ mapping of flags, yeah then I guess that works.
>>Still seems like a basically hit and miss affair to just use flags. What if
>>you want to know the process mapping a page? With systemtap or something you
>>could walk the rmap structures. What if you want to look at pages along the
>>LRU list rather than per-pfn? What about connecting pages to inodes?
> 
> 
> Well hang on.  This isn't a tool for understanding kernel behaviour.  It's
> a tool for understanding applciation behaviour.
> 
> So one doesn't ask "who is mapping that page" - that's a kernel developer
> thing.
> 
> Instead, one says "what pages are being used by my application", then, for

That includes unmapped pagecache being used by my application, doesn't it?
Maybe that's too hard to do via /proc so we forget about it...


> each of those pages "what is that page's state".  So the first step is to
> collect all the pfns from /proc/$(pidof my-application)/pagemap and then to
> use those pfns to look the individual pages up in /proc/kpagemap.

OK I realise you could do it that way, but systemtap can definitely be
used as a tool for understanding application behaviour in the context of
the kernel, I think? The purpose for it is so that various little bits
of deep kernel internals do not have to be exposed on a case by case basis.

If kprobes is simply crappy and doesn't work properly for this, then I
could accept that. I'm not someone trying to get this info. So why can't
it be used? (not just for kpagemap, but for clear_refs and all that gunk
too).

 > If you really want to know "who is using page 123435" then you'd need to
 > search /proc/*/pagemap.  There are possibly legitimate reasons why an
 > application developer would want to at least pertially perform such an
 > operation ("who am I sharing with"), but I doubt if it's the common case.

Maybe. How about LRU? Reclaim performance is bad, and you want to work out
which pages keep going off the end of it, or which pages keep getting
written out via it, or who's pages are on the active list, forcing mine
out.

-- 
SUSE Labs, Novell Inc.
