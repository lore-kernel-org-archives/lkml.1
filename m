Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbXB1MR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbXB1MR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXB1MR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:17:26 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57940 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbXB1MRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:17:25 -0500
Date: Wed, 28 Feb 2007 13:16:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: Fix soft lockup with iSeries viocd driver
Message-ID: <20070228121643.GX3733@kernel.dk>
References: <20070227055529.GO4575@bakeyournoodle.com> <20070227143334.GB4731@kernel.dk> <20070227234234.GQ4575@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227234234.GQ4575@bakeyournoodle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28 2007, Tony Breeds wrote:
> On Tue, Feb 27, 2007 at 03:33:34PM +0100, Jens Axboe wrote:
> 
> > It looks ok (better than end_request()), though it would still be nice
> > to properly end requests. See the recent thread on the lguest block
> > driver.
> 
> Hi Jens,
> 	I read through the lguest thread and came up with the patch
> below, I hope I understood correctly.  We still need to do the check to
> make sure we ask for at least one sector to be processed in
> end_that_request_first(), as the request that triggers the lockup here
> (an sg_io ioctl in this case), has both req->hard_nr_sectors and
> req->hard_cur_sectors = 0.

Yep that looks better.

> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Fix soft lockup with iSeries viocd driver, caused by eventually calling
> end_that_request_first() with nr_bytes 0.
> 
> The lockup is triggered by hald, interrogating the device.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

