Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbXFBAEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbXFBAEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXFBAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:04:31 -0400
Received: from mail.tmr.com ([64.65.253.246]:37050 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbXFBAEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:04:30 -0400
Message-ID: <4660B403.3000202@tmr.com>
Date: Fri, 01 Jun 2007 20:04:19 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       device-mapper development <dm-devel@redhat.com>,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
  filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com> <20070531062404.GH32105@kernel.dk> <465F15ED.1070304@cfl.rr.com> <20070531185836.GC32105@kernel.dk>
In-Reply-To: <20070531185836.GC32105@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 31 2007, Phillip Susi wrote:
>   
>> Jens Axboe wrote:
>>     
>>> No Stephan is right, the barrier is both an ordering and integrity
>>> constraint. If a driver completes a barrier request before that request
>>> and previously submitted requests are on STABLE storage, then it
>>> violates that principle. Look at the code and the various ordering
>>> options.
>>>       
>> I am saying that is the wrong thing to do.  Barrier should be about 
>> ordering only.  So long as the order they hit the media is maintained, 
>> the order the requests are completed in can change.  barrier.txt bears 
>>     
>
> But you can't guarentee ordering without flushing the data out as well.
> It all depends on the type of cache on the device, of course. If you
> look at the ordinary sata/ide drive with write back caching, you can't
> just issue the requests in order and pray that the drive cache will make
> it to platter.
>
> If you don't have write back caching, or if the cache is battery backed
> and thus guarenteed to never be lost, maintaining order is naturally
> enough.
>   

Do I misread this? If ordered doesn't reach all the way to the platter 
then there will be failure modes which result in order not preserved. 
Battery backed cache doesn't prevect failures between the cache and the 
platter.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

