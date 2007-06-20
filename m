Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbXFTV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbXFTV3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXFTV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:29:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40395 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752219AbXFTV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:29:22 -0400
Date: Wed, 20 Jun 2007 14:29:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andreas Dilger <adilger@clusterfs.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [34/37] Large blocksize support in ramfs
In-Reply-To: <20070620205002.GH5181@schatzie.adilger.int>
Message-ID: <Pine.LNX.4.64.0706201427270.31425@schroedinger.engr.sgi.com>
References: <20070620182907.506775016@sgi.com> <20070620183013.967063205@sgi.com>
 <20070620205002.GH5181@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Andreas Dilger wrote:

> On Jun 20, 2007  11:29 -0700, clameter@sgi.com wrote:
> > If you apply this patch and then you can f.e. try this:
> > 
> > 	mount -tramfs -o10 none /media
> 
> > @@ -164,10 +165,15 @@ static int ramfs_fill_super(struct super
> > +	if (options && *options)
> > +		order = simple_strtoul(options, NULL, 10);
> 
> This is probably a bad name for a mount option.  What about "order=10"?
> Otherwise you prevent any other option from being used in the future.

I tried to make it as simple as possible. The patch is primarily useful as 
a debugging aid since it eliminates the lower layers from the game. I 
think ramfs should be left as is sine it is intended as a minimal 
implementation that should stay simpl.

If we really want such an option for good then it may best be added to 
shmem or ramdisk drivers?

