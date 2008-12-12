Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYLLBZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYLLBZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYLLBZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:25:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39924 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbYLLBZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:25:11 -0500
Date: Fri, 12 Dec 2008 10:24:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg: show real limit under hierarchy
Message-Id: <20081212102413.533057f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <661de9470812110600i6097ca0q7a2d7250f6c493dc@mail.gmail.com>
References: <20081211121135.e00f6a2d.kamezawa.hiroyu@jp.fujitsu.com>
	<20081211122237.4FF7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<661de9470812110600i6097ca0q7a2d7250f6c493dc@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 19:30:46 +0530
"Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:

> On Thu, Dec 11, 2008 at 8:54 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> I wonder other people who debugs memcg's hierarchy may use similar patches.
> >> this is my one.
> >> comments ?
> >> ==
> >> From:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>
> >> Show "real" limit of memcg.
> >> This helps my debugging and maybe useful for users.
> >>
> >> While testing hierarchy like this
> >>
> >>       mount -t cgroup none /cgroup -t memory
> >>       mkdir /cgroup/A
> >>       set use_hierarchy==1 to "A"
> >>       mkdir /cgroup/A/01
> >>       mkdir /cgroup/A/01/02
> >>       mkdir /cgroup/A/01/03
> >>       mkdir /cgroup/A/01/03/04
> >>       mkdir /cgroup/A/08
> >>       mkdir /cgroup/A/08/01
> >>       ....
> >> and set each own limit to them, "real" limit of each memcg is unclear.
> >> This patch shows real limit by checking all ancestors in memory.stat.
> >>
> >> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Great!
> >
> > I hoped to use this patch at hierarchy inactive_ratio debugging ;)
> 
> I like this very much too
> 
> I would prefer to use
> 
> min_limit = min(tmp, min_limit); and similarly for min_memsw_limit
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
Thanks, I'll upadte this and forward to Andrew.

-Kame


> Balbir
> 

