Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZATUWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZATUWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZATUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:22:15 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50742 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZATUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YFaAMWo+YExbN+LR/OKRa3iXE89xyucw/hNK9975wR3C+2t4O848+t7pf5vepCFAW7
         rY7fHclOyCgtzos8LNeemj+Xg02TPv1xKJ37Iki+EI54Rhpp3P6RMpfOqXWjgbRvSu0Z
         J3THhh4oZR4jRIDK0PCBKqmqgyPWijM0L+uAo=
MIME-Version: 1.0
In-Reply-To: <20090120073709.GC30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
	 <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal>
	 <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal>
	 <20090120073709.GC30821@kernel.dk>
Date: Tue, 20 Jan 2009 15:22:12 -0500
Message-ID: <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Ben Gamari <bgamari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 2:37 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
>> * Jens Axboe (jens.axboe@oracle.com) wrote:
>> Yes, ideally I should re-run those directly on the disk partitions.
>
> At least for comparison.
>

I just completed my own set of benchmarks using the fio job file
Mathieu provided. This was on a 2.5 inch 7200 RPM SATA partition
formatted as ext3. As you can see, I tested all of the available
schedulers with both queuing enabled and disabled. I'll test the Jens'
patch soon. Would a blktrace of the fio run help? Let me know if
there's any other benchmarking or profiling that could be done.
Thanks,

- Ben


			mint		maxt
==========================================================
queue_depth=31:
anticipatory		35 msec		11036 msec
cfq			37 msec		3350 msec
deadline		36 msec		18144 msec
noop			39 msec		41512 msec

==========================================================
queue_depth=1:
anticipatory		45 msec		9561 msec
cfq			28 msec		3974 msec
deadline		47 msec		16802 msec
noop			35 msec		38173 msec
