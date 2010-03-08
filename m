Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0CHR00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:26:26 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41658 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0CHR0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:26:20 -0500
Date: Mon, 8 Mar 2010 22:56:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2]  memcg: oom notifier and handling oom by user
Message-ID: <20100308172609.GS3073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-08 16:24:14]:

> This 2 patches is for memcg's oom handling.
> 
> At first, memcg's oom doesn't mean "no more resource" but means "we hit limit."
> Then, daemons/user shells out of a memcg can work even if it's under oom.
> So, if we have notifier and some more features, we can do something moderate
> rather than killing at oom. 
> 
> This patch includes
> [1/2] oom notifier for memcg (using evetfd framework of cgroups.)
> [2/2] oom killer disalibing and hooks for waitq and wake-up.
> 
> When memcg's oom-killer is disabled, all tasks which request accountable memory
> will sleep in waitq. It will be waken up by user's action as
>  - enlarge limit. (memory or memsw)
>  - kill some tasks
>  - move some tasks (account migration is enabled.)
> 

Hmm... I've not seen the waitq and wake-up patches, but does that mean
user space will control resumtion of tasks?


-- 
	Three Cheers,
	Balbir
