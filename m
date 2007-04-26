Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXDZGkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXDZGkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXDZGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:40:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40336 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933046AbXDZGki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:40:38 -0400
Date: Wed, 25 Apr 2007 23:40:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46303A98.9000605@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > The page cache has no problems supporting things with a block
> > size larger then page size.  Now the block device layer may not
> > have the code to do the scatter gather into small pages and it
> > may not handle buffer heads whose data is split between multiple
> > pages. 
> 
> Yeah, this patch is not really large blocksize support (which we normally
> think of as block size > page cache size).

No? It depends on how you define block size. This patch definitely allows
a set blocksize function call with a size larger than 4k.

> > I suspect what needs to be fixed is the page cache block device
> > interface so that we have helper functions that know how to stuff
> > a single block into several pages.
> 
> I am working now and again on some code to do this, it is a big job but
> I think it is the right way to do it. But it would take a long time to
> get stable and supported by filesystems...

Ummm... We already have a radix tree for this???? What more is needed? You 
just need to go through all filesystems and make them use extends.

