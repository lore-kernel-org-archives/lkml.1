Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZGWCG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZGWCG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGWCG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:06:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZGWCG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:06:27 -0400
Message-ID: <4A67C5BB.3070302@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 10:06:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpu_hotplug: don't affect current task's affinity
References: <4A5C4626.8000000@cn.fujitsu.com> <20090722150246.6d28003a.akpm@linux-foundation.org>
In-Reply-To: <20090722150246.6d28003a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> 
> Or are you saying that the mask _should_ have been 0-1,3 but the kernel
> incorrectly set it to "0"?
> 

Yes, the mask should become 0-1,3. when original is 2 after cpu2 is offlined.

When cpu2 is offined

original mask			after cpu2 is offined
1				1
1-2				1
0-3				0-1,3
2				0-1,3
2(the task who do the offline)  0

I think the last line is incorrect. This patch fix it.


> 
> Also, it says "The recovery of the current tasks's cpus_allowed will
> fail under some conditions".  What are those conditions?
> 

A condition is described in changelog(the same as above).

An example of other condition: the CPUSET of the task is changed
when this task do the offline... the last recovery may fails.

