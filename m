Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXAWERy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXAWERy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXAWERy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:17:54 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32986 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932258AbXAWERx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:17:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PsmDYqQAroYNEmUTxzCaJj+nzMz7vXljUj6cEmencEsfR65rI+PxvN7uCym1yT0ykzbaLiRNEBCypX35cTWlykSrsobh5OZcO8OcCTHXzlDBf1Ru1WfrWtFFks+UQtl8ivUtE/w269hEW9uchSt4/HDDGmoe6gJH1VjIGZFTEU8=  ;
X-YMail-OSG: lvuR3DMVM1lnbUN07_Gxr5Hx9fdBEmXEp_.9o.sA2h9Ir7heFxE2YjUYzdQBYdSIaQfS0bppwQ--
Message-ID: <45B58C5C.8010900@yahoo.com.au>
Date: Tue, 23 Jan 2007 15:17:32 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: balbir@in.ibm.com
CC: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com>
In-Reply-To: <45B56575.10807@in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

> This makes me wonder if it makes sense to split up the LRU into page
> cache LRU and mapped pages LRU. I see two benefits
> 
> 1. Currently based on swappiness, we might walk an entire list
>    searching for page cache pages or mapped pages. With these
>    lists separated, it should get easier and faster to implement
>    this scheme
> 2. There is another parallel thread on implementing page cache
>    limits. If the lists split out, we need not scan the entire
>    list to find page cache pages to evict them.
> 
> Of course I might be missing something (some piece of history)

I actually had patches to do "split active lists" a while back.

They worked by lazily moving the page at reclaim-time, based on
whether or not it is mapped. This isn't too much worse than the
kernel's current idea of what a mapped page is.

They actually got a noticable speedup of the swapping kbuild
workload, but at this stage there were some more basic
improvements needed, so the difference could be smaller today.

The other nice thing about it was that it didn't have a hard
cutoff that the current reclaim_mapped toggle does -- you could
opt to scan the mapped list at a lower ratio than the unmapped
one. Of course, it also has some downsides too, and would
require retuning...

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
