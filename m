Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbXEaTWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbXEaTWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbXEaTV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:21:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55741
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbXEaTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:21:55 -0400
Date: Thu, 31 May 2007 12:21:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jens Axboe <jens.axboe@oracle.com>
cc: Phillip Susi <psusi@cfl.rr.com>, David Chinner <dgc@sgi.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
  and dm/md.
In-Reply-To: <20070531190013.GD32105@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705311220080.17389@asgard.lang.hm>
References: <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
 <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
 <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
 <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk>
 <20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com>
 <20070531190013.GD32105@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Jens Axboe wrote:

> On Thu, May 31 2007, Phillip Susi wrote:
>> David Chinner wrote:
>>> That sounds like a good idea - we can leave the existing
>>> WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
>>> behaviour that only guarantees ordering. The filesystem can then
>>> choose which to use where appropriate....
>>
>> So what if you want a synchronous write, but DON'T care about the order?
>>   They need to be two completely different flags which you can choose
>> to combine, or use individually.
>
> If you have a use case for that, we can easily support it as well...
> Depending on the drive capabilities (FUA support or not), it may be
> nearly as slow as a "real" barrier write.

true, but a "real" barrier write could have significant side effects on 
other writes that wouldn't happen with a synchronous wrote (a sync wrote 
can have other, unrelated writes re-ordered around it, a barrier write 
can't)

David Lang
