Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549Ab0ASUnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0ASUnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016Ab0ASUnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0ASUnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:43:05 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Zhang\, Yanmin" <yanmin_zhang@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
References: <1262250960.1819.68.camel@localhost>
	<4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	<1262340730.19773.47.camel@localhost>
	<4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	<1262435612.19773.80.camel@localhost>
	<4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
	<1262593090.29897.14.camel@localhost>
	<4e5e476b1001041028v1f204834r1fa97e732a094210@mail.gmail.com>
	<4e5e476b1001160827n6dc73b35vee8b46e541134c2@mail.gmail.com>
	<1263783999.12893.2.camel@localhost>
	<4e5e476b1001191210s37423e4av6673225d5078a88e@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 19 Jan 2010 15:42:56 -0500
In-Reply-To: <4e5e476b1001191210s37423e4av6673225d5078a88e@mail.gmail.com>
	(Corrado Zoccolo's message of "Tue, 19 Jan 2010 21:10:33 +0100")
Message-ID: <x49zl49vnan.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Mon, Jan 18, 2010 at 4:06 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
>> On Sat, 2010-01-16 at 17:27 +0100, Corrado Zoccolo wrote:
>>> Hi Yanmin
>>> On Mon, Jan 4, 2010 at 7:28 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>>> > Hi Yanmin,
>>> >> When low_latency=1, we get the biggest number with kernel 2.6.32.
>>> >> Comparing with low_latency=0's result, the prior one is about 4% better.
>>> > Ok, so 2.6.33 + corrado (with low_latency =0) is comparable with
>>> > fastest 2.6.32, so we can consider the first part of the problem
>>> > solved.
>>> >
>>> I think we can return now to your full script with queue merging.
>>> I'm wondering if (in arm_slice_timer):
>>> -       if (cfqq->dispatched)
>>> +      if (cfqq->dispatched || (cfqq->new_cfqq && rq_in_driver(cfqd)))
>>>                return;
>>> gives the same improvement you were experiencing just reverting to rq_in_driver.
>> I did a quick testing against 2.6.33-rc1. With the new method, fio mmap randread 46k
>> has about 20% improvement. With just checking rq_in_driver(cfqd), it has
>> about 33% improvement.
>>
> Jeff, do you have an idea why in arm_slice_timer, checking
> rq_in_driver instead of cfqq->dispatched gives so much improvement in
> presence of queue merging, while it doesn't have noticeable effect
> when there are no merges?

It's tough to say.  Is there any chance I could get some blktrace data
for the run?

Cheers,
Jeff
