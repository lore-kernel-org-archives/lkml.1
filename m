Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZCLEDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZCLEDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZCLED1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:03:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44579 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZCLED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:03:27 -0400
Date: Thu, 12 Mar 2009 13:02:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 5/5] memcg softlimit hooks to kswapd
Message-Id: <20090312130200.5c0e19d1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312035837.GD23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312100008.aa8379d7.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312035837.GD23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:28:37 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 10:00:08]:

> > +	return;
> > +}
> 
> I experimented a *lot* with zone reclaim and found it to be not so
> effective. Here is why
> 
> 1. We have no control over priority or how much to scan, that is
> controlled by balance_pgdat(). If we find that we are unable to scan
> anything, we continue scanning with the scan > 0 check, but we scan
> the same pages and the same number, because shrink_zone does scan >>
> priority.

If sc->nr_reclaimd==0, "false" is passed and mem_cgroup_schedule_end()
and it will be moved to INACTIVE queue. (and not appear here again.)


> 2. If we fail to reclaim pages in shrink_zone_softlimit, shrink_zone()
> will reclaim pages independent of the soft limit for us
> 
yes. It's intentional behavior.

Thanks,
-Kame

