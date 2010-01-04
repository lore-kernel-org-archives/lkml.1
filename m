Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826Ab0ADTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0ADTE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711Ab0ADTE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0ADTE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:04:27 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue merging
References: <20091230213439.GQ4489@kernel.dk>
	<1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	<20100104144711.GA7968@redhat.com>
	<4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	<x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com>
	<20100104185100.GF7968@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Jan 2010 14:04:15 -0500
In-Reply-To: <20100104185100.GF7968@redhat.com> (Vivek Goyal's message of
	"Mon, 4 Jan 2010 13:51:00 -0500")
Message-ID: <x49fx6ladzk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jan 04, 2010 at 07:37:17PM +0100, Corrado Zoccolo wrote:
>> On Mon, Jan 4, 2010 at 5:51 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > Corrado Zoccolo <czoccolo@gmail.com> writes:
>> >
>> >> Hi Vivkek,
>> >>
>> >> On Mon, Jan 4, 2010 at 3:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >>> On Wed, Dec 30, 2009 at 11:22:47PM +0100, Corrado Zoccolo wrote:
>> >>>> Non rotational devices' performances are not affected by
>> >>>> distance of read requests, so there is no point in having
>> >>>> overhead to merge such queues.
>> >>>> This doesn't apply to writes, so this patch changes the
>> >>>> queued[] field, to be indexed by READ/WRITE instead of
>> >>>> SYNC/ASYNC, and only compute proximity for queues with
>> >>>> WRITE requests.
>> >>>>
>> >>>
>> >>> Hi Corrado,
>> >>>
>> >>> What's the reason that reads don't benefit from merging queues and hence
>> >>> merging requests and only writes do on SSD?
>> >>
>> >> On SSDs, reads are just limited by the maximum transfer rate, and
>> >> larger (i.e. merged) reads will just take proportionally longer.
>> >
>> > This is simply not true.  You can get more bandwidth from an SSD (I just
>> > checked numbers for 2 vendors' devices) by issuing larger read requests,
>> > no matter whether the access pattern is sequential or random.
>> I know, but the performance increase given the size is sublinear, and
>> the situation here is slightly different.
>> In order for the requests to be merged, they have to be submitted concurrently.
>> So you have to compare 2 concurrent requests of size x with one
>> request of size 2*x (with some CPU overhead).
>> Moreover, you always pay the CPU overhead, even if you can't do the
>> merging, and you must be very lucky to keep merging, because it means
>> the two processes are working in lockstep; it is not sufficient that
>> the requests are just nearby, as for rotational disks.
>> 
>
> For jeff, at least "dump" utility threads were kind of working in lockstep
> for writes and he gained significantly by merging these queues together.

Actually, it was for reads.

> So the argument is that CPU overhead saving in this case is more substantial
> as compared to gains made by lockstep read threads. I think we shall have to
> have some numbers to justify that.

Agreed.  Corrado, I know you don't have the hardware, so I'll give this
a run through the read-test2 program and see if it regresses at all.

Cheers,
Jeff
