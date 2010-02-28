Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0B1RuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 12:50:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab0B1RuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:50:01 -0500
Message-ID: <4B8AAC9A.10203@redhat.com>
Date: Sun, 28 Feb 2010 12:49:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: used-once mapped file page detection
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <20100224133946.a5092804.akpm@linux-foundation.org> <20100226143232.GA13001@cmpxchg.org>
In-Reply-To: <20100226143232.GA13001@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 09:32 AM, Johannes Weiner wrote:
> On Wed, Feb 24, 2010 at 01:39:46PM -0800, Andrew Morton wrote:
>> On Mon, 22 Feb 2010 20:49:07 +0100 Johannes Weiner<hannes@cmpxchg.org>  wrote:
>>
>>> This patch makes the VM be more careful about activating mapped file
>>> pages in the first place.  The minimum granted lifetime without
>>> another memory access becomes an inactive list cycle instead of the
>>> full memory cycle, which is more natural given the mentioned loads.
>>
>> iirc from a long time ago, the insta-activation of mapped pages was
>> done because people were getting peeved about having their interactive
>> applications (X, browser, etc) getting paged out, and bumping the pages
>> immediately was found to help with this subjective problem.
>>
>> So it was a latency issue more than a throughput issue.  I wouldn't be
>> surprised if we get some complaints from people for the same reasons as
>> a result of this patch.
>
> Agreed.  Although we now have other things in place to protect them once
> they are active (VM_EXEC protection, lazy active list scanning).

You think we'll need VM_EXEC protection on the inactive list
after your changes?

