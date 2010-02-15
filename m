Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0BOCvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:51:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51545 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab0BOCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:51:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 0/7 -mm] oom killer rewrite
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
Message-Id: <20100215114715.7278.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 11:51:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset is a rewrite of the out of memory killer to address several
> issues that have been raised recently.  The most notable change is a
> complete rewrite of the badness heuristic that determines which task is
> killed; the goal was to make it as simple and predictable as possible
> while still addressing issues that plague the VM.
> 
> This patchset is based on mmotm-2010-02-05-15-06 because of the following
> dependencies:

At first, I'm glad that you tackle this issue. unfortunatelly I'm very busy now.
but I'll make a time for reviewing this patches asap.




> 
> 	[patch 4/7] oom: badness heuristic rewrite:
> 		mm-count-swap-usage.patch
> 
> 	[patch 5/7] oom: replace sysctls with quick mode:
> 		sysctl-clean-up-vm-related-variable-delcarations.patch
> 
> To apply to mainline, download 2.6.33-rc7 and apply
> 
> 	mm-clean-up-mm_counter.patch
> 	mm-avoid-false-sharing-of-mm_counter.patch
> 	mm-avoid-false_sharing-of-mm_counter-checkpatch-fixes.patch
> 	mm-count-swap-usage.patch
> 	mm-count-swap-usage-checkpatch-fixes.patch
> 	mm-introduce-dump_page-and-print-symbolic-flag-names.patch
> 	sysctl-clean-up-vm-related-variable-declarations.patch
> 	sysctl-clean-up-vm-related-variable-declarations-fix.patch
> 
> from http://userweb.kernel.org/~akpm/mmotm/broken-out.tar.gz first.
> ---
>  Documentation/filesystems/proc.txt |   78 ++++---
>  Documentation/sysctl/vm.txt        |   51 ++---
>  fs/proc/base.c                     |   13 +-
>  include/linux/mempolicy.h          |   13 +-
>  include/linux/oom.h                |   18 +-
>  kernel/sysctl.c                    |   15 +-
>  mm/mempolicy.c                     |   39 +++
>  mm/oom_kill.c                      |  455 +++++++++++++++++++-----------------
>  mm/page_alloc.c                    |    3 +
>  9 files changed, 383 insertions(+), 302 deletions(-)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



