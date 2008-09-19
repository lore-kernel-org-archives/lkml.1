Return-Path: <linux-kernel-owner+w=401wt.eu-S1751180AbYISHks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbYISHks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYISHkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:40:37 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57715 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757047AbYISHkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:40:37 -0400
Date: Fri, 19 Sep 2008 09:40:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] UIO: Resend: Change driver name of uio_pdrv
Message-ID: <20080919074034.GA8945@strlen.de>
References: <20080918210306.GC2991@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080918210306.GC2991@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

[Added Magnus Damm (= author of uio_pdrv_genirq) to Cc:]

On Thu, Sep 18, 2008 at 11:03:07PM +0200, Hans J. Koch wrote:
> The patch below was already discussed and accepted:
> http://lkml.org/lkml/2008/7/7/409
> 
> It somehow got lost (probably because I forgot it when I sent my queue
> to Greg...). So, here it is again:
> 
> -------------8<------------------------
> 
> The generic UIO platform device driver should be given a unique driver ID and
> not just "uio". This is especially important since we now have a similar driver
> named uio_pdrv_genirq. Currently, there's no user of this driver in the
> mainline kernel.
I want to suggest to rename uio_pdrv_genirq to uio_genirq instead.  In
my eyes this would be more clear.  IMHO the pdrv suffix doesn't yield
more clearity because it is only used in a certain namespace---namely
that of platform devices.  So e.g.

	/sys/bus/platform/devices/uio_pdrv.0

isn't any better than

	/sys/bus/platform/devices/uio.0

.  Looking at the name of other platform drivers using

	git grep -E '_pdrv(_.*)?"' 

I get three false positives[1] and uio_pdrv_genirq (driver and some
users in arch/sh/kernel/cpu/sh4a/setup-sh7343.c).  So the _pdrv suffix
doesn't seem very common.

Just my 0.02€

Best regards
Uwe

[1] in drivers/scsi/megaraid.c
