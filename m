Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYDPAdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYDPAdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYDPAcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:32:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:14491 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYDPAcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MIQ5FP6A6YdDJFRo5XN5lMFN0ACsDrI6znfk9lgN0IeBqGAFb4Ts0AcjG0OXlnfdJs+q1oorqaPAk6DWyTz4yGACFAD2VY8AYuN/hvnoU/wa4JWHzktBzRVjU995diww798K1c2CTn1uZ97UAFH1roi1/7JF5rQ9rja6qk2JFX8=
Message-ID: <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
Date: Tue, 15 Apr 2008 17:32:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416001816.GA26295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415161532.GA15088@elte.hu>
	 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
	 <20080415195430.GA23015@elte.hu>
	 <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
	 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
	 <20080415204025.GA29784@elte.hu>
	 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	 <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 5:18 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > finally found it ... the patch below solves the sparsemem crash and
>  > the testsystem boots up fine now:
>  >
>  >   mars:~> uname -a
>  >   Linux mars 2.6.25-rc9-sched-devel.git-x86-latest.git #985 SMP Wed Apr 16
>  >   01:37:37 CEST 2008 i686 i686 i386 GNU/Linux
>
>  i re-checked the original SLAB config too and that boots fine as well
>  now - so i'm confident that the regression has been sufficiently cured.
>
>  it's getting quite late here (or rather, it's getting early :-/ ) so it
>  would be nice if others could double-check this calculation (with an eye
>  on all possible architectures):
>
>  +       unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>
>  and also check my analysis whether it is correct and whether it matches
>  the reported bug patterns. But otherwise the fix looks like a safe fix
>  for v2.6.25-final to me - it only filters out values from sparsemem
>  input that are nonsensical in the sparsemem framework anyway.
>
>         Ingo
>

can you check why find_max_pfn() e820_32.c need to call memory_present?
wonder if it can be removed.

YH
