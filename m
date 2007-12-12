Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbXLLTPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbXLLTPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXLLTP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:15:27 -0500
Received: from gw.goop.org ([64.81.55.164]:54021 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbXLLTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:15:25 -0500
Message-ID: <47603321.4030700@goop.org>
Date: Wed, 12 Dec 2007 11:14:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: What was the problem with quicklists and x86-64?
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at unifying the various pgalloc+pgd_lists mechanisms between
32-bit (PAE and non-PAE) and 64-bit, so I'm trying to understand why
these differences exist in the first place.

Change da8f153e51290e7438ba7da66234a864e5d3e1c1 reverted the use of
quicklists for allocating pagetables, because of concerns about ordering
with respect to tlb flushes.

Some questions about this:

   1. What's the difference between quicklists and normal page
      allocation with respect to tlb flushing?
   2. Why doesn't this also affect i386's use of quicklists?
   3. Is there some way to resolve this tlb interaction so that
      quicklists can be used?
   4. Failing that, what's the cost of reverting i386's use of
      quicklists too?


Thanks,
    J
