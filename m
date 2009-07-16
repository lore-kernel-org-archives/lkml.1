Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZGPEfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZGPEfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZGPEfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:35:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46212 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZGPEfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:35:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090715201657.b01edccd.akpm@linux-foundation.org>
References: <20090716095344.9D10.A69D9226@jp.fujitsu.com> <20090715201657.b01edccd.akpm@linux-foundation.org>
Message-Id: <20090716132639.9D31.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 13:35:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > reproduce way
> > -----------------------
> > % ./hackbench 140 process 1000
> >    => OOM occur
> > 
> > active_anon:146 inactive_anon:0 isolated_anon:49245
> >  active_file:79 inactive_file:18 isolated_file:113
> >  unevictable:0 dirty:0 writeback:0 unstable:0 buffer:39
> >  free:370 slab_reclaimable:309 slab_unreclaimable:5492
> >  mapped:53 shmem:15 pagetables:28140 bounce:0
> > 
> > @@ -1164,6 +1170,9 @@ static unsigned long shrink_inactive_lis
> >  				spin_lock_irq(&zone->lru_lock);
> >  			}
> >  		}
> > +		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
> > +		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
> > +
> >    	} while (nr_scanned < max_scan);
> 
> This is a non-trivial amount of extra stuff.  Do we really need it?

In general, Administrator really hate large amount unaccounted memory.
Recent msgctl11 discussion, We faced it isolate pages about 1/3 system 
memory.
Ahtough Rik's patch is applied, vmscan can isolate >1GB memory.

That's my point.





