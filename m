Return-Path: <linux-kernel-owner+w=401wt.eu-S1030727AbXFHObt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727AbXFHObt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969094AbXFHObi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:31:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57266 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968537AbXFHObh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:31:37 -0400
Date: Fri, 8 Jun 2007 10:31:36 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608143136.GC25649@havoc.gtf.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org> <20070607224746.GA23290@havoc.gtf.org> <46690D10.9040808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46690D10.9040808@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 05:02:24PM +0900, Tejun Heo wrote:
> I don't think the first one is probable considering BSY is supposed to
> set when SRST is received.  This is pretty fundamental in the protocol
> and necessary for the device to work properly as master, so I think this
> is one of few things we can rely upon.

See a URL I posted earlier in this thread.  With dumb ATAPI devices we
actually have to wait a bit for BSY to be asserted.  Not only at reset,
but also for every command.


> How about limiting nsect/lbal wait duration?  Say, 100ms or 500ms?  That
> can somewhat ease our paranoia and should show acceptable behavior for
> braindead devices too.

That's quite reasonable.

	Jeff



P.S.  We can probably reduce the msleep(150) sprinkled about the code to
msleep(100), for the dumb-ATAPI-device wait.
