Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbXIEUiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbXIEUiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXIEUiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:38:14 -0400
Received: from ozlabs.org ([203.10.76.45]:41006 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbXIEUiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:38:13 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <46CE70C8.2030005@vmware.com>
References: <46CE70C8.2030005@vmware.com>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 06:37:46 +1000
Message-Id: <1189024666.10802.197.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 22:46 -0700, Zachary Amsden wrote:
> I recently sent off a fix for lazy vmalloc faults which can happen under 
> paravirt when lazy mode is enabled.  Unfortunately, I jumped the gun a 
> bit on fixing this.  I neglected to notice that since the new call to 
> flush the MMU update queue is called from the page fault handler, it can 
> be pre-empted.  Both VMI and Xen use per-cpu variables to track lazy 
> mode state, as all previous calls to set, disable, or flush lazy mode 
> happened from a non-preemptable state.

Hi Zach,

	I don't think this patch does anything.  The flush is because we want
the just-completed "set_pte" to have immediate effect, so if preempt is
enabled we're already screwed because we can be moved between set_pte
and the arch_flush_lazy_mmu_mode() call.

Now, where's the problem caller?  By my reading or rc4, vmalloc faults
are fixed up before enabling interrupts.

Confused,
Rusty.


