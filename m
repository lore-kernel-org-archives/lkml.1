Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbXCTGMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbXCTGMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXCTGMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:12:15 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:34926 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752778AbXCTGMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:12:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oNPo0JnhQVz8PqnCNSEmgCe9BqFikB/rMni4mo1OypUBLDOWoWXqPjHD1Jx7HFcfwWm1eeAzopPH52dCZhNWp7ZXm+GcHW4mcYfW/PDnyow4IaV8lymA6ztV464taQv587ui2O2ee16ZpM+Ja2Y9CvYqyhkyQBbOnFvNkR55IbY=  ;
X-YMail-OSG: dlOIJI4VM1ktTCRe3KEMqrNVRZYW1hlrw.H.vRxXXN8uloMajL5T8b_XKVoeep_0C27X8vx4.rlMRsa25k1T9IEgmem6_3U93LNQj8dJ9nb6KE5U7WueE2DyYQgLN9NwrG4gfBZnjKZr5IM-
Message-ID: <45FF7B3A.70709@yahoo.com.au>
Date: Tue, 20 Mar 2007 17:12:10 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #2
References: <45FF3052.0@redhat.com>
In-Reply-To: <45FF3052.0@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Split the anonymous and file backed pages out onto their own pageout
> queues.  This we do not unnecessarily churn through lots of anonymous
> pages when we do not want to swap them out anyway.
> 
> This should (with additional tuning) be a great step forward in
> scalability, allowing Linux to run well on very large systems where
> scanning through the anonymous memory (on our way to the page cache
> memory we do want to evict) is slowing systems down significantly.
> 
> This patch has been stress tested and seems to work, but has not
> been fine tuned or benchmarked yet.  For now the swappiness parameter
> can be used to tweak swap aggressiveness up and down as desired, but
> in the long run we may want to simply measure IO cost of page cache
> and anonymous memory and auto-adjust.
> 
> We apply pressure to each of sets of the pageout queues based on:
> - the size of each queue
> - the fraction of recently referenced pages in each queue,
>    not counting used-once file pages
> - swappiness (file IO is more efficient than swap IO)
> 
> Please take this patch for a spin and let me know what goes well
> and what goes wrong.

This ignores whether a file page is mapped, doesn't it?

Even so, it could be a good approach anyway.

There are a couple of little nice improvements you have there, such as
treating shmem pages in the same class as anon pages. We found that we
needed something similar, so some of those things should go upstream
on their own.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
