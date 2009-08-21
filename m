Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZHUDz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZHUDz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 23:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZHUDz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 23:55:27 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:43416 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZHUDz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 23:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cIqOMC4wg8efUWlNzVWl3UNLT88Jm8PbSMFWIIl2orpt6yEnhwvc6OTQMDZn14hfUG
         gMyw8M2pkCMyULxBmJe/hTVZlbT4+OQpGoJkBoCmybeAeu970u9ywEclR5VqOZwPvSm2
         +Wms8PGLSrwMMt5sca3ShXgw2y3oAZf9czWIY=
MIME-Version: 1.0
In-Reply-To: <20090820040533.GA27540@localhost>
References: <20090820024929.GA19793@localhost>
	 <20090820121347.8a886e4b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090820040533.GA27540@localhost>
Date: Fri, 21 Aug 2009 12:55:27 +0900
Message-ID: <28c262360908202055u2744879cic989e007867d0599@mail.gmail.com>
Subject: Re: [PATCH -v2] mm: do batched scans for mem_cgroup
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 1:05 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Thu, Aug 20, 2009 at 11:13:47AM +0800, KAMEZAWA Hiroyuki wrote:
>> On Thu, 20 Aug 2009 10:49:29 +0800
>> Wu Fengguang <fengguang.wu@intel.com> wrote:
>>
>> > For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
>> > in which case shrink_list() _still_ calls isolate_pages() with the much
>> > larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
>> > scan rate by up to 32 times.
>> >
>> > For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
>> > So when shrink_zone() expects to scan 4 pages in the active/inactive
>> > list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.
>> >
>> > The accesses to nr_saved_scan are not lock protected and so not 100%
>> > accurate, however we can tolerate small errors and the resulted small
>> > imbalanced scan rates between zones.
>> >
>> > This batching won't blur up the cgroup limits, since it is driven by
>> > "pages reclaimed" rather than "pages scanned". When shrink_zone()
>> > decides to cancel (and save) one smallish scan, it may well be called
>> > again to accumulate up nr_saved_scan.
>> >
>> > It could possibly be a problem for some tiny mem_cgroup (which may be
>> > _full_ scanned too much times in order to accumulate up nr_saved_scan).
>> >
>> > CC: Rik van Riel <riel@redhat.com>
>> > CC: Minchan Kim <minchan.kim@gmail.com>
>> > CC: Balbir Singh <balbir@linux.vnet.ibm.com>
>> > CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

It looks better than now :)

I hope you will rewrite description and add test result in changelog. :)
Thanks for your great effort.

-- 
Kind regards,
Minchan Kim
