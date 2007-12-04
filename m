Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXLDL1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXLDL1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXLDL1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:27:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbXLDL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:27:10 -0500
Date: Tue, 4 Dec 2007 03:26:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rd: support XIP
Message-Id: <20071204032620.aaee039b.akpm@linux-foundation.org>
In-Reply-To: <20071204112100.GA20420@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de>
	<200712041054.51599.borntraeger@de.ibm.com>
	<20071204101009.GB9618@wotan.suse.de>
	<20071204112100.GA20420@wotan.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 12:21:00 +0100 Nick Piggin <npiggin@suse.de> wrote:

> +	 *
> +	 * Cannot support XIP and highmem, because our ->direct_access
> +	 * routine for XIP must return memory that is always addressable.
> +	 * If XIP was reworked to use pfns and kmap throughout, this
> +	 * restriction might be able to be lifted.
>  	 */
> +	gfp_flags = GFP_NOIO | __GFP_ZERO;
> +#ifndef CONFIG_BLK_DEV_XIP
> +	gfp_flags |= __GFP_HIGHMEM;
> +#endif

A dubious tradeoff?
