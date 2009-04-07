Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZDGK4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZDGK4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZDGK4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:56:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59872 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZDGK4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:56:12 -0400
Message-ID: <49DB306A.8070407@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 18:52:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC][PATCH 0/3] cpuset,mm: fix memory spread bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel still allocated the page caches on old node after modifying its
cpuset's mems when 'memory_spread_page' was set, or it didn't spread the page
cache evenly over all the nodes that faulting task is allowed to usr after
memory_spread_page was set. it is caused by the old mem_allowed and flags
of the task, the current kernel doesn't updates them unless some function
invokes cpuset_update_task_memory_state(), it is too late sometimes.We must
update the mem_allowed and the flags of the tasks in time.

Slab has the same problem.

The following patches fix this bug by updating tasks' mem_allowed and spread
flag after its cpuset's mems or spread flag is changed.

patch 1: restructure the function cpuset_update_task_memory_state()
patch 2: update tasks' page/slab spread flags in time
patch 3: update tasks' mems_allowed in time


