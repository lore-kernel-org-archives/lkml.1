Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXBYMHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXBYMHJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXBYMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:07:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbXBYMHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:07:08 -0500
Date: Sun, 25 Feb 2007 04:06:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, linux-mm@kvack.org
Subject: Re: [patch 3/3] mm: fix PageUptodate memorder
Message-Id: <20070225040657.eb4fc159.akpm@linux-foundation.org>
In-Reply-To: <20070215051851.7443.65811.sendpatchset@linux.site>
References: <20070215051822.7443.30110.sendpatchset@linux.site>
	<20070215051851.7443.65811.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What an unpleasing patchset.  I really really hope we really have a bug in
there, and that all this crap isn't pointless uglification.

We _do_ need a flush_dcaceh_page() in all cases which you're concerned
about.  Perhaps we should stick the appropriate barriers in there.

> On Thu, 15 Feb 2007 08:31:31 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> +static inline void SetNewPageUptodate(struct page *page)
> +{
> +	/*
> +	 * S390 sets page dirty bit on IO operations, which is why it is
> +	 * cleared in SetPageUptodate. This is not an issue for newly
> +	 * allocated pages that are brought uptodate by zeroing memory.
> +	 */
> +	smp_wmb();
> +	__set_bit(PG_uptodate, &(page)->flags);
> +}

__SetPageUptodate() might be more conventional.

Boy we'd better get the callers of this little handgrenade right.
