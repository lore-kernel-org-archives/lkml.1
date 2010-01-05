Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569Ab0AEO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0AEO7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472Ab0AEO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab0AEO7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:59:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue  merging
References: <20091230213439.GQ4489@kernel.dk>
	<1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	<20100104144711.GA7968@redhat.com>
	<4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	<x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com>
	<20100104185100.GF7968@redhat.com>
	<x49fx6ladzk.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001041237v71952c8ewaaef3778353f7521@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 05 Jan 2010 09:58:52 -0500
In-Reply-To: <4e5e476b1001041237v71952c8ewaaef3778353f7521@mail.gmail.com>
	(Corrado Zoccolo's message of "Mon, 4 Jan 2010 21:37:05 +0100")
Message-ID: <x49zl4s8uoj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> On Mon, Jan 4, 2010 at 8:04 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>>> >>> Hi Corrado,
>>>> >>>
>>>> >>> What's the reason that reads don't benefit from merging queues and hence
>>>> >>> merging requests and only writes do on SSD?
>>>> >>
>>>> >> On SSDs, reads are just limited by the maximum transfer rate, and
>>>> >> larger (i.e. merged) reads will just take proportionally longer.
>>>> >
>>>> > This is simply not true.  You can get more bandwidth from an SSD (I just
>>>> > checked numbers for 2 vendors' devices) by issuing larger read requests,
>>>> > no matter whether the access pattern is sequential or random.
>>>> I know, but the performance increase given the size is sublinear, and
>>>> the situation here is slightly different.
>>>> In order for the requests to be merged, they have to be submitted concurrently.
>>>> So you have to compare 2 concurrent requests of size x with one
>>>> request of size 2*x (with some CPU overhead).
>>>> Moreover, you always pay the CPU overhead, even if you can't do the
>>>> merging, and you must be very lucky to keep merging, because it means
>>>> the two processes are working in lockstep; it is not sufficient that
>>>> the requests are just nearby, as for rotational disks.
>>>>
>>>
>>> For jeff, at least "dump" utility threads were kind of working in lockstep
>>> for writes and he gained significantly by merging these queues together.
>>
>> Actually, it was for reads.
>>
>>> So the argument is that CPU overhead saving in this case is more substantial
>>> as compared to gains made by lockstep read threads. I think we shall have to
>>> have some numbers to justify that.
>>
>> Agreed.  Corrado, I know you don't have the hardware, so I'll give this
>> a run through the read-test2 program and see if it regresses at all.
> Great.

I ran the test program 50 times, and here are the results:

==> vanilla <==
Mean: 163.22728
Population Std. Dev.: 0.55401

==> patched <==
Mean: 162.91558
Population Std. Dev.: 1.08612

This looks acceptable to me.

Cheers,
Jeff
