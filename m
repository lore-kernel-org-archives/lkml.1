Return-Path: <linux-kernel-owner+w=401wt.eu-S1750980AbYIAFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbYIAFUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYIAFUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 01:20:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55930 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYIAFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 01:20:22 -0400
Date: Mon, 1 Sep 2008 14:17:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080901141750.37101182.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901130351.f005d5b6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080831174756.GA25790@balbir.in.ibm.com>
	<20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com>
	<48BB6160.4070904@linux.vnet.ibm.com>
	<20080901130351.f005d5b6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 13:03:51 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > That depends, if we can get the lockless page cgroup done quickly, I don't mind
> > waiting, but if it is going to take longer, I would rather push these changes
> > in. 
> The development of lockless-page_cgroup is not stalled. I'm just waiting for
> my 8cpu box comes back from maintainance...
> If you want to see, I'll post v3 with brief result on small (2cpu) box.
> 
This is current status (result of unixbench.)
result of 2core/1socket x86-64 system.

==
[disabled]
Execl Throughput                           3103.3 lps   (29.7 secs, 3 samples)
C Compiler Throughput                      1052.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               5915.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1142.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               586.0 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         131463.3 lpm   (30.0 secs, 3 samples)

[rc4mm1]
Execl Throughput                           3004.4 lps   (29.6 secs, 3 samples)
C Compiler Throughput                      1017.9 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               5726.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1124.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               576.0 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         125446.5 lpm   (30.0 secs, 3 samples)

[lockless]
Execl Throughput                           3041.0 lps   (29.8 secs, 3 samples)
C Compiler Throughput                      1025.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               5713.6 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)               1113.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               571.3 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         125417.9 lpm   (30.0 secs, 3 samples)
==

>From this, single-thread results are good. multi-process results are not good ;)
So, I think the number of atomic ops are reduced but I have should-be-fixed
contention or cache-bouncing problem yet. I'd like to fix this and check on 8 core
system when it is back.
Recently, I wonder within-3%-overhead is realistic goal.

Thanks,
-Kame




