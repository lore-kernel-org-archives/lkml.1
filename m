Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXFTQx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXFTQx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXFTQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:53:48 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:41148 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbXFTQxr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:53:47 -0400
Date: Wed, 20 Jun 2007 12:46:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 (x86_64? too) in 2.6.22-rc4-mm2
Message-ID: <20070620164614.GA8916@Krystal>
References: <20070619170914.GA30623@Krystal> <20070619200136.GA4943@Krystal> <200706201101.20673.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200706201101.20673.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:29:24 up 23 days, 8 min,  4 users,  load average: 1.28, 1.16, 0.88
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> On Tuesday 19 June 2007 22:01:36 Mathieu Desnoyers wrote:
> > Looking more closely into the code to find the cause of the
> > change_page_addr()/global_flush_tlb() inconsistency, I see where the
> > problem could be:
> 
> Yes it's a known problem. I have a hack queued for .22 and there
> are proposed patches for .23 too.
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/late-merge/patches/cpa-flush
> 
> -ANdi
> 

Hi Andi,

Although I cannot find it at the specified URL, I suspect it is already
in Andrew's tree, in 2.6.22-rc4-mm2, under the name

"x86_64-mm-cpa-cache-flush.patch"

But Andrew's
"revert-x86_64-mm-cpa-cache-flush.patch"

Is applied subsequently, along with the Changelog:

From: Andrew Morton <akpm@linux-foundation.org>

This causes my dual-pIII to hang after "write protecting kernel memory".

config: http://userweb.kernel.org/~akpm/config-vmm.txt

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Is the version found in 2.6.22-rc4-mm2 the latest ?

I propose to verify if the i386:

if (!PageReserved(kpte_page)) {
   if (cpu_has_pse

check should be also integrated into the global flush tlb ? It would
cause machines not supporting PSE to try to free non existing large
pages, and also would cause problems with reserved pages.

It does not seem to fix the hang on my P4 neither though.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
