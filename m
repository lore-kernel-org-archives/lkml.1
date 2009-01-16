Return-Path: <linux-kernel-owner+w=401wt.eu-S937165AbZAPTLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937165AbZAPTLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbZAPTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:11:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33465
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765240AbZAPTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:10:58 -0500
Date: Fri, 16 Jan 2009 11:10:59 -0800 (PST)
Message-Id: <20090116.111059.205876014.davem@davemloft.net>
To: grundler@google.com
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
References: <1232117771.3224.21.camel@localhost.localdomain>
	<20090116090928.e43c986e.akpm@linux-foundation.org>
	<da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@google.com>
Date: Fri, 16 Jan 2009 11:02:12 -0800

> On Fri, Jan 16, 2009 at 9:09 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> ...
> >> +             CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
> >> +             panic("%s: Firmware is halted due to command timeout\n",
> >> +                     ioc->name);
> >> +     }
> >> +}
> >> +EXPORT_SYMBOL(mpt_halt_firmware);
> >
> > Doing a panic() after we've already detected an error is plain nasty.
> > Is there no way in which we can allow the kernel to continue?
> 
> Basically what James said. It's not long though: only 6 emails.
> I started that thread thinking the same thing you did:
>     http://marc.info/?t=123123569200003&r=1&w=2
> 
> TBH, I still wouldn't implement it the way LSI maintainers did.
> I'm happy they are the maintainers and it's their call.

They are doing things which effect the entire system, not just
their driver.  So this doesn't fall under "maintainer's rights"

If they fail locally, that's fine and perfectly expected, but to take
the whole machine out is another matter altogether.
