Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXJ3X2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXJ3X2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXJ3X20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:28:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbXJ3X2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:28:25 -0400
Date: Tue, 30 Oct 2007 23:26:17 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Re: dm: bounce_pfn limit added
Message-ID: <20071030232617.GJ10006@agk.fab.redhat.com>
Mail-Followup-To: Vasily Averin <vvs@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
	Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>
References: <47257E4B.4080904@sw.ru> <20071030131138.3ba59731.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030131138.3ba59731.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 01:11:38PM -0700, Andrew Morton wrote:
> On Mon, 29 Oct 2007 09:31:39 +0300
> Vasily Averin <vvs@sw.ru> wrote:
> > Device mapper uses its own bounce_pfn that may differ from one on underlying
> > device. In that way dm can build incorrect requests that contain sg elements
> > greater than underlying device is able to handle.
> > This is the cause of slab corruption in i2o layer, occurred on i386 arch when
> > very long direct IO requests are addressed to dm-over-i2o device.

Interesting.  When this patch was originally proposed a couple of years ago, we
did this instead:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=daef265f1590cf3e6de989d074041a280c82d58b;hp=00d6da9b4d6707b808481372537adb0fb38f99b3

) DM doesn't need to bounce bio's on its own, but the block layer defaults
) to that in blk_queue_make_request(). The lower level drivers should
) bounce ios themselves, that is what they need to do if not layered below
) dm anyways.

Alasdair
-- 
agk@redhat.com
