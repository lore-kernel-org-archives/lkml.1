Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZHTBR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZHTBR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZHTBRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:17:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZHTBRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:17:55 -0400
X-Greylist: delayed 2902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 21:17:54 EDT
Message-ID: <4A8C98DD.9030500@redhat.com>
Date: Wed, 19 Aug 2009 20:29:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] mm: Fix to infinite churning of mlocked page
References: <20090820085544.faed1ca4.minchan.kim@barrios-desktop>
In-Reply-To: <20090820085544.faed1ca4.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> Mlocked page might lost the isolatation race.
> It cause the page to clear PG_mlocked while it remains
> in VM_LOCKED vma. It means it can be put [in]active list.
> We can rescue it by try_to_unmap in shrink_page_list.
> 
> But now, As Wu Fengguang pointed out, vmscan have a bug.
> If the page has PG_referenced, it can't reach try_to_unmap
> in shrink_page_list but put into active list. If the page
> is referenced repeatedly, it can remain [in]active list
> without moving unevictable list.
> 
> This patch can fix it.
> 
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <<kosaki.motohiro@jp.fujitsu.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
