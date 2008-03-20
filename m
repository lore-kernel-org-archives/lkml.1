Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYCTXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYCTXp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYCTXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:45:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYCTXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:45:17 -0400
Subject: Re: How to avoid spurious lockdep warnings?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47E2ECF3.2050606@goop.org>
References: <47E2ECF3.2050606@goop.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 00:44:58 +0100
Message-Id: <1206056698.6437.70.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 16:02 -0700, Jeremy Fitzhardinge wrote:
> In a Xen system, when a new pagetable is about to be put in use it is 
> "pinned", meaning that each page in the pagetable is registered with the 
> hypervisor.  This is done in arch/x86/xen/mmu.c:pin_page().
> 
> In order to make this efficient, the hypercalls for pinning are batched, 
> so that multiple pages are submitted at once in a single multicall.  
> While a page is batched pending the hypercall, its corresponding 
> pte_lock is held.
> 
> This means that the code can end up holding multiple pte locks at once, 
> though it is guaranteed to never try to hold the same lock at once.  
> However, because these locks are in the same lock class, I get a 
> spurious warning from lockdep.  Is there some way I can get rid of this 
> warning?

How many locks at once?

