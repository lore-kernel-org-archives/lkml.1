Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXDMDkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXDMDkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXDMDkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:40:19 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:36941 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752864AbXDMDkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:40:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=puyqvKLZFBLwMoljOh5TUsIzJNvGy7nVz21zao7gGBFBgz7kzpB5+RHm04N4Pw5KKLw4UzK2mdBKBYgTRyX1hPotDT5zYMFOB2BBnGp4uLjM4NfrhbbagvTwbw5vGzbC+FrGXxQJZ9FIcMIVksU8Wnk6kMJZhBd+/GhDU5V6tyw=  ;
X-YMail-OSG: N_KJLAIVM1mN2fNzpX1o67h53RUbbs8fO4r1R24rqO6BSm67ZMYdTrlPE9mr8FkPdX8CLywJYg--
Message-ID: <461EFB98.8050408@yahoo.com.au>
Date: Fri, 13 Apr 2007 13:40:08 +1000
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
> in C, perhaps.  Then you just end up with the same thing, don't you?

And my problem isn't with the hardcoded pagetable walker. Yeah, we'd
probably still keep the pagetable callback walker thingy with Matt's
associated cleanups (and my subsequent ones to clean it up more and
move it to mm/): there are other in-kernel users for that anyway.

The point is the proc API, and exposing random little parts of deep
kernel internals that some people happen to find useful at the time.
(which is why we have an incredible proliferation of these things).

With systemtap scripts, you could walk pagetables and print *the exact
page information you want*, or you could walk pfns, or LRU, or page_tree,
or walk the page tree then the rmap structures. And you can selectively
cull out items you don't care about if you only care about a subset of
items, based on arbitrary criteria. And you can most likely do all that
more efficiently than with a conglomeration of various /proc files
(assuming they even provide what you want in the first place).

-- 
SUSE Labs, Novell Inc.
