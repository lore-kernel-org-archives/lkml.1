Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0BVU32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0BVU30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:29:26 -0500
Message-ID: <4B82E8FF.90701@redhat.com>
Date: Mon, 22 Feb 2010 15:28:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] vmscan: drop page_mapping_inuse()
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <1266868150-25984-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1266868150-25984-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 02:49 PM, Johannes Weiner wrote:
> page_mapping_inuse() is a historic predicate function for pages that
> are about to be reclaimed or deactivated.
>
> According to it, a page is in use when it is mapped into page tables
> OR part of swap cache OR backing an mmapped file.
>
> This function is used in combination with page_referenced(), which
> checks for young bits in ptes and the page descriptor itself for the
> PG_referenced bit.  Thus, checking for unmapped swap cache pages is
> meaningless as PG_referenced is not set for anonymous pages and
> unmapped pages do not have young ptes.  The test makes no difference.
>
> Protecting file pages that are not by themselves mapped but are part
> of a mapped file is also a historic leftover for short-lived things
> like the exec() code in libc.  However, the VM now does reference
> accounting and activation of pages at unmap time and thus the special
> treatment on reclaim is obsolete.
>
> This patch drops page_mapping_inuse() and switches the two callsites
> to use page_mapped() directly.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

