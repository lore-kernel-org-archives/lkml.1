Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXJaCCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXJaCCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXJaCCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:02:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbXJaCCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:02:45 -0400
Date: Wed, 31 Oct 2007 02:01:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Re: dm: bounce_pfn limit added
Message-ID: <20071031020133.GL10006@agk.fab.redhat.com>
Mail-Followup-To: Vasily Averin <vvs@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
	Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>
References: <47257E4B.4080904@sw.ru> <20071030131138.3ba59731.akpm@linux-foundation.org> <20071030232617.GJ10006@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030232617.GJ10006@agk.fab.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 11:26:17PM +0000, Alasdair G Kergon wrote:
> ) DM doesn't need to bounce bio's on its own, but the block layer defaults
> ) to that in blk_queue_make_request(). The lower level drivers should
> ) bounce ios themselves, that is what they need to do if not layered below
> ) dm anyways.

So currently we treat bounce_pfn as a property that does not need to be
propagated through the stack.

But is that the right approach?
- Is there a blk_queue_bounce() missing either from dm or elsewhere?
  (And BTW can the bio_alloc() that lurks within lead to deadlock?)

Firstly, what's going wrong?
- What is the dm table you are using?  (output of 'dmsetup table')
  - Which dm targets and with how many underlying devices?
- Which underlying driver?
- Is this direct I/O to the block device from userspace, or via some
filesystem or what?

Presumably you've shown the problem goes away when the dm device is
removed from the stack.
What if you swap in alternative dm targets, e.g. if it's linear,
try multipath (round-robin, one path)?
 
Alasdair
-- 
agk@redhat.com
