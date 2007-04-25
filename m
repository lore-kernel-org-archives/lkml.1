Return-Path: <linux-kernel-owner+w=401wt.eu-S1031062AbXDYPXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031062AbXDYPXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031067AbXDYPXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:23:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48973 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031062AbXDYPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:23:12 -0400
Date: Wed, 25 Apr 2007 08:23:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-kernel@vger.kernel.org, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070425132807.GI19942@skynet.ie>
Message-ID: <Pine.LNX.4.64.0704250818030.24363@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070425132807.GI19942@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Mel Gorman wrote:

> HIGHMEM I can understand because I suppose the kmap() issue is still in
> there, but why 32 bit? Is this temporary or do you expect to see it
> fixed up later?

It could be fixed but I only tested with 64 bit. Jens's report shows that 
my skepticism was justified. 32 bit has only small memory and suffers from 
VM crappiness due to highmem, bouncing due to dma zones etc etc. Its a big 
mess that I would like to avoid dealing with for now. Lots of corner cases 
that need consideration. When we actually merge this then we can deal with 
all the cases. If some cases cannot be dealt with then the large blocksize 
support will not be available if another particular feature is 
enabled.

> >   How well Mel's antifrag/defrag methods address this issue still has to
> >   be seen.
> The grouping pages by mobility should hold up for ext2 and XFS because
> their page cache pages are reclaimable/movable and will get grouped with
> other pages that are reclaimable/movable. ramfs may be a problem if it was
> heavily used but lets see how things pan out.

Sounds good.
