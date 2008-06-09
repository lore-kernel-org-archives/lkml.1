Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYFIIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYFIIcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYFIIcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:32:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYFIIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:32:14 -0400
Date: Mon, 9 Jun 2008 01:32:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: npiggin@suse.de
Cc: torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
Message-Id: <20080609013204.7c291b68.akpm@linux-foundation.org>
In-Reply-To: <20080605094826.128415000@nick.local0.net>
References: <20080605094300.295184000@nick.local0.net>
	<20080605094826.128415000@nick.local0.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 19:43:07 +1000 npiggin@suse.de wrote:

> Implement lockless get_user_pages_fast for powerpc. Page table existence is
> guaranteed with RCU, and speculative page references are used to take a
> reference to the pages without having a prior existence guarantee on them.
> 

arch/powerpc/mm/gup.c: In function `get_user_pages_fast':
arch/powerpc/mm/gup.c:156: error: `SLICE_LOW_TOP' undeclared (first use in this function)
arch/powerpc/mm/gup.c:156: error: (Each undeclared identifier is reported only once
arch/powerpc/mm/gup.c:156: error: for each function it appears in.)
arch/powerpc/mm/gup.c:178: error: implicit declaration of function `get_slice_psize'
arch/powerpc/mm/gup.c:178: error: `mmu_huge_psize' undeclared (first use in this function)
arch/powerpc/mm/gup.c:182: error: implicit declaration of function `huge_pte_offset'
arch/powerpc/mm/gup.c:182: warning: assignment makes pointer from integer without a cast

with

http://userweb.kernel.org/~akpm/config-g5.txt

I don't immediately know why - adding asm/page.h to gup.c doesn't help.
I'm suspecting a recursive include problem somewhere.

I'll drop it, sorry - too much other stuff to fix over here.
