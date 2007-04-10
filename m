Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXDJLgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXDJLgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXDJLgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:36:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37279 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbXDJLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=biwl8SAOSRlPbAmUShoHUGqmwskpF5nWewX9VWHTAXS80O8+SB+OrbcOT4vLlF2WpnTmwviXN9i/VvVGpseFqCFfMRv/MRTO2zHLC57p3spBA9z5HjtM+HanmVqGIfMIyNTYm5MDlZdNTyzygUyVI3BC1rCGTiO08LS+yRZK584=
Message-ID: <84144f020704100436y3405f104x8345c72556d961e9@mail.gmail.com>
Date: Tue, 10 Apr 2007 14:36:05 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH 7/8] lguest: the block driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Andi Kleen" <ak@muc.de>, jens.axboe@oracle.com
In-Reply-To: <84144f020704100428r6e35e34cued8758c94728a6a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203130.26372.23.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
	 <1176203231.26372.27.camel@localhost.localdomain>
	 <1176203285.26372.29.camel@localhost.localdomain>
	 <1176203333.26372.31.camel@localhost.localdomain>
	 <1176203475.26372.37.camel@localhost.localdomain>
	 <1176203528.26372.40.camel@localhost.localdomain>
	 <84144f020704100428r6e35e34cued8758c94728a6a0@mail.gmail.com>
X-Google-Sender-Auth: bd99ede8d346d4c4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > +/* Jens gave me this nice helper to end all chunks of a request. */
> > +static void end_entire_request(struct request *req, int uptodate)
> > +{
> > +       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> > +               BUG();
> > +       add_disk_randomness(req->rq_disk);
> > +       blkdev_dequeue_request(req);
> > +       end_that_request_last(req, uptodate);
> > +}

On 4/10/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Perhaps we should move this to generic code (i.e. block/ll_rw_blk.c)?

Uhm, I am bit confused now. Why don't you just use end_request() here?
