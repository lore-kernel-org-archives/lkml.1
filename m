Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZJZPK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZJZPK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZJZPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZJZPKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:10:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of  processes doing I/O
References: <200910202011.53858.czoccolo@gmail.com>
	<x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
	<x49tyxs7lge.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910220343q2af96eedr69cda2594822af76@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 11:10:17 -0400
In-Reply-To: <4e5e476b0910220343q2af96eedr69cda2594822af76@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 22 Oct 2009 12:43:32 +0200")
Message-ID: <x49ws2ixkbq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> On Wed, Oct 21, 2009 at 6:36 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>> OK.  The idea was to try to make the thing a bit more digestable.
>> Honestly, I had to re-write it to figure out what it was doing.  Could
>> you rework it so the logic is more obvious to others and still correct?
>
> What about:
> /* interested queues (we consider only the ones with the same priority class) */
> unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
> unsigned sync_slice = cfqd->cfq_slice[1];
> unsigned expected_latency = sync_slice * iq;
> if (expected_latency > target_latency) {
> 	unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
> 	/* scale low_slice according to IO priority and sync vs async */
> 	unsigned low_slice = min(slice,  base_low_slice * slice / sync_slice);
> 	/* the adapted slice value is scaled to fit all iqs into the target latency */
> 	slice = max(slice * cfq_target_latency / expected_latency, low_slice);
> }

Yeah, that looks a ton better.  Thanks for doing that!

Cheers,
Jeff
