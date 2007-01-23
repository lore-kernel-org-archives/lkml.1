Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbXAWOiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbXAWOiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXAWOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:38:14 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:45632 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbXAWOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:38:12 -0500
Date: Tue, 23 Jan 2007 16:37:58 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
       Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Message-ID: <20070123143758.GA3660@rhun.ibm.com>
References: <45B3F578.7090109@panasas.com> <20070122052938.GJ3531@rhun.ibm.com> <45B6115C.2010601@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B6115C.2010601@panasas.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 03:45:00PM +0200, Benny Halevy wrote:

> >> +static inline int dma_uni_dir(enum dma_data_direction dir)
> >> +{
> >> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_FROM_DEVICE) ||
> >> +	       (dir == DMA_NONE);
> >> +}
> > 
> > While this doesn't look very useful. Why is "DMA_NONE" a uni-dir? I
> > suggest replacing this with an open coded (dir != DMA_BIDIRECTIONAL).
> 
> The idea was to be resilient to invalid values. (dir != DMA_BIDIRECTIONAL)
> is fine of course, but I'd add a BUG_ON such as (dir < 0 || dir >
> DMA_BIDIRECTIONAL)

If DMA_NONE isn't actually allowed here, you can use valid_dma_direction().

Cheers,
Muli
