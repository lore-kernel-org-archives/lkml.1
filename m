Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZL1FqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZL1FqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 00:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZL1FqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 00:46:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37465 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZL1FqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 00:46:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 14:43:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20091228144302.864f2e97.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228143154.ec0431b5.minchan.kim@barrios-desktop>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	<20091228134752.44d13c34.kamezawa.hiroyu@jp.fujitsu.com>
	<20091228143154.ec0431b5.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 14:31:54 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > BTW, how about counting ZERO page in smaps? Ignoring them completely sounds
> > not very good.
> 
> I am not use it is useful. 
> 
> zero page snapshot of ongoing process is useful?
> Doesn't Admin need to know about zero page?
> Let's admins use it well. If we remove zero page again?
> How many are applications use smaps? 
> Did we have a problem without it?
> 
My concern is that hiding indormation which was exported before.
No more than that and no strong demand.


> When I think of it, there are too many qeustions. 
> Most important thing to add new statistics is just need of customer. 
> 
> Frankly speaking, I don't have good scenario of using zero page.
> Do you have any scenario it is valueable?
> 
read before write ? maybe sometimes happens.

For example. current glibc's calloc() avoids memset() if the pages are
dropped by MADVISE (without unmap). 

Before starting zero-page works, I checked "questions" in lkml and
found some reports that some applications start to go OOM after zero-page
removal.

For me, I know one of my customer's application depends on behavior of
zero page (on RHEL5). So, I tried to add again it before RHEL6 because
I think removal of zero-page corrupts compatibility.

Thanks,
-Kame

