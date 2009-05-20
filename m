Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZETRDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZETRDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZETRDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:03:13 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:5382 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753579AbZETRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:03:12 -0400
Message-ID: <4A1437CC.1090108@panasas.com>
Date: Wed, 20 May 2009 20:03:09 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       James Smart <James.Smart@Emulex.Com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <tomof@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>	 <20090520111619.87f815b1.sfr@canb.auug.org.au>	 <1242830240.2881.10.camel@localhost.localdomain>	 <20090521004251.9160e228.sfr@canb.auug.org.au>	 <1242830865.2881.13.camel@localhost.localdomain>	 <1242836425.2881.44.camel@localhost.localdomain>	 <4A14322A.4000709@panasas.com> <1242837810.2881.47.camel@localhost.localdomain> <4A1436D8.4050004@panasas.com>
In-Reply-To: <4A1436D8.4050004@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2009 17:03:13.0312 (UTC) FILETIME=[DC567A00:01C9D96C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2009 07:59 PM, Boaz Harrosh wrote:
> On 05/20/2009 07:43 PM, James Bottomley wrote:
>> If you actually just ask scsi-post-merge-2.6 where this line is, it will
>> tell you:
>>
>> static void blk_finish_request(struct request *req, int error)
>> {
>>         BUG_ON(blk_queued_rq(req));
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>>         if (blk_rq_tagged(req))
>>                 blk_queue_end_tag(req->q, req);
>>
>> James
>>
>>
> 
> This is a new BUG_ON from:
>     block: implement and enforce request peek/start/fetch
> 
> It looks like there is one more sight of the old usage that
> was not converted.
> 
> Tejun?
>  

The patch has a comment about that:
    * disallowing completion of queued (not started) requests

Do you have a stack trace?

Boaz
