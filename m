Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbZHZMGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbZHZMGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZHZMGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:06:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368AbZHZMGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:06:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Date: Wed, 26 Aug 2009 21:36:46 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090820205616.GA5503@lst.de> <200908252341.38356.rusty@rustcorp.com.au> <20090825141608.GA32658@lst.de>
In-Reply-To: <20090825141608.GA32658@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908262136.46570.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 11:46:08 pm Christoph Hellwig wrote:
> On Tue, Aug 25, 2009 at 11:41:37PM +0930, Rusty Russell wrote:
> > On Fri, 21 Aug 2009 06:26:16 am Christoph Hellwig wrote:
> > > Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
> > > means it does not allow filesystems to use barriers.  But the typical use
> > > case for virtio-blk is to use a backed that uses synchronous I/O
> > 
> > Really?  Does qemu open with O_SYNC?
> > 
> > I'm definitely no block expert, but this seems strange...
> > Rusty.
> 
> Qemu can open it various ways, but the only one that is fully safe
> is O_SYNC (cache=writethrough).

(Rusty goes away and reads the qemu man page).

	By default, if no explicit caching is specified for a qcow2 disk image,
	cache=writeback will be used.

Are you claiming qcow2 is unusual?  I can believe snapshot is less common,
though I use it all the time.

You'd normally have to add a feature for something like this.  I don't
think this is different.

Sorry,
Rusty.
