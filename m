Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXAVSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXAVSR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbXAVSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:17:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:42017 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbXAVSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:17:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=urIg1OxQ2NXgMJjvNm0xTzRU3TJ7DOwjnsQAbjUi1VTkUwbrqY4G/fFMiOlaEN/zIbVMBV72kUfmsRRNEOGwxjO4LxlulxiVc3VGQ6g7EAJAYjiwtrtlZRRBqo6sjYN6bKvr2H5wrJUyA1v1TBCq+JrWLCl1mQap+hsDVMx5PNI=
Message-ID: <311601c90701221017v65866b6dm565d09bc756bdf3b@mail.gmail.com>
Date: Mon, 22 Jan 2007 11:17:51 -0700
From: "Eric D. Mudama" <edmudama@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: SATA exceptions with 2.6.20-rc5
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Robert Hancock" <hancockr@shaw.ca>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       linux-kernel@vger.kernel.org, htejun@gmail.com
In-Reply-To: <45AC2F99.3040209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.hif5u4ZXua+b0mVNaWEcItWv9i0@ifi.uio.no>
	 <45AAC039.1020808@shaw.ca> <45AAC95B.1020708@garzik.org>
	 <45AAE635.8090308@shaw.ca> <20070115025319.GC4516@kernel.dk>
	 <45AB84D8.3020507@garzik.org> <20070116002336.GB4067@kernel.dk>
	 <45AC2F99.3040209@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jens Axboe wrote:
> > On Mon, Jan 15 2007, Jeff Garzik wrote:
> >> Jens Axboe wrote:
> >>> I'd be surprised if the device would not obey the 7 second timeout rule
> >>> that seems to be set in stone and not allow more dirty in-drive cache
> >>> than it could flush out in approximately that time.
> >> AFAIK Windows flush-cache timeout is 30 seconds, not 7 as with other
> >> commands...
> >
> > Ok, 7 seconds for FLUSH_CACHE would have been nice for us too though, as
> > it would pretty much guarentee lower latencies for random writes and
> > write back caching. The concern is the barrier code, of course. I guess
> > I should do some timings on potential worst case patterns some day. Alan
> > may have done that sometime in the past, iirc.
>
> FWIW:  According to the drive guys (Eric M, among others), FLUSH CACHE
> will "probably" be under 30 seconds, but pathological cases might even
> extend beyond that.
>
> Definitely more than 7 seconds in less-than-pathological cases,
> unfortunately...

The mentioned Maxtor model (6Yxxx) isn't susceptible to the
large-buffer long completion times, due to architectural differences
and availability of only small buffers.  Any "real" long-completion
flush on this device would, I believe, involve damage to the disk that
hinders the ability to seek, settle, or write.  (e.g. 30-second
flushes are easy to hit if you mount the disk on a shaker-table with
sufficient amplitude)

Later in the thread I think people have pretty much isolated it as not
the disk's problem, but just wanted to point this out.

I assume that large enough customers can buy enterprise-type command
completion ("all commands within X seconds") from most any disk
vendor.  However, these firmwares require much smarter or more active
drivers or block layers, to handle the higher error rate when the data
on the device is valid, but it will take longer than allowed by the
arbitrary enterprise rules.  Most customers who are buying this many
devices have software engineers customizing the drivers or disk
management applications to handle this differing behavior.

--eric
