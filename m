Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbZCPKXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbZCPKXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbZCPKW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:22:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbZCPKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:22:54 -0400
Date: Mon, 16 Mar 2009 06:22:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090316102253.GB9510@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:33:43PM +0100, Jens Axboe wrote:
> +static void bdi_kupdated(struct backing_dev_info *bdi)
> +{
> +	long nr_to_write;
> +	struct writeback_control wbc = {
> +		.bdi		= bdi,
> +		.sync_mode	= WB_SYNC_NONE,
> +		.nr_to_write	= 0,
> +		.for_kupdate	= 1,
> +		.range_cyclic	= 1,
> +	};
> +
> +	sync_supers();

Not directly related to your patch, but can someone explain WTF
sync_supers is doing here or in the old kupdated?  We're writing back
dirty pages from the VM, and for some reason we try to also write back
superblocks.   This doesn't really make any sense.

