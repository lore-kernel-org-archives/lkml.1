Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXGEIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXGEIyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXGEIyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:54:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14688 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163AbXGEIyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:54:06 -0400
Message-ID: <468CB658.7000204@openvz.org>
Date: Thu, 05 Jul 2007 13:14:00 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@osdl.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [-mm PATCH 0/7] Memory controller introduction
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop>
In-Reply-To: <20070704222108.17702.40293.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Resending with the patch numbering fixed and linux-mm copied
> 
> This patchset implements another version of the memory controller. These
> patches have been through a big churn, the first set of patches were posted
> last year and earlier this year at
> 	http://lkml.org/lkml/2007/2/19/10
> 
> Ever since, the RSS controller has been through four revisions, the latest
> one being
> 	http://lwn.net/Articles/236817/
> 
> This patchset draws from the patches listed above and from some of the
> contents of the patches posted by Vaidyanathan for page cache control.
> 	http://lkml.org/lkml/2007/6/20/92
> 
> Pavel, Vaidy could you look at the patches and add your signed off by
> where relevant?

As far as I remember at OLS we decided to implement per-zone RLU
lists and reuse the lru lock as well. This will remove all the 
problems with per-container lists inconsistency.

Separate limits for RSS and RSS+pagecache are also a must.

BTW, if you send smb. else's patches you may include a 'From: xxx'
line into the letter to address the original author.

> At OLS, the resource management BOF, it was discussed that we need to manage
> RSS and unmapped page cache together. This patchset is a step towards that
> 
> TODO's
> 
> 1. Add memory controller water mark support. Reclaim on high water mark
> 2. Add support for shrinking on limit change
> 3. Add per zone per container LRU lists
> 4. Make page_referenced() container aware
> 5. Figure out a better CLUI for the controller
> 
> In case you have been using/testing the RSS controller, you'll find that
> this controller works slower than the RSS controller. The reason being
> that both swap cache and page cache is accounted for, so pages do go
> out to swap upon reclaim (they cannot live in the swap cache).
> 
> I've test compiled the framework without the controller enabled, tested
> the code on UML and minimally on a power box.
> 
> Any test output, feedback, comments, suggestions are welcome!
> 
> series
> 
> res_counters_infra.patch
> mem-control-setup.patch
> mem-control-accounting-setup.patch
> mem-control-accounting.patch
> mem-control-task-migration.patch
> mem-control-lru-and-reclaim.patch
> mem-control-out-of-memory.patch
> 

