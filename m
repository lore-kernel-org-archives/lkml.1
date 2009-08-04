Return-Path: <linux-kernel-owner+w=401wt.eu-S933249AbZHDS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbZHDS2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbZHDS2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:28:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174AbZHDS2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:28:39 -0400
Message-ID: <4A787D84.2030207@redhat.com>
Date: Tue, 04 Aug 2009 14:27:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Larry Woodman <lwoodman@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing script
 for page-allocator-related ftrace events
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>	<1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
In-Reply-To: <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue,  4 Aug 2009 19:12:26 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> 
>> This patch adds a simple post-processing script for the page-allocator-related
>> trace events. It can be used to give an indication of who the most
>> allocator-intensive processes are and how often the zone lock was taken
>> during the tracing period. Example output looks like
>>
>> find-2840
>>  o pages allocd            = 1877
>>  o pages allocd under lock = 1817
>>  o pages freed directly    = 9
>>  o pcpu refills            = 1078
>>  o migrate fallbacks       = 48
>>    - fragmentation causing = 48
>>      - severe              = 46
>>      - moderate            = 2
>>    - changed migratetype   = 7
> 
> The usual way of accumulating and presenting such measurements is via
> /proc/vmstat.  How do we justify adding a completely new and different
> way of doing something which we already do?

Mel's tracing is more akin to BSD process accounting,
where these statistics are kept on a per-process basis.

Nothing in /proc allows us to see statistics on a per
process basis on process exit.

-- 
All rights reversed.
