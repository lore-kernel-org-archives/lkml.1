Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXDMA0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXDMA0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDMA0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:26:07 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:30275 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753940AbXDMA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:26:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sfY1Fyg6SbNWMnMYXl6c/YGSbyvoVZfeoUsec+uxywsdeuKs98upALLL15XAqDXKRwEEXkSAjZoAeLlMdAY31qdHrJYLrxwW8lLWDRb7mR3mETNPUaGRdHZrSpKPSvG+sLXlnDf7Zm4oCU0keIc2uNzt1HW2ufkO7kxW/pggmLs=  ;
X-YMail-OSG: n01GjtgVM1k0t0ii4pHXWeo8Ljz_i64fqPGYHFCdgGL1p8sANu6gwlSLwFzXVj5xhESZ.qI92A--
Message-ID: <461ECE17.9050001@yahoo.com.au>
Date: Fri, 13 Apr 2007 10:25:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <20070412234209.GO2986@holomorphy.com>
In-Reply-To: <20070412234209.GO2986@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Thu, 12 Apr 2007 16:10:50 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
> 
>>>This solves a real-life problem for Oracle system monitoring software
>>>(specifically EM). Among the tasks it must carry out is determining
>>>per-process memory footprint of a set of cooperating tasks (i.e. Oracle
>>>processes). RSS is inadequate for this due to page sharing; this work
>>>provides sufficient information to determine what EM needs.
> 
> 
> On Thu, Apr 12, 2007 at 04:32:35PM -0700, Andrew Morton wrote:
> 
>>Not a good idea to expose raw flags in this manner - it changes at the drop
>>of a hat.  We'd need to also expose the kernel's PG_foo-to-bitnumber
>>mapping to make this viable.
>>Not a good idea to use page->_count: page_count() will be more stable. 
>>Otherwise OK, I guess: the interpretation of the page refcount is unlikely
>>to change much over time.
> 
> 
> EM wants to determine page_mapcount() for the most part for the
> purposes of determining "uniquely attributable RSS" (my ca. 2004
> nomenclature) or "proportional RSS" (mpm's more recent nomenclature);
> as things now stand it will have to infer them by maintaining a table
> of pfn's and mappings thereof, but at least that can be done with it.

I don't know whether you can easily determine page_mapcount with
page_count and flags, though (count gives you an educated guess,
but mapcount is the real thing).

page_mapcount sounds very reasonable to export. It is directly
tied with the userspace concept of mapping pages. page_count doesn't
seem very useful (and if you must have it, please use page_count),
neither does page flags.

You could have a bit indicating whether the page is free or not (but
that doesn't tell you much that meminfo or zoneinfo or buddyinfo does
not). Dirty/writeback/referenced/uptodate maybe?... I'm stumped,
what's flags for?

-- 
SUSE Labs, Novell Inc.
