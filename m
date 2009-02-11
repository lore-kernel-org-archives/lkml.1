Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZBKND2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZBKND2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZBKNDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:03:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37602 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbZBKNDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:03:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] shrink_all_memory() use sc.nr_reclaimed
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090211215654.C3D6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090211214324.6a9cfb58.minchan.kim@barrios-desktop> <20090211215654.C3D6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20090211220044.C3D9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 22:03:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I mean here.
> > 
> > '
> >               NR_LRU_BASE + l)); 
> >         ret += shrink_list(l, nr_to_scan, zone,
> >                 sc, prio);
> >         if (ret >= nr_pages)
> >           return ret; 
> >       }    
> > '
> > 
> > I have to make patch again so that it will keep on old bale-out behavior. 
> 
> Sure.
> thanks.

As I mean,

@@ -2082,15 +2082,14 @@ static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
 				nr_to_scan = min(nr_pages,
 					zone_page_state(zone,
 							NR_LRU_BASE + l));
				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
								sc, prio);
-				if (nr_reclaimed >= nr_pages) 
-				if (nr_reclaimed > sc.swap_cluster_max) 
					break;
 		}
 	}


this is keep old behavior and consist shrink_zone(), I think.


