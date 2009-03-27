Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZC0IDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZC0IDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZC0ID0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:03:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52352 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZC0IDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:03:24 -0400
Date: Fri, 27 Mar 2009 17:01:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/8] soft limit framework in memcg.
Message-Id: <20090327170154.99602776.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090327140346.8d27b69a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090327140346.8d27b69a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 14:03:46 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Add minimal modification for soft limit to res_counter_charge() and memcontol.c
> Based on Balbir Singh <balbir@linux.vnet.ibm.com> 's work but most of
> features are removed. (dropped or moved to later patch.)
> 
> This is for building a frame to implement soft limit handler in memcg.
>  - Checks soft limit status at every charge.
>  - Adds mem_cgroup_soft_limit_check() as a function to detect we need
>    check now or not.
>  - mem_cgroup_update_soft_limit() is a function for updates internal status
>    of soft limit controller of memcg.
>  - This has no hooks in uncharge path. (see later patch.)
Note:
Why I don't insert hook to uncharge() is because uncharge() is called under
spin locks (and my softlimit update() routine is heavy).
But need some hook anyway. I'll take care of this in other patch if I got new idea.

Thanks,
-Kame

