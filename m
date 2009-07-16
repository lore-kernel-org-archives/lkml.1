Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZGPOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZGPOnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZGPOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:43:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbZGPOnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:43:52 -0400
Message-ID: <4A5F3C70.7010001@redhat.com>
Date: Thu, 16 Jul 2009 10:42:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
References: <20090716133454.GA20550@localhost>  <alpine.DEB.1.10.0907160959260.32382@gentwo.org>  <20090716142533.GA27165@localhost> <1247754491.6586.23.camel@laptop> <alpine.DEB.1.10.0907161037590.7930@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907161037590.7930@gentwo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 16 Jul 2009, Peter Zijlstra wrote:
> 
>>> What would you suggest?  In fact I'm not totally comfortable with it.
>>> Maybe it would be safer to simply stick with the old _lru_pages
>>> naming?
>> Nah, I like the reclaimable name, these pages are at least potentially
>> reclaimable.
>>
>> lru_pages() is definately not correct anymore since you exclude the
>> unevictable and possibly the anon pages.
> 
> Well lets at least add a comment at the beginning of the functions
> explaining that these are potentially reclaimable and list some of the
> types of pages that may not be reclaimable.

The pages that are not reclaimable will be on the
unevictable LRU list, not on the lists we count.

The only case of pages not being evictable is the
anon pages, once swap fills up.

-- 
All rights reversed.
