Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbXFAHRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbXFAHRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbXFAHR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:17:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:10437 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbXFAHR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CkNcnG/a9jUYjn/tQaZmtwRyz6/b2HFq+8PwJJGUskiUslo2G/w+kaoiXELa5H0Kdu4kFvnr+VY0D+UyfGKTnyI2LaIFTAigPT1R50CwBxa/E5+wCm27haxPHeH/DzGs/UgehNp4gt4ICDMhT2CV+r55g2HWp7QGmKNvmpqdggk=
Message-ID: <465FC7B1.3060309@gmail.com>
Date: Fri, 01 Jun 2007 16:16:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: david@lang.hm
CC: Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>,
       ric@emc.com
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown>  <18010.12472.209452.148229@notabene.brown>  <20070528094358.GM25091@agk.fab.redhat.com>  <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>  <20070529220500.GA6513@agk.fab.redhat.com>  <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>  <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc'ing Ric Wheeler for storage array thingie.  Hi, whole thread is at
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/3344 ]

Hello,

david@lang.hm wrote:
> but when you consider the self-contained disk arrays it's an entirely
> different story. you can easily have a few gig of cache and a complete
> OS pretending to be a single drive as far as you are concerned.
> 
> and the price of such devices is plummeting (in large part thanks to
> Linux moving into this space), you can now readily buy a 10TB array for
> $10k that looks like a single drive.

Don't those thingies usually have NV cache or backed by battery such
that ORDERED_DRAIN is enough?

The problem is that the interface between the host and a storage device
(ATA or SCSI) is not built to communicate that kind of information
(grouped flush, relaxed ordering...).  I think battery backed
ORDERED_DRAIN combined with fine-grained host queue flush would be
pretty good.  It doesn't require some fancy new interface which isn't
gonna be used widely anyway and can achieve most of performance gain if
the storage plays it smart.

Thanks.

-- 
tejun
