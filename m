Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237Ab0AUP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0AUP34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731Ab0AUP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:29:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44955 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0AUP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:29:54 -0500
Message-ID: <4B5872EC.5040603@linux.vnet.ibm.com>
Date: Thu, 21 Jan 2010 20:59:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com, minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom-kill: add lowmem usage aware oom kill handling
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 January 2010 11:29 AM, KAMEZAWA Hiroyuki wrote:
> A patch for avoiding oom-serial-killer at lowmem shortage.
> Patch is onto mmotm-2010/01/15 (depends on mm-count-lowmem-rss.patch)
> Tested on x86-64/SMP + debug module(to allocated lowmem), works well.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> One cause of OOM-Killer is memory shortage in lower zones.
> (If memory is enough, lowmem_reserve_ratio works well. but..)
> 
> In lowmem-shortage oom-kill, oom-killer choses a vicitim process
> on their vm size. But this kills a process which has lowmem memory
> only if it's lucky. At last, there will be an oom-serial-killer.
> 
> Now, we have per-mm lowmem usage counter. We can make use of it
> to select a good? victim.

Have you seen any use cases that need this change? Or is it mostly via
code review and to utilize the availability of lowmem rss? Do we often
run into lowmem shortage triggering OOM?


-- 
Three Cheers,
Balbir Singh
