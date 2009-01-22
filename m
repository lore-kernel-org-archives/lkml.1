Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZAVCfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZAVCfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZAVCfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:35:33 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:12246 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZAVCfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:35:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zwo9BZlyu/UUTGekL7HXrL7mqYWT0dpKwkh5qDOGMkL6s71CR3vHBqKBh7w7OqivuG
         LFxIRXoY0ljyENKIbv4uqpwlnNVMu1Zu0czDo/0qAzM+1K6mzYWET8Kp887zPPldLjJv
         +mR2ybB8TtcW0Zk81VvMEuNUcRWd2J/qaiknA=
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Ben Gamari <bgamari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
In-Reply-To: <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com>
References: <20090117004439.GA11492@Krystal>
	 <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk>
	 <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk>
	 <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk>
	 <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 21:35:28 -0500
Message-Id: <1232591728.3782.6.camel@mercury.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this will help, but I just completed another set of
benchmarks using Jens' patch and a variety of device parameters. Again,
I don't know if this will help anyone, but I figured it might help
quantify the differences between device parameters. Let me know if
there's any other benchmarking or testing that I can do. Thanks,

- Ben


			mint		maxt
==========================================================
queue_depth=1, slice_async_rq=1, quantum=1, patched
anticipatory		25 msec		4410 msec
cfq			27 msec		1466 msec
deadline		36 msec		10735 msec
noop			48 msec		37439 msec
==========================================================
queue_depth=1, slice_async_rq=1, quantum=4, patched
anticipatory		38 msec		3579 msec
cfq			35 msec		822 msec
deadline		37 msec		10072 msec
noop			32 msec		45535 msec
==========================================================
queue_depth=1, slice_async_rq=2, quantum=1, patched
anticipatory		33 msec		4480 msec
cfq			28 msec		353 msec
deadline		30 msec		6738 msec
noop			36 msec		39691 msec
==========================================================
queue_depth=1, slice_async_rq=2, quantum=4, patched
anticipatory		40 msec		4498 msec
cfq			35 msec		1395 msec
deadline		41 msec		6877 msec
noop			38 msec		46410 msec
==========================================================
queue_depth=31, slice_async_rq=1, quantum=1, patched
anticipatory		31 msec		6011 msec
cfq			36 msec		4575 msec
deadline		41 msec		18599 msec
noop			38 msec		46347 msec
==========================================================
queue_depth=31, slice_async_rq=2, quantum=1, patched
anticipatory		30 msec		9985 msec
cfq			33 msec		4200 msec
deadline		38 msec		22285 msec
noop			25 msec		40245 msec
==========================================================
queue_depth=31, slice_async_rq=2, quantum=4, patched
anticipatory		30 msec		12197 msec
cfq			30 msec		3457 msec
deadline		35 msec		18969 msec
noop			34 msec		42803 msec



On Tue, 2009-01-20 at 15:22 -0500, Ben Gamari wrote:
> On Tue, Jan 20, 2009 at 2:37 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
> >> * Jens Axboe (jens.axboe@oracle.com) wrote:
> >> Yes, ideally I should re-run those directly on the disk partitions.
> >
> > At least for comparison.
> >
> 
> I just completed my own set of benchmarks using the fio job file
> Mathieu provided. This was on a 2.5 inch 7200 RPM SATA partition
> formatted as ext3. As you can see, I tested all of the available
> schedulers with both queuing enabled and disabled. I'll test the Jens'
> patch soon. Would a blktrace of the fio run help? Let me know if
> there's any other benchmarking or profiling that could be done.
> Thanks,
> 
> - Ben
> 
> 
> 			mint		maxt
> ==========================================================
> queue_depth=31:
> anticipatory		35 msec		11036 msec
> cfq			37 msec		3350 msec
> deadline		36 msec		18144 msec
> noop			39 msec		41512 msec
> 
> ==========================================================
> queue_depth=1:
> anticipatory		45 msec		9561 msec
> cfq			28 msec		3974 msec
> deadline		47 msec		16802 msec
> noop			35 msec		38173 msec

