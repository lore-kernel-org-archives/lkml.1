Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYJ2KKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYJ2KKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYJ2KKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:10:13 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63768 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYJ2KKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:10:11 -0400
Date: Wed, 29 Oct 2008 11:08:45 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: "Andrew Victor" <avictor.za@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not
 needed
Message-ID: <20081029110845.309a7548@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810281251.30031.david-b@pacbell.net>
References: <200810271406.24110.david-b@pacbell.net>
	<200810280920.19864.david-b@pacbell.net>
	<cd73a99e0810281141ief64433u85a55d045346d3fd@mail.gmail.com>
	<200810281251.30031.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Oct 2008 10:08:27.0505 (UTC) FILETIME=[49626E10:01C939AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 28 October 2008, Andrew Victor wrote:
> > hi David,
> > 
> > > I verified it on AT91, where the console is normally DBGU and the
> > > other USARTs do get an open().
> > 
> > The DBGU is part of the system peripherals, which are clocked from MCK
> > and which is always enabled.
> 
> Exactly.

Exactly what? That your patch has exactly zero effect on your test case?

> > Therefore I don't think this is a valid test-case.
> 
> Not for the oddball case Haavard mentioned, no:  the console port
> being something the boot loader wasn't using, which couldn't show
> the early boot messages (before console setup) in any case.  Those
> kinds of systems aren't especially debuggable (it's JTAG or nothing).

Since when is it acceptable to lock up solid in "oddball" cases? Not to
mention that I don't think this is an "oddball" case at all -- the
bootloader has absolutely _no_ way of influencing the initial enable
count of the clock, so the kernel will turn it off as soon as it gets
the chance.

The oddball case is when the clock happens to be shared with
peripherals that are always enabled. Then it doesn't matter if the
clock management in atmel_serial is screwed up.

> I don't have any issue with getting that fixed too ... but unless
> someone has a platform that relies on that case (or can be made to
> do so, for testing), then it's hard for me to worry about it!

David, I can't believe you're taking such an easy attitude towards
basic correctness!

I agree that the clock management is already wrong, but keeping a
couple of clocks enabled when they could have been disabled is far less
of a problem than locking up the console.

I also understand if you don't want to fix the console issue I pointed
out, but I'm surprised that you aren't even willing to acknowledge the
problem, brushing it off with words like "normally" and "as a rule".

Haavard
