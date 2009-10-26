Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZJZNbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZJZNbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJZNbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZJZNbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:31:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of  cfq_queues
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
	<4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 09:31:43 -0400
In-Reply-To: <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com>
	(Corrado Zoccolo's message of "Sat, 24 Oct 2009 22:08:48 +0200")
Message-ID: <x49ws2iz3gg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> this series looks good.

Hi, Corrado.  Thanks again for the review!

> I like in particular the fact that you move seekiness detection in the cfqq.
> This can help with processes that issue sequential reads and seeky
> writes, or vice versa.
> Probably, also the think time could be made per-cfqq, so that the
> decision whether we should idle for a given cfqq is more precise.

I'll have to think about that one.  It would be good to know Jens'
opinion on the matter, too.

> On Fri, Oct 23, 2009 at 11:14 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Hi,
>>
>> This is a follow-up patch to the original close cooperator support for
>> CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
>> mode driver, qemu) interleave sequential I/Os between multiple threads
>> or processes.  The result is that there are large delays due to CFQ's
>> idling logic that leads to very low throughput.
>
> You identified the problem in the idling logic, that reduces the
> throughput in this particular scenario, in which various threads or
> processes issue (in random order) the I/O requests with different I/O
> contexts on behalf of a single entity.
> In this case, any idling between those threads is detrimental.
> Ideally, such cases should be already spotted, since think time should
> be high for such processes, so I wonder if this indicates a problem in
> the current think time logic.

For read-test2, the readers are not dependent upon each other.  That is,
each process reads the blocks assigned to it, so they do no
"thinking", or waiting for the other processes, in between I/Os.

> Can you send me your read-test, so I can investigate it?

Sure thing.  I didn't write it, it was provided by Moritoshi Oshiro to
aid in reproducing the dump issue.  You can find it here:

  http://people.redhat.com/jmoyer/read-test2.tar.gz

Cheers,
Jeff
