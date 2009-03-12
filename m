Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZCLB7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZCLB7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZCLB66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:58:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49315 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbZCLB65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:58:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, akpm@linux-foundation.org, menage@google.com,
       peterz@infradead.org
Subject: [RFC] IO Controller
Date: Wed, 11 Mar 2009 21:56:45 -0400
Message-Id: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi All,

Here is another posting for IO controller patches. Last time I had posted
RFC patches for an IO controller which did bio control per cgroup.

http://lkml.org/lkml/2008/11/6/227

One of the takeaway from the discussion in this thread was that let us
implement a common layer which contains the proportional weight scheduling
code which can be shared by all the IO schedulers.

Implementing IO controller will not cover the devices which don't use
IO schedulers but it should cover the common case.

There were more discussions regarding 2 level vs 1 level IO control at
following link.

https://lists.linux-foundation.org/pipermail/containers/2009-January/015402.html

So in the mean time we took the discussion off the list and spent time on
making the 1 level control apporoach work where majority of the proportional
weight control is shared by the four schedulers instead of each one having
to replicate the code. We make use of BFQ code for fair queuing as posted
by Paolo and Fabio here.

http://lkml.org/lkml/2008/11/11/148

Details about design and howto have been put in documentation patch.

I have done very basic testing of running 2 or 3 "dd" threads in different
cgroups. Wanted to get the patchset out for feedback/review before we dive
into more bug fixing, benchmarking, optimizations etc.

Your feedback/comments are welcome.

Patch series contains 10 patches. It should be compilable and bootable after
every patch. Intial 2 patches implement flat fair queuing (no cgroup
support) and make cfq to use that. Later patches introduce hierarchical
fair queuing support in elevator layer and modify other IO schdulers to use
that.

Thanks
Vivek
