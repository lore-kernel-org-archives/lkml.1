Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYKDAP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYKDAP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 19:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKDAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 19:15:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57875 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYKDAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 19:15:46 -0500
Date: Tue, 4 Nov 2008 09:15:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm][PATCH 0/4] Memory cgroup hierarchy introduction
Message-Id: <20081104091510.01cf3a1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 00:18:12 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> This patch follows several iterations of the memory controller hierarchy
> patches. The hardwall approach by Kamezawa-San[1]. Version 1 of this patchset
> at [2].
> 
> The current approach is based on [2] and has the following properties
> 
> 1. Hierarchies are very natural in a filesystem like the cgroup filesystem.
>    A multi-tree hierarchy has been supported for a long time in filesystems.
>    When the feature is turned on, we honor hierarchies such that the root
>    accounts for resource usage of all children and limits can be set at
>    any point in the hierarchy. Any memory cgroup is limited by limits
>    along the hierarchy. The total usage of all children of a node cannot
>    exceed the limit of the node.
> 2. The hierarchy feature is selectable and off by default
> 3. Hierarchies are expensive and the trade off is depth versus performance.
>    Hierarchies can also be completely turned off.
> 
> The patches are against 2.6.28-rc2-mm1 and were tested in a KVM instance
> with SMP and swap turned on.
> 

As first impression, I think hierarchical LRU management is not good...means
not fair from viewpoint of memory management.
I'd like to show some other possible implementation of
try_to_free_mem_cgroup_pages() if I can.

Anyway, I have to merge this with mem+swap controller. 

Thanks,
-Kame



