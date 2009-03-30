Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZCaAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZCaAAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZC3X76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:59:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45406 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZC3X76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:59:58 -0400
Date: Tue, 31 Mar 2009 08:58:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 4/8] memcg soft limit priority array queue.
Message-Id: <20090331085827.042fd4f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090329165620.GB15608@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090327140653.a12c6b1e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090329165620.GB15608@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 22:26:20 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 14:06:53]:
> 
> > I'm now search a way to reduce lock contention without complex...
> > -Kame
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > +static void __mem_cgroup_requeue(struct mem_cgroup *mem)
> > +{
> > +	/* enqueue to softlimit queue */
> > +	int prio = mem->soft_limit_priority;
> > +
> > +	spin_lock(&softlimitq.lock);
> > +	list_del_init(&mem->soft_limit_anon);
> > +	list_add_tail(&mem->soft_limit_anon, &softlimitq.queue[prio][SL_ANON]);
> > +	list_del_init(&mem->soft_limit_file,ist[SL_FILE]);
> 
> Patch fails to build here, what is ist?
> 
Hm...my patech is broken ?
&softlimitq.queue[prio][SL_FILE]

-Kame.

