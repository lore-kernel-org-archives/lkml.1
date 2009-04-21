Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZDUHkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZDUHkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZDUHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:40:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:54555 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZDUHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=NnSe0Y8bQMEvqJMV/KzkLzKlXHN7aWk5y3ACM+4wp+Hu/1tzvKMybvh2rH5d50Phma
         mQLi60JrQYqdXc9PWo8kNo6JKbGUErT9IPRfDv5qfcGBWDqivCVGYUqBAEF3YylBMVVn
         E93VgbvFnuCnV9paXNYm4NvpTZ4BuRgWSW/Mk=
Date: Tue, 21 Apr 2009 16:39:54 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] low order lumpy reclaim also should use
 PAGEOUT_IO_SYNC.
Message-Id: <20090421163954.eabf5543.minchan.kim@barrios-desktop>
In-Reply-To: <20090421161829.F139.A69D9226@jp.fujitsu.com>
References: <20090421142056.F127.A69D9226@jp.fujitsu.com>
	<20090421161219.e13a928d.minchan.kim@barrios-desktop>
	<20090421161829.F139.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 16:21:18 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Hi, Kosaki-san. 
> > 
> > On Tue, 21 Apr 2009 14:22:27 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Subject: [PATCH] low order lumpy reclaim also should use PAGEOUT_IO_SYNC.
> > > 
> > > commit 33c120ed2843090e2bd316de1588b8bf8b96cbde (more aggressively use lumpy reclaim)
> > > change lumpy reclaim using condition. but it isn't enough change.
> > > 
> > > lumpy reclaim don't only mean isolate neighber page, but also do pageout as synchronous.
> > > this patch does it.
> > 
> > I agree. 
> > 
> > Andi added  synchronous lumpy reclaim with c661b078fd62abe06fd11fab4ac5e4eeafe26b6d.
> > At that time, lumpy reclaim is not agressive. 
> > His intension is just for high-order users.(above PAGE_ALLOC_COSTLY_ORDER). 
> > 
> > After some time, Rik added aggressive lumpy reclaim with 33c120ed2843090e2bd316de1588b8bf8b96cbde.
> > His intension is that do lumpy reclaim when high-order users and trouble getting a small set of contiguous pages. 
> > 
> > So we also have to add synchronous pageout for small set of contiguous pages. 
> > Nice catch!. 
> > 
> > Reviewed-by: Minchan Kim <Minchan.kim@gmail.com>
> > 
> > BTW, Do you have any number ? 
> 
> No.
> 
> Actually, this logic only run when system is strongly memory stavation
> or fragment. not normal case.
> 
> At that time, another slowdown thing hide synchronous reclaim latency, I think.
> 

Yes. I think it's hard measure, too. 
I was just out of curiosity if server guy have a any benchmark method. ;-)


-- 
Kinds Regards
Minchan Kim
