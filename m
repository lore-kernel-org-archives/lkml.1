Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYBIK40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYBIK40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYBIK4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:56:19 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:3172 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYBIK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:56:18 -0500
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080209103728.GA29375@elte.hu>
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost>  <20080209103728.GA29375@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 09 Feb 2008 11:56:14 +0100
Message-Id: <1202554574.8936.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 11:37 +0100, Ingo Molnar wrote:
> i think the worst is over already and i'm reasonably sure that there are 
> no more bugs in it - this _is_ a 1:1 patch after all, so in theory the 
> worst side-effect should be build breakages due to include file 
> spaghetti. The window for this particular breakage was just 256 commits, 
> that's OK i think.

Except for the breakage of all nommu architectures .. they need the
pgtable_t as well due to the pte_fn_t type.

> If you want less stress next time around you might want to consider 
> pushing such patches via individual architectures, so that it can all be 
> shaken out (and such build bugs are found quickly) and pushed via the 
> architecture trees. (Even such a patch that changes the number of 
> cross-arch function arguments and introduces a new type can be 
> architectured in a way to make it per arch.)

I'll try that with the __pte_free_tlb macro to inline conversion patch.
This one is really driving me nuts, the dependencies of the macros in
asm/pgalloc, asm/tlb.h and asm-generic/tlb.h for the different archs are
pure evil.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


