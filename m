Return-Path: <linux-kernel-owner+w=401wt.eu-S965322AbXCLI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbXCLI1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCLI1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:27:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40421 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965322AbXCLI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:27:24 -0400
Date: Mon, 12 Mar 2007 08:27:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, devel@openvz.org
Subject: Re: [PATCH 1/2] mm: move common segment checks to separate helper function (v6)
Message-ID: <20070312082719.GC14831@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>, devel@openvz.org
References: <878xe2rj0e.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878xe2rj0e.fsf@sw.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 10:57:53AM +0300, Dmitriy Monakhov wrote:
> +/*
> + * Performs necessary checks before doing a write
> + *
> + * Adjust number of segments and amount of bytes to write.
> + * Returns appropriate error code that caller should return or
> + * zero in case that write should be allowed.
> + */
> +inline int generic_segment_checks(const struct iovec *iov,
> +			unsigned long *nr_segs, size_t *count,
> +			unsigned long access_flags)

Why isn't this static?  Also I doubt that we want to inline this function.
