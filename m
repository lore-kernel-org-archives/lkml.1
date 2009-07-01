Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZGAC5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZGAC5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZGAC5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:57:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZGAC5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:57:46 -0400
Message-ID: <4A4AD07E.2040508@redhat.com>
Date: Tue, 30 Jun 2009 22:57:02 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wu Fengguang <fengguang.wu@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
References: <20090701021645.GA6356@localhost> <20090701022644.GA7510@localhost> <20090701114959.85D3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090701114959.85D3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>> [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
>> [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
>> [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
>> [ 1522.019262]  isolate:69817
> 
> OK. thanks.
> I plan to submit this patch after small more tests. it is useful for OOM analysis.

It is also useful for throttling page reclaim.

If more than half of the inactive pages in a zone are
isolated, we are probably beyond the point where adding
additional reclaim processes will do more harm than good.

-- 
All rights reversed.
