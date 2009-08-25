Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZHYOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZHYOQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZHYOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:16:24 -0400
Received: from verein.lst.de ([213.95.11.210]:45777 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZHYOQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:16:23 -0400
Date: Tue, 25 Aug 2009 16:16:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Message-ID: <20090825141608.GA32658@lst.de>
References: <20090820205616.GA5503@lst.de> <200908252341.38356.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908252341.38356.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 11:41:37PM +0930, Rusty Russell wrote:
> On Fri, 21 Aug 2009 06:26:16 am Christoph Hellwig wrote:
> > Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
> > means it does not allow filesystems to use barriers.  But the typical use
> > case for virtio-blk is to use a backed that uses synchronous I/O
> 
> Really?  Does qemu open with O_SYNC?
> 
> I'm definitely no block expert, but this seems strange...
> Rusty.

Qemu can open it various ways, but the only one that is fully safe
is O_SYNC (cache=writethrough).  The O_DIRECT (cache=none) option is also
fully safe with the above patch under some limited circumstances 
(disk write caches off and using a host device or fully allocated file).

Fixing the cache=writeback option and the majority case for cache=none
requires implementing a cache flush command, and for the latter one
also fixes to the host kernel I'm working on.  You will get another
patch to implement the proper cache controls in virtio-blk for me in
a couple of days, too.
