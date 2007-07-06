Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbXGFFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbXGFFWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXGFFWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:22:33 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:46192 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbXGFFWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:22:33 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Eric W Biederman <ebiederm@xmission.com>
Date: Thu, 05 Jul 2007 22:20:29 -0700
Message-Id: <20070706052029.11677.16964.sendpatchset@balbir-laptop>
Subject: [-mm PATCH 0/8] Memory controller introduction (v2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since version 1

1. Fixed some compile time errors (in mm/migrate.c from Vaidyanathan S)
2. Fixed a panic seen when LIST_DEBUG is enabled
3. Added a mechanism to control whether we track page cache or both
   page cache and mapped pages (as requested by Pavel)

This patchset implements another version of the memory controller. These
patches have been through a big churn, the first set of patches were posted
last year and earlier this year at
	http://lkml.org/lkml/2007/2/19/10

Ever since, the RSS controller has been through four revisions, the latest
one being
	http://lwn.net/Articles/236817/

This patchset draws from the patches listed above and from some of the
contents of the patches posted by Vaidyanathan for page cache control.
	http://lkml.org/lkml/2007/6/20/92

Pavel, Vaidy could you look at the patches and add your signed off by
where relevant?

At OLS, the resource management BOF, it was discussed that we need to manage
RSS and unmapped page cache together. This patchset is a step towards that

TODO's

1. Add memory controller water mark support. Reclaim on high water mark
2. Add support for shrinking on limit change
3. Add per zone per container LRU lists
4. Make page_referenced() container aware
5. Figure out a better CLUI for the controller

In case you have been using/testing the RSS controller, you'll find that
this controller works slower than the RSS controller. The reason being
that both swap cache and page cache is accounted for, so pages do go
out to swap upon reclaim (they cannot live in the swap cache).

I've test compiled the framework without the controller enabled, tested
the code on UML and minimally on a power box.

Any test output, feedback, comments, suggestions are welcome!

series

res_counters_infra.patch
mem-control-setup.patch
mem-control-accounting-setup.patch
mem-control-accounting.patch
mem-control-task-migration.patch
mem-control-lru-and-reclaim.patch
mem-control-out-of-memory.patch

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
