Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbYEPHkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbYEPHkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYEPHkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:40:23 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:41862 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYEPHkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:40:23 -0400
Date: Fri, 16 May 2008 09:46:28 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew <jackdachef@gmail.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080516074628.GA17802@gandalf.sssup.it>
References: <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com> <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk> <20080515122156.GA11600@gandalf.sssup.it> <20080516064002.GL16217@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516064002.GL16217@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, May 16, 2008 08:40:03AM +0200
>
...
> I think we can improve this further without getting too involved. If a
> 2nd request is seen in cfq_rq_enqueued(), then DO schedule a dispatch
> since this likely means that we wont be doing more merges on the first
> one.
> 

But isn't there the risk that even the second request would be
dispatched, while it still could have grown?

Moreover I am still unsure about how to handle (and if it's worth
handling) the case in which we restart queueing after an empty
dispatch round due to idling, as it would still have the same
problem.

(Also anticipatory doesn't handle this case too well.)
