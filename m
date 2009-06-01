Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZFAC0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZFAC0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 22:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZFAC0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 22:26:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZFAC0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 22:26:13 -0400
Message-ID: <4A233B77.3090404@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 10:22:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       mingo@elte.hu, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/2] cpuhotplug: use rw_semaphore for cpu_hotplug
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090529132328.99e7cae3.akpm@linux-foundation.org> <20090529210748.GA13449@redhat.com> <4A232662.5030308@cn.fujitsu.com>
In-Reply-To: <4A232662.5030308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> 
> down_read()/up_read() can be nested within down_read()/up_read(),
> so get_online_cpus() is recursive.
> 
> And thanks to cpu_hotplug.active_writer, get_online_cpus()/put_online_cpus()
> are allowd to be nested in cpu_hotplug_begin()/cpu_hotplug_done().
> So cpu_hotplug_begin() DO NOT blocks readers who are in CPU notifiers.
> 

Lai Jiangshan wrote:
> 
> The current code drops mutex when get_online_cpus() succeeds, BUT it
> increases the counter as what down_read() does. I think the current
> code has the same deadlocks which the down_read()-implement has.
> 
> Since the current code use mutex + counter to implement a "down_read()",
> why not use the down_read() directly?
> And down_read() can be checked by lockdep.
> 

Ouch, the kernel rw_semaphore is not Read-preference. All what I said
is garbage. I did miss this, sorry for bothered you all.

Lai

