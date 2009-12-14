Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZLNOky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZLNOky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZLNOkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZLNOkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:40:53 -0500
Message-ID: <4B264E66.9050206@redhat.com>
Date: Mon, 14 Dec 2009 09:40:38 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <87pr6hya86.fsf@basil.nowhere.org>
In-Reply-To: <87pr6hya86.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 08:08 AM, Andi Kleen wrote:
> Rik van Riel<riel@redhat.com>  writes:
>
>> +max_zone_concurrent_reclaim:
>> +
>> +The number of processes that are allowed to simultaneously reclaim
>> +memory from a particular memory zone.
>> +
>> +With certain workloads, hundreds of processes end up in the page
>> +reclaim code simultaneously.  This can cause large slowdowns due
>> +to lock contention, freeing of way too much memory and occasionally
>> +false OOM kills.
>> +
>> +To avoid these problems, only allow a smaller number of processes
>> +to reclaim pages from each memory zone simultaneously.
>> +
>> +The default value is 8.
>
> I don't like the hardcoded number. Is the same number good for a 128MB
> embedded system as for as 1TB server?  Seems doubtful.
>
> This should be perhaps scaled with memory size and number of CPUs?

The limit is per _zone_, so the number of concurrent reclaimers
is automatically scaled by the number of memory zones in the
system.

Scaling up the per-zone value as well looks like it could lead
to the kind of lock contention we are aiming to avoid in the
first place.

-- 
All rights reversed.
