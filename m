Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYJ3Jec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYJ3Jec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYJ3JeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:34:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbYJ3JeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:34:17 -0400
Message-ID: <49097F8D.1010804@kernel.org>
Date: Thu, 30 Oct 2008 18:34:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mike Anderson <andmike@linux.vnet.ibm.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not	elv_next_request()
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk> <49096865.2050006@kernel.org> <20081030075855.GO31673@kernel.dk> <20081030092741.GA9478@linux.vnet.ibm.com>
In-Reply-To: <20081030092741.GA9478@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Oct 2008 09:34:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Anderson wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Thu, Oct 30 2008, Tejun Heo wrote:
>>> Jens Axboe wrote:
>>>> That's actually a pretty dumb error, I'm surprised it hasn't reared its
>>>> ugly face in more ways. Presumably because the timeout is usually so
>>>> long, that we'll get to actually issuing and completing it within the
>>>> normal timeout anyway.
>>> Heh... it showed its ugly face in many different ways while I was
>>> playing with PMP connected via a very long eSATA cable.
>> Ah :-)
>>
>> If we had it wired up for eg the old IDE drivers, it would have shown up
>> quite quickly as well I think.
> 
> I am getting errors now and my system will not boot up. The system is
> connected to storage with active / passive paths. If we are doing a
> BLKPREP_KILL we will call elv_dequeue_request which will add the
> timer for the request we are killing. 
> 
> The attached patch is a quick patch to work around my issue, but we
> probably need something better. I would like to run some short timeout
> testing on it for a while (though that previously did not catch Tejun's
> issue). I will look at this more tomorrow unless someone beats me to it.

Aieee... I'm now trying to clean up the command fetch/completion
interface.  Please give me a day or two.  I'll clean it all up.

Thanks.

-- 
tejun
