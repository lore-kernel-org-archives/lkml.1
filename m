Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXKAABE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXKAABE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXKAAAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:00:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbXKAAAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:00:53 -0400
Date: Thu, 1 Nov 2007 00:00:07 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, hare@suse.de, nfbrown@novell.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, stable@kernel.org, devel@openvz.org
Subject: Re: [dm-devel] Re: dm: bounce_pfn limit added
Message-ID: <20071101000007.GO10006@agk.fab.redhat.com>
Mail-Followup-To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com,
	hare@suse.de, nfbrown@novell.com, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, akpm@linux-foundation.org, stable@kernel.org,
	devel@openvz.org
References: <20071031020133.GL10006@agk.fab.redhat.com> <47282B1D.8030501@sw.ru> <47283061.8080501@suse.de> <20071031.170016.39152331.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031.170016.39152331.k-ueda@ct.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 05:00:16PM -0500, Kiyoshi Ueda wrote:
> How about the case that other dm device is stacked on the dm device?
> (e.g. dm-linear over dm-multipath over i2o with bounce_pfn=64GB, and
>       the multipath table is changed to i2o with bounce_pfn=1GB.)
 
Let's not broaden the problem out in that direction yet - that's a
known flaw in the way all these device restrictions are handled.
(Which would, it happens, also be resolved by the dm architectural
changes I'm contemplating.)

Yes, we could certainly take this patch - it won't do much harm (just
hit performance in some configurations).  But I am not yet convinced
that there isn't some further underlying problem with the way the
responsibility for this bouncing is divided up between the various
layers: I still don't feel I completely understand this problem yet.

- How does that bio_alloc() in blk_queue_bounce() guarantee never to
lead a deadlock (in the device-mapper context)?
- Are some functions failing to take account of the hw_segments
(and perhaps other) restrictions?
- Are things actually simpler if the bouncing is dealt with just once 
prior to entering the device stack (even though that may involve
bouncing some data that does not need it) or is it better to endeavour
to keep the bouncing as close to the final layer as possible?

Alasdair
-- 
agk@redhat.com
