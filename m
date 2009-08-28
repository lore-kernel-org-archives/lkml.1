Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbZH1BPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbZH1BPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZH1BPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:15:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZH1BPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:15:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Date: Fri, 28 Aug 2009 10:45:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Christoph Hellwig <hch@lst.de>, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090820205616.GA5503@lst.de> <200908272013.50839.rusty@rustcorp.com.au> <4A966833.2090404@redhat.com>
In-Reply-To: <4A966833.2090404@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908281045.27333.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 08:34:19 pm Avi Kivity wrote:
> There are two possible semantics to cache=writeback:
> 
> - simulate a drive with a huge write cache; use fsync() to implement 
> barriers
> - tell the host that we aren't interested in data integrity, lie to the 
> guest to get best performance

Why lie to the guest?  Just say we're not ordered, and don't support barriers.
Gets even *better* performance since it won't drain the queues.

Maybe you're thinking of full virtualization where we guest ignorance is
bliss.  But lying always gets us in trouble later on when other cases come
up.

> The second semantic is not useful for production, but is very useful for 
> testing out things where you aren't worries about host crashes and 
> you're usually rebooting the guest very often (you can't rely on guest 
> caches, so you want the host to cache).

This is not the ideal world; people will do things for performance "in
production".

Cheers,
Rusty.
