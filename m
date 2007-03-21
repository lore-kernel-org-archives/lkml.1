Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXCULYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXCULYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXCULYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:24:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXCULYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:24:41 -0400
Message-ID: <460115D9.7030806@redhat.com>
Date: Wed, 21 Mar 2007 07:24:09 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nikita Danilov <nikita@clusterfs.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
References: <46005B4A.6050307@redhat.com> <17920.61568.770999.626623@gargle.gargle.HOWL>
In-Reply-To: <17920.61568.770999.626623@gargle.gargle.HOWL>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nikita Danilov wrote:
> Rik van Riel writes:
>  > [ OK, I suck.  I edited yesterday's email with the new info, but forgot
>  >    to change the attachment to today's patch.  Here is today's patch. ]
>  > 
>  > Split the anonymous and file backed pages out onto their own pageout
>  > queues.  This we do not unnecessarily churn through lots of anonymous
>  > pages when we do not want to swap them out anyway.
> 
> Won't this re-introduce problems similar to ones due to split
> inactive_clean/inactive_dirty queues we had in the past?
> 
> For example, by rotating anon queues faster than file queues, kernel
> would end up reclaiming anon pages that are hotter (in "absolute" LRU
> order) than some file pages.

That is why we check the fraction of referenced pages in each
queue.  Please look at the get_scan_ratio() and shrink_zone()
code in my patch.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
