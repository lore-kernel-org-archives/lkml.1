Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXDJL2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXDJL2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXDJL2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:28:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:29801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbXDJL2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FD3KoD6dQoiSsswBb5Az6nQFzU7db0GMXON8F7/p3oRwG/Iyo9TjAG5QicBOCoR1mqAIGUFe6/L552znDFO1M/FVTSNq0naGKTiKpWI2pELcDRMe0JRFGcv8IUVr27gyLJeUKLici/Z+iiVFxS3FRNmE1jpXcy1WoIWplkEi87E=
Message-ID: <84144f020704100428r6e35e34cued8758c94728a6a0@mail.gmail.com>
Date: Tue, 10 Apr 2007 14:28:05 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH 7/8] lguest: the block driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Andi Kleen" <ak@muc.de>
In-Reply-To: <1176203528.26372.40.camel@localhost.localdomain>
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
X-Google-Sender-Auth: 5d2598399933eaae
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 4/10/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> +/* Jens gave me this nice helper to end all chunks of a request. */
> +static void end_entire_request(struct request *req, int uptodate)
> +{
> +       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> +               BUG();
> +       add_disk_randomness(req->rq_disk);
> +       blkdev_dequeue_request(req);
> +       end_that_request_last(req, uptodate);
> +}

Perhaps we should move this to generic code (i.e. block/ll_rw_blk.c)?
