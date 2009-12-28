Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478AbZL1EL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbZL1EL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZL1ELZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:11:25 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43375 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZL1ELY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BTMil2qZgmv35xhLj1I7wsTKvtOhJYEPWOCk1gzy6RqKpPn7hP0aR5nnY0w2gdq/Eu
         QWMYbtUeDnPfzQ3SYHLcrMqfQiUedXPEiKNuKxVxEXmaoK/oox1V5PvYObMh9cQTvHCY
         njOsVnLzE3ooXt3Q3ftIbTLey04rqiYBnUNOI=
Date: Mon, 28 Dec 2009 13:09:26 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page
 in LRU list.
Message-Id: <20091228130926.6874d7b2.minchan.kim@barrios-desktop>
In-Reply-To: <4B38246C.3020209@redhat.com>
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
	<4B38246C.3020209@redhat.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik. 

On Sun, 27 Dec 2009 22:22:20 -0500
Rik van Riel <riel@redhat.com> wrote:

> On 12/27/2009 09:53 PM, Minchan Kim wrote:
> >
> > VM doesn't add zero page to LRU list.
> > It means zero page's churning in LRU list is pointless.
> >
> > As a matter of fact, zero page can't be promoted by mark_page_accessed
> > since it doesn't have PG_lru.
> >
> > This patch prevent unecessary mark_page_accessed call of zero page
> > alghouth caller want FOLL_TOUCH.
> >
> > Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> 
> The code looks correct, but I wonder how frequently we run into
> the zero page in this code, vs. how much the added cost is of
> having this extra code in follow_page.
> 
> What kind of problem were you running into that motivated you
> to write this patch?

I didn't have experienced any problem in this case. 
In fact, I found that while trying to make patch smap_pte_change. 

Long time ago when we have a zero page, we regards it to file_rss. 
So while we see the smaps, vm_normal_page returns zero page and we can
calculate it properly with PSS. 

But now we don't acccout zero page to file_rss. 
I am not sure we have to account it with file_rss. 
So I think now smaps_pte_range's resident count routine also is changed. 

Anyway, I think my patch doesn't have much cost since many customers of 
follow_page are already not a fast path.

I tend to agree with your opinion "How frequently we runt into the zero page?"
But my thought GUP is export function which can be used for anything by anyone.

Thanks for the review, Rik. 

> 
> -- 
> All rights reversed.


-- 
Kind regards,
Minchan Kim
