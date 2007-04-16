Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXDPTEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXDPTEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbXDPTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:04:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:31322 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXDPTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:04:39 -0400
X-AuditID: d80ac287-a0943bb000002c59-d0-4623c8c61242 
Date: Mon, 16 Apr 2007 20:04:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: David Rientjes <rientjes@google.com>
cc: Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <Pine.LNX.4.64.0704161139020.12097@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0704161956510.13584@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
 <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
 <461FEF1C.5010806@vmware.com> <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704161139020.12097@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 Apr 2007 19:04:38.0700 (UTC) FILETIME=[14C1B6C0:01C7805A]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, David Rientjes wrote:
> 
> > Compromise patch below: would that be satisfactory to you, David?
> 
> I really like the patch, but for perhaps a slightly different reason: 
> we're only flushing ranges that have been shown to need it.  We aren't 
> completely flushing the entire mm which is likely to be excessive in 
> situations where we're actually using /proc/pid/clear_refs in combination 
> with /proc/pid/smaps for memory footprint approximation (i.e. it's on a 
> fine granularity).

It would be more of a reason to like the patch, if more architectures
actually implemented flush_tlb_range as anything different from
flush_tlb_mm ;)  Sadly, few can do better than flush_tlb_mm: ia64
is the exception I remember, and maybe a couple of others.  I put
flush_tlb_range there merely because it seems more appropriate,
but it's rather deceptive.

Hugh
