Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbZCBDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbZCBDIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZCBDIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:08:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52329 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZCBDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:08:08 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] Memory controller soft limit reclaim on contention (v3)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090301063041.31557.86588.sendpatchset@localhost.localdomain>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain> <20090301063041.31557.86588.sendpatchset@localhost.localdomain>
Message-Id: <20090302120052.6FEC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  2 Mar 2009 12:08:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

> @@ -2015,9 +2016,12 @@ static int kswapd(void *p)
>  		finish_wait(&pgdat->kswapd_wait, &wait);
>  
>  		if (!try_to_freeze()) {
> +			struct zonelist *zl = pgdat->node_zonelists;
>  			/* We can speed up thawing tasks if we don't call
>  			 * balance_pgdat after returning from the refrigerator
>  			 */
> +			if (!order)
> +				mem_cgroup_soft_limit_reclaim(zl, GFP_KERNEL);
>  			balance_pgdat(pgdat, order);
>  		}
>  	}

kswapd's roll is increasing free pages until zone->pages_high in "own node".
mem_cgroup_soft_limit_reclaim() free one (or more) exceed page in any node.

Oh, well.
I think it is not consistency.

if mem_cgroup_soft_limit_reclaim() is aware to target node and its pages_high,
I'm glad.




