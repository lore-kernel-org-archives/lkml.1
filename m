Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZHFXGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZHFXGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZHFXGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:06:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbZHFXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:06:05 -0400
To: Jim Paradis <jparadis@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Dirty page tracking & on-the-fly memory mirroring
From: Andi Kleen <andi@firstfloor.org>
References: <4A7393D9.50807@redhat.com>
Date: Fri, 07 Aug 2009 01:06:01 +0200
In-Reply-To: <4A7393D9.50807@redhat.com> (Jim Paradis's message of "Fri, 31 Jul 2009 21:01:13 -0400")
Message-ID: <87hbwkiluu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Paradis <jparadis@redhat.com> writes:

> +#ifdef CONFIG_TRACK_DIRTY_PAGES
> +
> +#if PAGETABLE_LEVELS <= 3
> +static inline unsigned pud_index(unsigned long address)
> +{
> +    return 0;
> +}
> +#endif

Needing special code for different page table levels is a really bad
sign that it uses the wrong abstractions for page tables. It should be using
the standard page walk idioms or perhaps even walk_page_range() now

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
