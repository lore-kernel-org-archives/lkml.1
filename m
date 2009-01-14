Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbZANOxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbZANOxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZANOxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:53:25 -0500
Received: from brick.kernel.dk ([93.163.65.50]:16593 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZANOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:53:25 -0500
Date: Wed, 14 Jan 2009 15:52:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [3/7] dst: export node.
Message-ID: <20090114145204.GE30821@kernel.dk>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231887933-17843-4-git-send-email-zbr@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2009, Evgeniy Polyakov wrote:
> +	bio = bio_alloc_bioset(GFP_KERNEL,
> +			PAGE_ALIGN(cmd->size) >> PAGE_SHIFT,
> +			dst_bio_set);
> +	if (!bio)
> +		goto err_out_exit;
> +	bio->bi_private = NULL;
> +
> +	priv = mempool_alloc(st->node->trans_pool, GFP_KERNEL);
> +	if (!priv)
> +		goto err_out_free;

Did you know that you can now set the appropriate extra size for your
private bio set, thus getting rid of this extra 'priv' allocation and
free for each bio?

See bioset_create().

-- 
Jens Axboe

