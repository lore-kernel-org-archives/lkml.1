Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZDUHMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZDUHMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUHMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:12:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:59418 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZDUHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nrSC/8x2FF8qXDNV5U6b7xkr2ocFRpK8UvSQZmiv04el8UfpF9KZSIVxqkN0J5tMIc
         AVu67KRwj5Ee/uLUSi6BJXwVGJQAgw8TUWNXYUA+/cvrE2JgTZee0Je6Ee3Sh2P2vRBa
         H/iQFgJWk0UKA3oU0ZEcyB7F1U5bJdwrN+/BU=
Date: Tue, 21 Apr 2009 16:12:19 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] low order lumpy reclaim also should use
 PAGEOUT_IO_SYNC.
Message-Id: <20090421161219.e13a928d.minchan.kim@barrios-desktop>
In-Reply-To: <20090421142056.F127.A69D9226@jp.fujitsu.com>
References: <20090421142056.F127.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki-san. 

On Tue, 21 Apr 2009 14:22:27 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.
> 
> commit 33c120ed2843090e2bd316de1588b8bf8b96cbde (more aggressively use lumpy reclaim)
> change lumpy reclaim using condition. but it isn't enough change.
> 
> lumpy reclaim don't only mean isolate neighber page, but also do pageout as synchronous.
> this patch does it.

I agree. 

Andi added  synchronous lumpy reclaim with c661b078fd62abe06fd11fab4ac5e4eeafe26b6d.
At that time, lumpy reclaim is not agressive. 
His intension is just for high-order users.(above PAGE_ALLOC_COSTLY_ORDER). 

After some time, Rik added aggressive lumpy reclaim with 33c120ed2843090e2bd316de1588b8bf8b96cbde.
His intension is that do lumpy reclaim when high-order users and trouble getting a small set of contiguous pages. 

So we also have to add synchronous pageout for small set of contiguous pages. 
Nice catch!. 

Reviewed-by: Minchan Kim <Minchan.kim@gmail.com>

BTW, Do you have any number ? 

-- 
Kinds Regards
Minchan Kim
