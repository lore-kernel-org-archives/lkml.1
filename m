Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYGDT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYGDT0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYGDTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:25:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYGDTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:25:53 -0400
Date: Fri, 4 Jul 2008 12:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memcg: lru scan fix (Was: 2.6.26-rc8-mm1
Message-Id: <20080704122459.c309ae1c.akpm@linux-foundation.org>
In-Reply-To: <20080704151656.7745bfab@bree.surriel.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080704180226.46436432.kamezawa.hiroyu@jp.fujitsu.com>
	<20080704151656.7745bfab@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 15:16:56 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Fri, 4 Jul 2008 18:02:26 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Index: test-2.6.26-rc8-mm1/mm/vmscan.c
> > ===================================================================
> > --- test-2.6.26-rc8-mm1.orig/mm/vmscan.c
> > +++ test-2.6.26-rc8-mm1/mm/vmscan.c
> > @@ -1501,6 +1501,8 @@ static unsigned long shrink_zone(int pri
> >  	 */
> >  	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
> >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> > +	else if (!scan_global_lru(sc))
> > +		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> 
> Makes sense.
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 

Thanks.  Poor old me needs to work out which patch this patch fixes. 
It's always appreciated if others tell me :)

