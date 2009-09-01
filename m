Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZIAXwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZIAXwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZIAXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:52:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42847 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZIAXw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:52:29 -0400
Date: Wed, 2 Sep 2009 00:52:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
Message-ID: <20090901235218.GC1321@shareable.org>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-9-git-send-email-jens.axboe@oracle.com> <1251830335.8502.17.camel@laptop> <20090901184455.GA27294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901184455.GA27294@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Sep 01, 2009 at 08:38:55PM +0200, Peter Zijlstra wrote:
> > Do we really need a tunable for this?
> 
> It will make increasing it in the field a lot easier.  And having deal
> with really large systems I have the fear that there are I/O topologies
> outhere for which every "reasonable" value is too low.
>
> > I guess we need a limit to avoid it writing out everything, but can't we
> > have something automagic?
> 
> Some automatic adjustment would be nice.  But finding the right auto
> tuning will be an interesting exercise.

I have embedded systems with 32MB RAM and no MMU, where I deliberately
make the equivalent of max_writeback_pages *smaller* to limit the
number of dirty pages causing fragmentation and preventing allocation
of high-order pages...  Write performance is less important than being
able to allocate contiguous memory for reads.

They are still using 2.4 kernels, but the principle still applies.
maybe even more on 2.6 which is more prone to fragmentation on small
no-MMU devices.

-- Jamie
