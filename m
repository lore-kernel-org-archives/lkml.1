Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZL1Fd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZL1Fd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 00:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZL1Fd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 00:33:57 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49857 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZL1Fd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 00:33:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=PJy4+WKvVZgfYRFOaB/jnXX3dfyI+wygGdV4U2ujr91ZL9yXDnHbq1lH6HLhUq6cdE
         tIfMB7HdXEV76gNKsH8vyu7Qwq1SB66s50an4rchkJ5S5WtI46t04OZmTe/5xdmDTb7s
         wNdTbjNdbWbVxwEvp5KdUlkmdebsttWGCrJkM=
Date: Mon, 28 Dec 2009 14:31:54 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20091228143154.ec0431b5.minchan.kim@barrios-desktop>
In-Reply-To: <20091228134752.44d13c34.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	<20091228134752.44d13c34.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Mon, 28 Dec 2009 13:47:52 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 28 Dec 2009 13:46:19 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > 
> > I am not sure we have to account zero page with file_rss. 
> > Hugh and Kame's new zero page doesn't do it. 
> > As side effect of this, we can prevent innocent process which have a lot
> > of zero page when OOM happens. 
> > (But I am not sure there is a process like this :)
> > So I think not file_rss counting is not bad. 
> > 
> > RSS counting zero page with file_rss helps any program using smaps?
> > If we have to keep the old behavior, I have to remake this patch. 
> > 
> > == CUT_HERE ==
> > 
> > Long time ago, We regards zero page as file_rss and
> > vm_normal_page doesn't return NULL.
> > 
> > But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
> > can return NULL in case of zero page. Also we don't count it with
> > file_rss any more.
> > 
> > Then, RSS and PSS can't be matched.
> > For consistency, Let's ignore zero page in smaps_pte_range.
> > 
> > CC: Matt Mackall <mpm@selenic.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks for ACK. :)

> 
> BTW, how about counting ZERO page in smaps? Ignoring them completely sounds
> not very good.

I am not use it is useful. 

zero page snapshot of ongoing process is useful?
Doesn't Admin need to know about zero page?
Let's admins use it well. If we remove zero page again?
How many are applications use smaps? 
Did we have a problem without it?

When I think of it, there are too many qeustions. 
Most important thing to add new statistics is just need of customer. 

Frankly speaking, I don't have good scenario of using zero page.
Do you have any scenario it is valueable?

> 
> Thanks,
> -Kame



-- 
Kind regards,
Minchan Kim
