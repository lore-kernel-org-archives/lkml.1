Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXE3Qz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXE3Qz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXE3QzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:55:12 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:17749 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbXE3QzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:55:10 -0400
Message-ID: <465DAC72.1010201@cfl.rr.com>
Date: Wed, 30 May 2007 12:55:14 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Stefan Bader <Stefan.Bader@de.ibm.com>
CC: Stefan Bader <sbader3@googlemail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
In-Reply-To: <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 16:55:20.0241 (UTC) FILETIME=[4E87D210:01C7A2DB]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15208.000
X-TM-AS-Result: No--3.451100-5.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Bader wrote:
> You got a linear target that consists of two disks. One drive (a)
> supports barriers and the other one (b) doesn't. Device-mapper just
> maps the requests to the appropriate disk. Now the following sequence
> happens:
> 
> 1. block x gets mapped to drive b
> 2. block y (with barrier) gets mapped to drive a
> 
> Since drive a supports barrier request we don't get -EOPNOTSUPP but
> the request with block y might get written before block x since the
> disk are independent. I guess the chances of this are quite low since
> at some point a barrier request will also hit drive b but for the time
> being it might be better to indicate -EOPNOTSUPP right from
> device-mapper.

The device mapper needs to ensure that ALL underlying devices get a 
barrier request when one comes down from above, even if it has to 
construct zero length barriers to send to most of them.

