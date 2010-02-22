Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0BVUfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab0BVUfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:35:05 -0500
Message-ID: <4B82EA4D.8040305@redhat.com>
Date: Mon, 22 Feb 2010 15:34:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] vmscan: detect mapped file pages used only once
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <1266868150-25984-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1266868150-25984-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 02:49 PM, Johannes Weiner wrote:
> The VM currently assumes that an inactive, mapped and referenced file
> page is in use and promotes it to the active list.
>
> However, every mapped file page starts out like this and thus a problem
> arises when workloads create a stream of such pages that are used only
> for a short time.  By flooding the active list with those pages, the VM
> quickly gets into trouble finding eligible reclaim canditates.  The
> result is long allocation latencies and eviction of the wrong pages.
>
> This patch reuses the PG_referenced page flag (used for unmapped file
> pages) to implement a usage detection that scales with the speed of
> LRU list cycling (i.e. memory pressure).
>
> If the scanner encounters those pages, the flag is set and the page
> cycled again on the inactive list.  Only if it returns with another
> page table reference it is activated.  Otherwise it is reclaimed as
> 'not recently used cache'.
>
> This effectively changes the minimum lifetime of a used-once mapped
> file page from a full memory cycle to an inactive list cycle, which
> allows it to occur in linear streams without affecting the stable
> working set of the system.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

