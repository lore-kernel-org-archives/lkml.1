Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYKENvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYKENvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYKENve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:51:34 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37807 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbYKENvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:51:33 -0500
Message-ID: <4911A4D8.4010402@linux.vnet.ibm.com>
Date: Wed, 05 Nov 2008 19:21:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm][PATCH 0/4] Memory cgroup hierarchy introduction
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop> <20081104091510.01cf3a1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081104091510.01cf3a1e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 02 Nov 2008 00:18:12 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patch follows several iterations of the memory controller hierarchy
>> patches. The hardwall approach by Kamezawa-San[1]. Version 1 of this patchset
>> at [2].
>>
>> The current approach is based on [2] and has the following properties
>>
>> 1. Hierarchies are very natural in a filesystem like the cgroup filesystem.
>>    A multi-tree hierarchy has been supported for a long time in filesystems.
>>    When the feature is turned on, we honor hierarchies such that the root
>>    accounts for resource usage of all children and limits can be set at
>>    any point in the hierarchy. Any memory cgroup is limited by limits
>>    along the hierarchy. The total usage of all children of a node cannot
>>    exceed the limit of the node.
>> 2. The hierarchy feature is selectable and off by default
>> 3. Hierarchies are expensive and the trade off is depth versus performance.
>>    Hierarchies can also be completely turned off.
>>
>> The patches are against 2.6.28-rc2-mm1 and were tested in a KVM instance
>> with SMP and swap turned on.
>>
> 
> As first impression, I think hierarchical LRU management is not good...means
> not fair from viewpoint of memory management.

Could you elaborate on this further? Is scanning of children during reclaim the
issue? Do you want weighted reclaim for each of the children?

> I'd like to show some other possible implementation of
> try_to_free_mem_cgroup_pages() if I can.
> 

Elaborate please!

> Anyway, I have to merge this with mem+swap controller. 

Cool! I'll send you an updated version.

-- 
	Balbir
