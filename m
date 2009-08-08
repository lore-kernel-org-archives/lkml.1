Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZHHFrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZHHFrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 01:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZHHFrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 01:47:15 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:55346 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZHHFrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 01:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OoH51+W+uv32xP15glCtf1mrDNIbO9lsuiegZr9oOcxUMx6ghtFcXlOrsXGkQRde9l
         dqxH9wSnXCX6f0TdPIPvNQPXpxwOR5pxrH1vEn67x3EdPxHJ8fOMqmgGqy+THkychb2M
         LMTYujm4e61nhxoVETwFpsQjR/RBX6NWR82LE=
MIME-Version: 1.0
In-Reply-To: <1249666815-28784-2-git-send-email-mel@csn.ul.ie>
References: <1249666815-28784-1-git-send-email-mel@csn.ul.ie>
	 <1249666815-28784-2-git-send-email-mel@csn.ul.ie>
Date: Sat, 8 Aug 2009 14:47:13 +0900
X-Google-Sender-Auth: d62748086717695a
Message-ID: <2f11576a0908072247y3d17c977i31ea3bca82058083@mail.gmail.com>
Subject: Re: [PATCH 1/6] tracing, page-allocator: Add trace events for page 
	allocation and page freeing
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/8 Mel Gorman <mel@csn.ul.ie>:
> This patch adds trace events for the allocation and freeing of pages,
> including the freeing of pagevecs.  Using the events, it will be known what
> struct page and pfns are being allocated and freed and what the call site
> was in many cases.
>
> The page alloc tracepoints be used as an indicator as to whether the workload
> was heavily dependant on the page allocator or not. You can make a guess based
> on vmstat but you can't get a per-process breakdown. Depending on the call
> path, the call_site for page allocation may be __get_free_pages() instead
> of a useful callsite. Instead of passing down a return address similar to
> slab debugging, the user should enable the stacktrace and seg-addr options
> to get a proper stack trace.
>
> The pagevec free tracepoint has a different usecase. It can be used to get
> a idea of how many pages are being dumped off the LRU and whether it is
> kswapd doing the work or a process doing direct reclaim.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>

Looks good to me.
  Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
