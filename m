Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbZENR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbZENR0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZENR0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:26:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZENR0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:26:24 -0400
Message-ID: <4A0C5434.3040905@redhat.com>
Date: Thu, 14 May 2009 13:26:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: MinChan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case
 of no swap space V3
References: <20090514231555.f52c81eb.minchan.kim@gmail.com> <20090514093050.43472421.akpm@linux-foundation.org>
In-Reply-To: <20090514093050.43472421.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 14 May 2009 23:15:55 +0900
> MinChan Kim <minchan.kim@gmail.com> wrote:
> 
>> Now shrink_zone can deactivate active anon pages even if we don't have a swap device. 
>> Many embedded products don't have a swap device. So the deactivation of anon pages is unnecessary. 
> 
> Does shrink_list() need to scan the anon LRUs at all if there's no swap
> online?

It doesn't.  Get_scan_ratio() will return 0 as the
anon percentage if no swap is online.
