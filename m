Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXFDHkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXFDHkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 03:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXFDHkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 03:40:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:64626 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXFDHj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 03:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GKNwlZHF4CrH5ulNmiYq8qBMTAfFGxyEUPpQwZL+uvIEmo+QJYG+JMdbjB4olsXgbSFYBhnRwzwpy6APeGpgHVQ1+Ek2Q7FkF+u+kYy0d8mPC6CeZeTLCpGDsZGGmMqqdvwe9tUCWiGRhFXDLeKBiDJ+3nbwKKQamB80NFkP3Zc=
Message-ID: <4663C1C1.5000009@gmail.com>
Date: Mon, 04 Jun 2007 16:39:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: David Chinner <dgc@sgi.com>, david@lang.hm,
       Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
   and dm/md.
References: <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <20070531070656.GK32105@kernel.dk> <465F8F71.20302@gmail.com> <20070601082140.GP32105@kernel.dk> <46613666.7010800@gmail.com> <20070602143438.GB32105@kernel.dk>
In-Reply-To: <20070602143438.GB32105@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sat, Jun 02 2007, Tejun Heo wrote:
>> Hello,
>>
>> Jens Axboe wrote:
>>>> Would that be very different from issuing barrier and not waiting for
>>>> its completion?  For ATA and SCSI, we'll have to flush write back cache
>>>> anyway, so I don't see how we can get performance advantage by
>>>> implementing separate WRITE_ORDERED.  I think zero-length barrier
>>>> (haven't looked at the code yet, still recovering from jet lag :-) can
>>>> serve as genuine barrier without the extra write tho.
>>> As always, it depends :-)
>>>
>>> If you are doing pure flush barriers, then there's no difference. Unless
>>> you only guarantee ordering wrt previously submitted requests, in which
>>> case you can eliminate the post flush.
>>>
>>> If you are doing ordered tags, then just setting the ordered bit is
>>> enough. That is different from the barrier in that we don't need a flush
>>> of FUA bit set.
>> Hmmm... I'm feeling dense.  Zero-length barrier also requires only one
>> flush to separate requests before and after it (haven't looked at the
>> code yet, will soon).  Can you enlighten me?
> 
> Yeah, that's what the zero-length barrier implementation I posted does.
> Not sure if you have a question beyond that, if so fire away :-)

I thought you were talking about adding BIO_RW_ORDERED instead of
exposing zero length BIO_RW_BARRIER.  Sorry about the confusion.  :-)

-- 
tejun
