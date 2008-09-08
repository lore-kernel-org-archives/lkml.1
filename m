Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYIHVhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYIHVhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYIHVhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:37:43 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59873 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbYIHVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:37:43 -0400
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <200809081429.57805.david-b@pacbell.net>
References: <1220889205.8074.16.camel@localhost.localdomain>
	 <200809081213.37705.david-b@pacbell.net>
	 <1220905689.8074.68.camel@localhost.localdomain>
	 <200809081429.57805.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 16:37:40 -0500
Message-Id: <1220909860.8074.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 14:29 -0700, David Brownell wrote:
> > No, it's a regression.  ...  This turns off the ability to select
> > GEN_RTC if you've said yes to RTC_CLASS.  Since RTC_CLASS is currently
> > unsupported on parisc, we need to fix that by making the RTC_CLASS
> > option unselectable on parisc.
> 
> So you affirmed that there was no override, AND that it was
> previously treated as junk DNA (ignored).  So just what were
> you disagreeing with me about??

The fact that the override you put in to disable GEN_RTC is causing a
regression.

> I have a hard time calling something a regression which
> was never really a supported configuration.  And which
> still *JUST WORKS* in those defconfigs ... given all that,
> it's hard to argue that something is actually broken.

On 2.6.25 the parisc users got a working realtime clock.  On 2.6.26 they
can find themselves without one using the same .config file.  This is
the regression.  The fix is to disable RTC_CLASS until we have it
working for parisc.

> Kconfig is not about letting Aunt Tillie configure kernels
> without being able to shoot herself in the foot.  That
> discussion has been had (at length!) before.  Result, we
> have a much better kernel config framework ... but still
> don't facilitate "Kconfig-4-dummiez" audiences.

Kconfig is complex enough that we try not to trip users up by hiding
things, especially when it's the wrong thing to hide on this platform.
If an option specifically doesn't work or causes harm on a platform, it
shouldn't be selectable on that platform.  This isn't Aunt Tillieism,
this is called common sense.

James


