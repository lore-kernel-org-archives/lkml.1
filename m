Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbZANPLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbZANPLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZANPLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:11:34 -0500
Received: from netgear.net.ru ([195.178.208.66]:49715 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760179AbZANPLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:11:33 -0500
Date: Wed, 14 Jan 2009 18:11:32 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net
Subject: Re: [3/7] dst: export node.
Message-ID: <20090114151132.GB6419@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net> <1231887933-17843-2-git-send-email-zbr@ioremap.net> <1231887933-17843-3-git-send-email-zbr@ioremap.net> <1231887933-17843-4-git-send-email-zbr@ioremap.net> <20090114145204.GE30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114145204.GE30821@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:52:05PM +0100, Jens Axboe (jens.axboe@oracle.com) wrote:
> On Wed, Jan 14 2009, Evgeniy Polyakov wrote:
> > +	bio = bio_alloc_bioset(GFP_KERNEL,
> > +			PAGE_ALIGN(cmd->size) >> PAGE_SHIFT,
> > +			dst_bio_set);
> > +	if (!bio)
> > +		goto err_out_exit;
> > +	bio->bi_private = NULL;
> > +
> > +	priv = mempool_alloc(st->node->trans_pool, GFP_KERNEL);
> > +	if (!priv)
> > +		goto err_out_free;
> 
> Did you know that you can now set the appropriate extra size for your
> private bio set, thus getting rid of this extra 'priv' allocation and
> free for each bio?
> 
> See bioset_create().

Yes, that's a good idea, I will update the patch with that changes in
mind. Thanks Jens.

-- 
	Evgeniy Polyakov
