Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbXGKCvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbXGKCvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXGKCva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:51:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:54018 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXGKCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H1Iw5DCZp2tlUiv0MtDwzTXFK4KpeL8uW+zTDBkOpN4b+F9pGVhZAmEmqBjhkMpnIs5c+eMyeUWgwiVpFXYznJfvlC6cqzFmLJO0pNf7tXcR0JlcV6vaMuQmpKrKUlyIHq8ijZZ9Gqhj9JPI7l0cgCkGwzQwaz/6KDJqNNpomsg=
Message-ID: <46944555.80509@gmail.com>
Date: Wed, 11 Jul 2007 11:49:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: ric@emc.com, david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm> <465FC7B1.3060309@gmail.com>            <4693D26D.2060004@emc.com> <4758.1184110800@turing-police.cc.vt.edu>
In-Reply-To: <4758.1184110800@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 10 Jul 2007 14:39:41 EDT, Ric Wheeler said:
> 
>> All of the high end arrays have non-volatile cache (read, on power loss, it is a 
>> promise that it will get all of your data out to permanent storage). You don't 
>> need to ask this kind of array to drain the cache. In fact, it might just ignore 
>> you if you send it that kind of request ;-)
> 
> OK, I'll bite - how does the kernel know whether the other end of that
> fiberchannel cable is attached to a DMX-3 or to some no-name product that
> may not have the same assurances?  Is there a "I'm a high-end array" bit
> in the sense data that I'm unaware of?

Well, the array just has to tell the kernel that it doesn't to write
back caching.  The kernel automatically selects ORDERED_DRAIN in such case.

-- 
tejun
