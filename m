Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYJXHpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYJXHpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYJXHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:44:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17360 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYJXHov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wTuYrrgYv3E+e3CKp16XywIubW/m41wz7rzEjH5e8jUrwN+Dp77a4yD2DVuZrGGan+
         Vfuc5p3Wi8RG2Sq1D2HjLI5C7TbteypHRUgzLNNlhMltCKXJhQztp7zEJWjiJcI8G9/T
         CY3yOyyrtS0sbpy0ad36N6cIF+LQ3AbHB/0V0=
Message-ID: <807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
Date: Fri, 24 Oct 2008 13:14:50 +0530
From: "Nikanth K" <nikanth@gmail.com>
To: "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 10/13] dm: add core functions for request-based dm
Cc: jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, "Nikanth Karthikesan" <knikanth@suse.de>
In-Reply-To: <20080912.104612.115643090.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	 <20080912.104612.115643090.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
<snip>

> +static int dm_make_request(struct request_queue *q, struct bio *bio)
> +{
> +       struct mapped_device *md = (struct mapped_device *)q->queuedata;
> +
> +       if (unlikely(bio_barrier(bio))) {
> +               bio_endio(bio, -EOPNOTSUPP);
> +               return 0;
> +       }
> +
<snip>

Why not add barrier support in the beginning itself, so that targets
can be developed with barriers in mind? At least can we make the target
to return error, instead of the core?

Thanks
Nikanth Karthikesan
