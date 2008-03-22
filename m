Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYCVUtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYCVUtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYCVUtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:49:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYCVUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:49:31 -0400
Date: Sat, 22 Mar 2008 13:46:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to avoid spurious lockdep warnings?
Message-ID: <20080322134656.173de045@laptopd505.fenrus.org>
In-Reply-To: <47E2ECF3.2050606@goop.org>
References: <47E2ECF3.2050606@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 16:02:11 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> In a Xen system, when a new pagetable is about to be put in use it is 
> "pinned", meaning that each page in the pagetable is registered with
> the hypervisor.  This is done in arch/x86/xen/mmu.c:pin_page().
> 
> In order to make this efficient, the hypercalls for pinning are
> batched, so that multiple pages are submitted at once in a single
> multicall. While a page is batched pending the hypercall, its
> corresponding pte_lock is held.
> 
> This means that the code can end up holding multiple pte locks at
> once, though it is guaranteed to never try to hold the same lock at
> once. However, because these locks are in the same lock class, I get
> a spurious warning from lockdep.  Is there some way I can get rid of
> this warning?


what's the ordering guarantee between these locks ?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
