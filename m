Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZLKDT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZLKDT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZLKDTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:19:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZLKDTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:19:54 -0500
Message-ID: <4B21BA54.1090103@redhat.com>
Date: Thu, 10 Dec 2009 22:19:48 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
In-Reply-To: <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 09:03 PM, Minchan Kim wrote:

>> +The default value is 8.
>> +
>> +=============================================================
>
> I like this. but why do you select default value as constant 8?
> Do you have any reason?
>
> I think it would be better to select the number proportional to NR_CPU.
> ex) NR_CPU * 2 or something.
>
> Otherwise looks good to me.

Pessimistically, I assume that the pageout code spends maybe
10% of its time on locking (we have seen far, far worse than
this with thousands of processes in the pageout code).  That
means if we have more than 10 threads in the pageout code,
we could end up spending more time on locking and less doing
real work - slowing everybody down.

I rounded it down to the closest power of 2 to come up with
an arbitrary number that looked safe :)

However, this number is per zone - I imagine that really large
systems will have multiple memory zones, so they can run with
more than 8 processes in the pageout code simultaneously.

> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

Thank you.

-- 
All rights reversed.
