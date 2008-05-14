Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYENFBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYENFBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYENFA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:00:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46465 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYENFA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:00:58 -0400
Date: Wed, 14 May 2008 14:04:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Bryan Wu" <cooloney@kernel.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] [mm] buddy page allocator: add tunable big order
 allocation
Message-Id: <20080514140423.4c004019.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <386072610805132122l5d017fe1u404c38ea3f05664a@mail.gmail.com>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	<1210588325-11027-2-git-send-email-cooloney@kernel.org>
	<20080513110902.80a87ac9.kamezawa.hiroyu@jp.fujitsu.com>
	<8A42379416420646B9BFAC9682273B6D015F52E4@limkexm3.ad.analog.com>
	<386072610805132122l5d017fe1u404c38ea3f05664a@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 12:22:35 +0800
"Bryan Wu" <cooloney@kernel.org> wrote:

> On Tue, May 13, 2008 at 7:42 PM, Hennerich, Michael
> <Michael.Hennerich@analog.com> wrote:
> >
> >
> >  >-----Original Message-----
> >  >From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> >  >Sent: Dienstag, 13. Mai 2008 04:09
> >  >To: Bryan Wu
> >  >Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> >  dwmw2@infradead.org;
> >  >Michael Hennerich
> >  >Subject: Re: [PATCH 1/4] [mm] buddy page allocator: add tunable big
> >  order
> >  >allocation
> >  >
> >  >On Mon, 12 May 2008 18:32:02 +0800
> >  >Bryan Wu <cooloney@kernel.org> wrote:
> >  >
> >  >> From: Michael Hennerich <michael.hennerich@analog.com>
> >  >>
> >  >> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> >  >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >  >
> >  >Does this really solve your problem ? possible hang-up is better than
> >  >page allocation failure ?
> >
> >  On nommu this helped quite a bit, when we run out of memory, eaten up by
> >  the page cache. But yes - with this option it's likely that we sit there
> >  and wait form memory that might never get available.
> >
> >  We now use a better workaround for freeing up "available" memory
> >  currently used as page cache.
> >
> >  I think we should drop this patch.
> >
> 
> OK, I dropped it. And do you think the limited page_cache patch is the
> replacement of this patch?
> 

I'm not so familiar with nommu environments but have some thoughts.

one idea is 
 - use memory resource controller.
   but this eats much amount of GFP_KERNEL memory and maybe not useful ;)
 - use ZONE_MOVABLE and set lowmem_reserve_ratio value to be suitable value.
   then, the page cache just uses MOVABLE zone...(maybe)

Thanks,
-Kame











