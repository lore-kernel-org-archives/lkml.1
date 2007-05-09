Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXEIKW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXEIKW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXEIKWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:22:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:3836 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbXEIKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kaUtGYyn1Tm8/XfTcjN8/7XvUQTxdmQ4BD9iOZuc/cC9rON83Zg0n5LmjvXYh+3XpaTLGIz1v4v7ItT5NoU1StulGgWayCcoPODqDsqNzl5M3xuE4401lMLEeiH55nS+sxc3/JD+tPledBW4jv9/w0xM96kkpjtaXvwPQavqHo4=
Message-ID: <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
Date: Wed, 9 May 2007 13:22:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch 8/9] lguest: the block driver
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, jens.axboe@oracle.com,
       "Rene Herman" <rene.herman@gmail.com>
In-Reply-To: <200705090951.l499pdsc020409@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705090951.l499pdsc020409@shell0.pdx.osdl.net>
X-Google-Sender-Auth: ebab1ffbacaf86b5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> +/* Jens gave me this nice helper to end all chunks of a request. */
> +static void end_entire_request(struct request *req, int uptodate)
> +{
> +       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> +               BUG();
> +       add_disk_randomness(req->rq_disk);
> +       blkdev_dequeue_request(req);
> +       end_that_request_last(req, uptodate);
> +}

Again, I would prefer this went straight into block/ll_rw_blk.c. Rene
and I am using something similar in the new Mitsumi driver although
one of us has a bug already, we're using req->nr_sectors for this...
