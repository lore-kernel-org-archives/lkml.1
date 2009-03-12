Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZCLIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZCLIrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZCLIrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:47:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56545 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZCLIrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:47:10 -0400
Date: Thu, 12 Mar 2009 17:45:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-Id: <20090312174544.536d562c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312082646.GA5828@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312034647.GA23583@balbir.in.ibm.com>
	<20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312050423.GI23583@balbir.in.ibm.com>
	<20090312143212.50818cd5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312082646.GA5828@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 13:56:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 14:32:12]:
> 
> > On Thu, 12 Mar 2009 10:34:23 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Not yet.. you just posted it. I am testing my v5, which I'll post
> > > soon. I am seeing very good results with v5. I'll test yours later
> > > today.
> > > 
> > 
> > If "hooks" to usual path doesn't exist and there are no global locks,
> > I don't have much concern with your version.
> 
> Good to know. I think it is always good to have competing patches and
> then collaborating and getting the best in.
> 
> > But 'sorting' seems to be overkill to me.
> > 
> 
> Sorting is very useful, specially if you have many cgroups. Without
> sorting, how do we select what group to select first.
> 
As I explained, if round-robin works well, ordering has no meaning.
That's just a difference of what is the fairness.

  1. In your method, recalaim at first from the user which exceeds the most
     is fair.
  2. In my method, reclaim from each cgroup in round robin is fair.

No big issue to users if the kernel policy is fixed.
Why I take "2" is that the usage of memcg doesn't mean the usage in the zone,
so, there are no big difference between 1 and 2 on NUMA.


Thanks,
-Kame

