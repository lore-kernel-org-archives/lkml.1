Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZGEMV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZGEMV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZGEMVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:21:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46550 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZGEMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:21:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090705121308.GC5252@localhost>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com> <20090705121308.GC5252@localhost>
Message-Id: <20090705211739.091D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 21:21:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 05, 2009 at 05:26:18PM +0800, KOSAKI Motohiro wrote:
> > Subject: [PATCH] add NR_ANON_PAGES to OOM log
> > 
> > show_free_areas can display NR_FILE_PAGES, but it can't display
> > NR_ANON_PAGES.
> > 
> > this patch fix its inconsistency.
> > 
> > 
> > Reported-by: Wu Fengguang <fengguang.wu@gmail.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/page_alloc.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: b/mm/page_alloc.c
> > ===================================================================
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2216,6 +2216,7 @@ void show_free_areas(void)
> >  		printk("= %lukB\n", K(total));
> >  	}
> >  
> > +	printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
> >  	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
> 
> Can we put related items together, ie. this looks more friendly:
> 
>         Anon:XXX active_anon:XXX inactive_anon:XXX
>         File:XXX active_file:XXX inactive_file:XXX

hmmm. Actually NR_ACTIVE_ANON + NR_INACTIVE_ANON != NR_ANON_PAGES.
tmpfs pages are accounted as FILE, but it is stay in anon lru.

I think your proposed format easily makes confusion. this format cause to
imazine Anon = active_anon + inactive_anon.

At least, we need to use another name, I think.



