Return-Path: <linux-kernel-owner+w=401wt.eu-S1031012AbXDPWMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031012AbXDPWMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031013AbXDPWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:12:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48439 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031012AbXDPWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:12:05 -0400
Message-ID: <4623F3EF.9040406@vmware.com>
Date: Mon, 16 Apr 2007 15:08:47 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com> <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com> <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com> <461FEF1C.5010806@vmware.com> <Pine.LNX.4.64.0704161831500.8213@blonde.wat.veritas.com> <Pine.LNX.4.64.0704161139020.12097@chino.kir.corp.google.com> <Pine.LNX.4.64.0704161956510.13584@blonde.wat.veritas.com> <Pine.LNX.4.64.0704161217310.12685@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0704161217310.12685@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Sure, but what I really like about the patch is that we're only flushing 
> something if !flush_end in the first place.  So we can eliminate any TLB 
> flushing if that VMA didn't need it; that's a change from the current 
> behavior.  And since the most obvious use-case for /proc/pid/clear_refs is 
> in conjunction with /proc/pid/smaps for approximating memory footprint, 
> we'll end up saving TLB flushes because the granularity with which that 
> measurement is taken is usually very fine.
>
> Acked-by: David Rientjes <rientjes@google.com>
>   

I like the patch even better if you still batch the flushes, but keep 
the !flush_end machinery.  If I read it correctly, flush_start stays at 
the lower bound for the whole function, so it is still accurate later.  
And with the flush outside the spinlock, contention time is lower.

Thanks,

Zach
