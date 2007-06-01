Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbXFASKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbXFASKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762071AbXFASKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:10:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:26965 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761320AbXFASKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Bh1SIa0bNWaSC2CI8zdhQ9GpadfqScSWFCzEKuPvZDJXbkA+Jp3PmEkq0nzb491UeUEYlgUWK6lifH58fOV3PGS6bZUn3QiLecWI76KsOfW0YnMU9d+EY0Sy4INdt6/0KrJziUxafVCGui1KnEgDATDAoR1/A9x6utOUvx3htlQ=
Message-ID: <466060C2.4060506@gmail.com>
Date: Sat, 02 Jun 2007 03:09:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>,
       ric@emc.com
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>            <465FC7B1.3060309@gmail.com> <10553.1180717627@turing-police.cc.vt.edu>
In-Reply-To: <10553.1180717627@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 01 Jun 2007 16:16:01 +0900, Tejun Heo said:
>> Don't those thingies usually have NV cache or backed by battery such
>> that ORDERED_DRAIN is enough?
> 
> Probably *most* do, but do you really want to bet the user's data on it?

Thought we were talking about high-end storage stuff.  I don't think
I'll be too uncomfortable.  The reason why we're talking about this at
all is because high-end stuff with fancy NV cache and a hunk of battery
will unnecessarily suffer from the current barrier implementation.

>> The problem is that the interface between the host and a storage device
>> (ATA or SCSI) is not built to communicate that kind of information
>> (grouped flush, relaxed ordering...).  I think battery backed
>> ORDERED_DRAIN combined with fine-grained host queue flush would be
>> pretty good.  It doesn't require some fancy new interface which isn't
>> gonna be used widely anyway and can achieve most of performance gain if
>> the storage plays it smart.
> 
> Yes, that would probably be "pretty good".  But how do you get the storage
> device to *reliably* tell the truth about what it actually implements? (Consider
> the number of devices that downright lie about their implementation of cache
> flushing....)

SCSI NV bit or report write through cache?  Again, we're talking about
large arrays and we already trust the write through thing even on cheap
single spindle drives.  sd currently doesn't honor NV bit and it's
causing some troubles on some arrays.  We'll probably have to honor them
at least conditionally.

-- 
tejun
