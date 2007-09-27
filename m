Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbXI0LMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbXI0LMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXI0LMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:12:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1482 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbXI0LMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:12:16 -0400
Date: Thu, 27 Sep 2007 13:13:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 4] Change prototype for bi_end_io
Message-ID: <20070927111348.GO5243@kernel.dk>
References: <20070927171111.3251.patches@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27 2007, NeilBrown wrote:
> Hi Jens,
>  here are a few more patches from my set that makes various changes to bio
>  submission and handling.
> 
>  These change the ->bi_end_io prototype so that
>    1/ no 'size' is passed
>    2/ there is no return value.
> 
>  The 'size' is not really of interest to any bi_end_io handler in existance. 
>  It is really only an internal detail to the "request" handling in ll_rw_blk
>  and lower levels.
>  The return value is completely unused.
> 
>  After these patches, ->bi_end_io is only ever called once per bio.
> 
>  Note that the last patch makes lots and lots of simple changes.  I
>  think I have found all the right places, but any recently added
>  device drivers might still be using the old bi_end_io prototype.
>  I'll grep again after these patches are in your tree.

Thanks Neil, this looks good! We get rid of the ability to do partial
completions. It's a nice concept in theory, but as you noted nobody uses
it. And most drivers only do real full completions anyway, so there's
little interest in supporting it.

>  That patches are against linux-block as of an hour ago.

I had to shoe horn the patches a bit, they really should be on the
block-2.6.24 branch. But that's ok, even if you had done them against
that branch, I had to redo the barrier branch and the sglist stuff
anyway.

-- 
Jens Axboe

