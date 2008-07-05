Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYGEDzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYGEDzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 23:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYGEDyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 23:54:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40680 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYGEDyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 23:54:54 -0400
Date: Sat, 5 Jul 2008 12:59:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memcg: lru scan fix (Was: 2.6.26-rc8-mm1
Message-Id: <20080705125945.39c40e0a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080704122459.c309ae1c.akpm@linux-foundation.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080704180226.46436432.kamezawa.hiroyu@jp.fujitsu.com>
	<20080704151656.7745bfab@bree.surriel.com>
	<20080704122459.c309ae1c.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 12:24:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 4 Jul 2008 15:16:56 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
> > On Fri, 4 Jul 2008 18:02:26 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > Index: test-2.6.26-rc8-mm1/mm/vmscan.c
> > > ===================================================================
> > > --- test-2.6.26-rc8-mm1.orig/mm/vmscan.c
> > > +++ test-2.6.26-rc8-mm1/mm/vmscan.c
> > > @@ -1501,6 +1501,8 @@ static unsigned long shrink_zone(int pri
> > >  	 */
> > >  	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
> > >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> > > +	else if (!scan_global_lru(sc))
> > > +		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> > 
> > Makes sense.
> > 
> > Acked-by: Rik van Riel <riel@redhat.com>
> > 
> 
> Thanks.  Poor old me needs to work out which patch this patch fixes. 
> It's always appreciated if others tell me :)
> 

Maybe mine is against this one.
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/broken-out/vmscan-second-chance-replacement-for-anonymous-pages.patch

This adds inactive_anon_is_low() logic.

Thanks,
-Kame

