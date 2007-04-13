Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXDMHDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXDMHDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXDMHDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:03:51 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:40263 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752264AbXDMHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:03:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=g7BbJY7iHyuJiKBsNQL71Rm1ap9ZL6btFjlDBF2Ywjn/esIvUBlMTlBaTzb9B1Bf0e9marP7T+rlVIlPHD29PQj9kjLRBV332X/XzwSsuzIO2ehszUjCt/0rOwWpXrwkvQKP6OcIy++VvliSVrZQuSPnehQFZ+TBNq1TAJ/K9po=  ;
X-YMail-OSG: yLjcabgVM1nd7QREJ5RUhTq3XkAcuJtiygoO4MLiyM0TNi49LYnbD0bAB00xjFq_9FAZeQUhYQ--
Message-ID: <461F2B4F.90506@yahoo.com.au>
Date: Fri, 13 Apr 2007 17:03:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EFB98.8050408@yahoo.com.au> <20070413065545.GQ2986@holomorphy.com>
In-Reply-To: <20070413065545.GQ2986@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Andrew Morton wrote:
> 
>>>Do a full pagetable walk, with all the associated locking from within
>>>a systemtap script?  I'd be surprised.  Maybe if it's mostly hand-coded
>>>in C, perhaps.  Then you just end up with the same thing, don't you?
> 
> 
> On Fri, Apr 13, 2007 at 01:40:08PM +1000, Nick Piggin wrote:
> 
>>And my problem isn't with the hardcoded pagetable walker. Yeah, we'd
>>probably still keep the pagetable callback walker thingy with Matt's
>>associated cleanups (and my subsequent ones to clean it up more and
>>move it to mm/): there are other in-kernel users for that anyway.
>>The point is the proc API, and exposing random little parts of deep
>>kernel internals that some people happen to find useful at the time.
>>(which is why we have an incredible proliferation of these things).
>>With systemtap scripts, you could walk pagetables and print *the exact
>>page information you want*, or you could walk pfns, or LRU, or page_tree,
>>or walk the page tree then the rmap structures. And you can selectively
>>cull out items you don't care about if you only care about a subset of
>>items, based on arbitrary criteria. And you can most likely do all that
>>more efficiently than with a conglomeration of various /proc files
>>(assuming they even provide what you want in the first place).
> 
> 
> The EM guys are unwilling or unable for support-oriented reasons to
> deal with anything but unmodified kernels as shipped by distros.

And I think major distros ship with kprobes enabled, so that is yet
another reason why systemtap should be considered before adding these
proc interfaces.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
