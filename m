Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbZCPNb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbZCPNb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZCPNbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:31:15 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:41891 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbZCPNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:31:14 -0400
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
 data
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, npiggin@suse.de,
       linux-mm@kvack.org
In-Reply-To: <20090316102253.GB9510@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
	 <1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
	 <20090316102253.GB9510@infradead.org>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 09:30:14 -0400
Message-Id: <1237210214.30224.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49BE546B.01D2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 06:22 -0400, Christoph Hellwig wrote:
> On Thu, Mar 12, 2009 at 03:33:43PM +0100, Jens Axboe wrote:
> > +static void bdi_kupdated(struct backing_dev_info *bdi)
> > +{
> > +	long nr_to_write;
> > +	struct writeback_control wbc = {
> > +		.bdi		= bdi,
> > +		.sync_mode	= WB_SYNC_NONE,
> > +		.nr_to_write	= 0,
> > +		.for_kupdate	= 1,
> > +		.range_cyclic	= 1,
> > +	};
> > +
> > +	sync_supers();
> 
> Not directly related to your patch, but can someone explain WTF
> sync_supers is doing here or in the old kupdated?  We're writing back
> dirty pages from the VM, and for some reason we try to also write back
> superblocks.   This doesn't really make any sense.

Some of our poor filesystem cousins don't write the super until kupdate
kicks them (see ext2_write_super).  kupdate has always been the periodic
FS thread of last resort.

-chris




