Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZGINiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZGINiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbZGINh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:37:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZGINh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:37:56 -0400
Date: Thu, 9 Jul 2009 09:37:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and
	request
Message-ID: <20090709133746.GA21929@infradead.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A553DA4.4080408@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
> What's more disturbing to me is the different between RQ and BIO
> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
> positions.  Sadly it seems it's already too late to change that.  I
> personally an not a big fan of simple accessors or flags defined as
> bit positions.  They seem to obscure things without much benefit.

flags as bit positions generally only make sense if you use
test/set/clear_bit, otherwise they just confuse things.  And the
accessors are pretty annoying, especially in the block layer.  Trying to
find the places where a BIO flag has an actual effect is pretty painful
due to the mix of the different flags and the accessors.
