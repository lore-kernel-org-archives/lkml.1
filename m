Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZCFJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZCFJ4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZCFJ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:56:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57631 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZCFJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:56:04 -0500
Date: Fri, 6 Mar 2009 18:54:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v4)
Message-Id: <20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 14:53:23 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> New Feature: Soft limits for memory resource controller.
> 
> Changelog v4...v3
> 1. Adopted suggestions from Kamezawa to do a per-zone-per-node reclaim
>    while doing soft limit reclaim. We don't record priorities while
>    doing soft reclaim
> 2. Some of the overheads associated with soft limits (like calculating
>    excess each time) is eliminated
> 3. The time_after(jiffies, 0) bug has been fixed
> 4. Tasks are throttled if the mem cgroup they belong to is being soft reclaimed
>    and at the same time tasks are increasing the memory footprint and causing
>    the mem cgroup to exceed its soft limit.
> 
I don't think this "4" is necessary.


> Changelog v3...v2
> 1. Implemented several review comments from Kosaki-San and Kamezawa-San
>    Please see individual changelogs for changes
> 
> Changelog v2...v1
> 1. Soft limits now support hierarchies
> 2. Use spinlocks instead of mutexes for synchronization of the RB tree
> 
> Here is v4 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. The CPU controllers interpretation
> of shares is very different though. 
> 
> Soft limits are the most useful feature to have for environments where
> the administrator wants to overcommit the system, such that only on memory
> contention do the limits become active. The current soft limits implementation
> provides a soft_limit_in_bytes interface for the memory controller and not
> for memory+swap controller. The implementation maintains an RB-Tree of groups
> that exceed their soft limit and starts reclaiming from the group that
> exceeds this limit by the maximum amount.
> 
> If there are no major objections to the patches, I would like to get them
> included in -mm.
> 
You got Nack from me, again ;) And you know why.
I'll post my one later, I hope that one will be good input for you.

Thanks,
-Kame


