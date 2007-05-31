Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXEaLOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXEaLOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbXEaLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:14:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:62605 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbXEaLOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sSFO+KUdj5QFt+J8X/nNKxc/rgCM/eeb0szwRgYoTDLhi0V7zgW7wtsXeoHOCnf/bh6eicNkUccxail1uBmcv2CqArlbUAZ+06sV4hfY3zr1xXf5AeBKkUMpyxVEeLLeA1DBe9x0WvdPhU0zH/vy8ouhE8rFUS54xNofG3Fy/Fg=
Message-ID: <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com>
Date: Thu, 31 May 2007 13:14:20 +0200
From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Cc: "device-mapper development" <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "David Chinner" <dgc@sgi.com>, "Andreas Dilger" <adilger@clusterfs.com>,
       "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <465DAC72.1010201@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18006.38689.818186.221707@notabene.brown>
	 <18010.12472.209452.148229@notabene.brown>
	 <20070528094358.GM25091@agk.fab.redhat.com>
	 <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
	 <20070529220500.GA6513@agk.fab.redhat.com>
	 <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
	 <465DAC72.1010201@cfl.rr.com>
X-Google-Sender-Auth: a0c4e06b3fe2178c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/30, Phillip Susi <psusi@cfl.rr.com>:
> Stefan Bader wrote:
> >
> > Since drive a supports barrier request we don't get -EOPNOTSUPP but
> > the request with block y might get written before block x since the
> > disk are independent. I guess the chances of this are quite low since
> > at some point a barrier request will also hit drive b but for the time
> > being it might be better to indicate -EOPNOTSUPP right from
> > device-mapper.
>
> The device mapper needs to ensure that ALL underlying devices get a
> barrier request when one comes down from above, even if it has to
> construct zero length barriers to send to most of them.
>

And somehow also make sure all of the barriers have been processed
before returning the barrier that came in. Plus it would have to queue
all mapping requests until the barrier is done (if strictly acting
according to barrier.txt).

But I am wondering a bit whether the requirements to barriers are
really that tight as described in Tejun's document (barrier request is
only started if everything before is safe, the barrier itself isn't
returned until it is safe, too, and all requests after the barrier
aren't started before the barrier is done). Is it really necessary to
defer any further requests until the barrier has been written to save
storage? Or would it be sufficient to guarantee that, if a barrier
request returns, everything up to (including the barrier) is on safe
storage?

Stefan
