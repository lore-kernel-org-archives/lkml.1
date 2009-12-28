Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbZL1D5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbZL1D5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZL1D5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:57:44 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36746 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZL1D5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:57:43 -0500
Date: Mon, 28 Dec 2009 09:27:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page in
 LRU list.
Message-ID: <20091228035738.GH3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
 <4B38246C.3020209@redhat.com>
 <20091228035639.GG3601@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091228035639.GG3601@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2009-12-28 09:26:39]:

> * Rik van Riel <riel@redhat.com> [2009-12-27 22:22:20]:
> 
> > On 12/27/2009 09:53 PM, Minchan Kim wrote:
> > >
> > >VM doesn't add zero page to LRU list.
> > >It means zero page's churning in LRU list is pointless.
> > >
> > >As a matter of fact, zero page can't be promoted by mark_page_accessed
> > >since it doesn't have PG_lru.
> > >
> > >This patch prevent unecessary mark_page_accessed call of zero page
> > >alghouth caller want FOLL_TOUCH.
> > >
> > >Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> > 
> > The code looks correct, but I wonder how frequently we run into
> > the zero page in this code, vs. how much the added cost is of
> > having this extra code in follow_page.
> > 
> > What kind of problem were you running into that motivated you
> > to write this patch?
> >
> 
> Frequent moving of zero page should ideally put it to the head of the
> LRU list, leaving it untouched is likely to cause it to be scanned 
> often - no? Should this be moved to the unevictable list? 
>

Sorry, I replied to wrong email, I should have been clearer that this
question is for Minchan Kim. 

-- 
	Balbir
