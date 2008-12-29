Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYL2XSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYL2XSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYL2XSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:18:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbYL2XSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:18:13 -0500
Date: Mon, 29 Dec 2008 15:17:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-Id: <20081229151731.2a2c5a02.akpm@linux-foundation.org>
In-Reply-To: <20081218211543.GB10681@wotan.suse.de>
References: <20081218211543.GB10681@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 22:15:43 +0100
Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> I've debugged a problem where i386+pae systems with more than a few CPUs
> blow up at boot in the kmap_atomic code.

ping?

> The problem is that the kmap_atomic pte pages all need to be contiguous
> memory because the pte is calculated via the first kmap pte page + an
> offset (so as not to have to walk the page tables every time).
> 
> The fixmap setup code crudely allocates contiguous pte pages, which is fine,
> but if it finds an already populated pmd entry, then it will not switch it
> to a new, contiguous pte page. So the early fixmap introduces a discontig
> page table right in the middle of the kmap atomic fixmaps.
> 
> Commenting out the eaarly fixmap setup in head_32.S gets everything working
> properly. What would be the best way to fix this? Could we put the early
> fixmap page table in initdata, and then have the fixmap setup proper first
> clear its corresponding pmd entry?

How come users/testers aren't reporting this?
