Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXGKCxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXGKCxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbXGKCxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:53:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:54421 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbXGKCxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z5zNRakNHojf17TlzYj4RXlxQo7vogchcSCcurDb123SeYHUKoxLwy8MLjX4XejWnx5b1Gl50RuCqRMdlTK30HDKwwNJMmQxdOjpijImmqYlUbXJ1EVovolKlCxb9hAbA/zJ4B9uf+/CbGbOQsWndRL/0DezfI8RhQd7I0YQ+us=
Message-ID: <469445BC.1010709@gmail.com>
Date: Wed, 11 Jul 2007 11:51:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: ric@emc.com
CC: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown>  <18010.12472.209452.148229@notabene.brown>  <20070528094358.GM25091@agk.fab.redhat.com>  <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>  <20070529220500.GA6513@agk.fab.redhat.com>  <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>  <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com> <4693D26D.2060004@emc.com>
In-Reply-To: <4693D26D.2060004@emc.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
>> Don't those thingies usually have NV cache or backed by battery such
>> that ORDERED_DRAIN is enough?
> 
> All of the high end arrays have non-volatile cache (read, on power loss,
> it is a promise that it will get all of your data out to permanent
> storage). You don't need to ask this kind of array to drain the cache.
> In fact, it might just ignore you if you send it that kind of request ;-)
> 
> The size of the NV cache can run from a few gigabytes up to hundreds of
> gigabytes, so you really don't want to invoke cache flushes here if you
> can avoid it.
> 
> For this class of device, you can get the required in order completion
> and data integrity semantics as long as we send the IO's to the device
> in the correct order.

Thanks for clarification.

>> The problem is that the interface between the host and a storage device
>> (ATA or SCSI) is not built to communicate that kind of information
>> (grouped flush, relaxed ordering...).  I think battery backed
>> ORDERED_DRAIN combined with fine-grained host queue flush would be
>> pretty good.  It doesn't require some fancy new interface which isn't
>> gonna be used widely anyway and can achieve most of performance gain if
>> the storage plays it smart.
> 
> I am not really sure that you need this ORDERED_DRAIN for big arrays...

ORDERED_DRAIN is to properly order requests from host request queue
(elevator/iosched).  We can make it finer-grained but we do need to put
some ordering restrictions.

-- 
tejun
