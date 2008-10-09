Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYJIHcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYJIHcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYJIHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:31:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:29368 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbYJIHby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VpnOMY0iSFlWNkmMWk9xXGTzxwKwuqQn0l+h786iHsBSPdNY3VwC/H915lf1hYy+kN
         lR6OSpypDtOZcTi9xLtJVB3WDj6gr7hZaHQflcH6T4qOtzOPEVhw+vxhSIeL9hlTybUo
         IXcoq4KC83qAqJajqubQug8YEtU9Ef+dvQptM=
Message-ID: <48EDB373.2050704@gmail.com>
Date: Thu, 09 Oct 2008 09:32:03 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] documentation: clarify dirty_ratio and dirty_background_ratio
 description
References: <48EC90EC.8060306@gmail.com> <20081009105157.dd47d109.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081009105157.dd47d109.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 08 Oct 2008 12:52:28 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> The current documentation of dirty_ratio and dirty_background_ratio is a
>> bit misleading.
>>
>> In the documentation we say that they are "a percentage of total system
>> memory", but the current page writeback policy, intead, is to apply the
>> percentages to the dirtyable memory, that means free pages + reclaimable
>> pages.
>>
> Right.
> 
>> Better to be more explicit to clarify this concept.
>>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> 
> But I wonder "reclaimable memory" seems to be a difficult word for users....
> 
> "free pages + mapped pages + file cache, not including locked page and HugePage"
> ?
> Anyway,
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Sounds better. I'll add these details and post a new patch.

Thanks,
-Andrea

> 
>> ---
>>  Documentation/filesystems/proc.txt |   11 ++++++-----
>>  1 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
>> index f566ad9..be69c8b 100644
>> --- a/Documentation/filesystems/proc.txt
>> +++ b/Documentation/filesystems/proc.txt
>> @@ -1380,15 +1380,16 @@ causes the kernel to prefer to reclaim dentries and inodes.
>>  dirty_background_ratio
>>  ----------------------
>>  
>> -Contains, as a percentage of total system memory, the number of pages at which
>> -the pdflush background writeback daemon will start writing out dirty data.
>> +Contains, as a percentage of the dirtyable system memory (free pages +
>> +reclaimable pages), the number of pages at which the pdflush background
>> +writeback daemon will start writing out dirty data.
>>  
>>  dirty_ratio
>>  -----------------
>>  
>> -Contains, as a percentage of total system memory, the number of pages at which
>> -a process which is generating disk writes will itself start writing out dirty
>> -data.
>> +Contains, as a percentage of the dirtyable system memory (free pages +
>> +reclaimable pages), the number of pages at which a process which is generating
>> +disk writes will itself start writing out dirty data.
>>  
>>  dirty_writeback_centisecs
>>  -------------------------
>>
