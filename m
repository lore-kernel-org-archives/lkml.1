Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbYDQL1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbYDQL1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYDQL06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:26:58 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:51322 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYDQL05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:26:57 -0400
Date: Thu, 17 Apr 2008 13:30:47 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417113047.GT62286@gandalf.sssup.it>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <4807173E.4060300@unimore.it> <20080417092751.GX12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417092751.GX12774@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, Apr 17, 2008 11:27:55AM +0200
>
> On Thu, Apr 17 2008, Paolo Valente wrote:
> > Maybe there is also another middle-ground solution. I'll try to sketch 
...
> > Does it seem reasonable?
> 
> Not for CFQ, that will stay time based. The problem with #2 above is
> that it then quickly turns to various heuristics, which is just
> impossible to tune for general behaviour. Or it just falls apart for
> other real life situations.
> 

Ok.

After a brief offline discussion with paolo, here it is what we can do:

    o propose a patch for discussion that uses our WF2Q+ variant to
      schedule timeslices in cfq.  The resulting scheduler would be
      quite close to the EEVDF scheduler discussed some time ago for
      the cpu.

    o Introduce a timeout in bfq to give an upper time limit to the
      slices.  Since we have not experimented with that mixed approach
      before[*], we will need to do some tests with relevant workloads to
      see if/how it can work.

I fear that it will take some time, as we're both travelling in this
week.

[*] Anyway it is quite close to how cfq handles async queues, with their
slice_async and slice_async_rq, so it's definitely not something new.
