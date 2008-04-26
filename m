Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYDZNRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYDZNRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYDZNRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:17:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752360AbYDZNRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:17:39 -0400
Date: Sat, 26 Apr 2008 08:17:34 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080426131734.GB19717@sgi.com>
References: <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com> <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com> <20080423002848.GA32618@sgi.com> <20080423163713.GC24536@duo.random> <20080423221928.GV24536@duo.random> <20080424064753.GH24536@duo.random> <20080424095112.GC30298@sgi.com> <20080424153943.GJ24536@duo.random> <20080424174145.GM24536@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424174145.GM24536@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 07:41:45PM +0200, Andrea Arcangeli wrote:
> A full new update will some become visible here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.25/mmu-notifier-v14-pre3/

I grabbed these and built them.  Only change needed was another include.
After that, everything built fine and xpmem regression tests ran through
the first four sets.  The fifth is the oversubscription test which trips
my xpmem bug.  This is as good as the v12 runs from before.

Since this include and the one for mm_types.h both are build breakages
for ia64, I think you need to apply your ia64_cpumask and the following
(possibly as a single patch) first or in your patch 1.  Without that,
ia64 doing a git-bisect could hit a build failure.


Index: mmu_v14_pre3_xpmem_v003_v1/include/linux/srcu.h
===================================================================
--- mmu_v14_pre3_xpmem_v003_v1.orig/include/linux/srcu.h	2008-04-26 06:41:54.000000000 -0500
+++ mmu_v14_pre3_xpmem_v003_v1/include/linux/srcu.h	2008-04-26 07:01:17.292071827 -0500
@@ -27,6 +27,8 @@
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
+#include <linux/mutex.h>
+
 struct srcu_struct_array {
 	int c[2];
 };
