Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXJEPq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXJEPq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbXJEPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:46:21 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:15582 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758492AbXJEPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:46:20 -0400
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 05 Oct 2007 16:46:14 +0100
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
From: Keir Fraser <keir@xensource.com>
To: Hugh Dickins <hugh@veritas.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C32C1AD6.167B3%keir@xensource.com>
Thread-Topic: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Thread-Index: AcgHZtwNGsbpFXNaEdynTQAX8io7RQ==
In-Reply-To: <Pine.LNX.4.64.0710051601430.14565@blonde.wat.veritas.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07 16:33, "Hugh Dickins" <hugh@veritas.com> wrote:

> If a 2.6.23 fix is needed, I suggest simply excluding split ptlocks
> in the Xen case, as shown by the mm/Kconfig - line in Jan's patch.

I didn't think that nobbling config options for particular pv_ops
implementations was acceptable? I'm rather out of the loop though, and could
be wrong.

The PREEMPT_BITS limitation is a good argument for at least taking the pte
locks in small batches though (small batches is preferable to one-by-one
since we will want to batch the make-readonly-and-pin hypercall requests to
amortise the cost of the hypervisor trap).

 -- Keir

