Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXJaLDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXJaLDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXJaLDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:03:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbXJaLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:03:15 -0400
Date: Wed, 31 Oct 2007 12:03:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dag-Erling Sm?rgrav <des@linpro.no>
Cc: Clemens Koller <clemens.koller@anagramm.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
Message-ID: <20071031110322.GA2381@elf.ucw.cz>
References: <ujrmyvt2tyy.fsf@false.linpro.no> <46E6A737.6080805@anagramm.de> <ujrabrt2qkt.fsf@false.linpro.no> <46E6B617.7030106@anagramm.de> <ujr1wd52npl.fsf@false.linpro.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ujr1wd52npl.fsf@false.linpro.no>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-09-11 18:04:06, Dag-Erling Sm?rgrav wrote:
> Clemens Koller <clemens.koller@anagramm.de> writes:
> > Dag-Erling Sm?rgrav <des@linpro.no> writes:
> > > Without knowing exacly which chip is present, there is no way for the
> > > userland calibration tool to know how big a difference a calibration
> > > step makes.
> > I am not talking about the calibration algorithm and it's quality.
> 
> Neither am I.
> 
> > I am talking about _how_ the calibration register is addressed from
> > userspace. It's a simple register, some bits at address 7 and I would
> > expect to read/modify/write registers to do all the things you want
> > to do. Register access in userspace doesn't put any limitation
> > to applications.
> 
> It requires the application to know the hardware intimately.
> 
> Calibration of the M41T11 is implemented using the lower 6 bits of
> register 7; this is not necessarily the case for other existing or
> future chips.

The driver should know the hardware.

> Let's say I normalize this to [-128;127]; an application that tried to
> speed up the clock would waste several hours increasing the
> calibration value from 0 to 1, 2, 3 before seeing an effect after
> increasing it to 4.  And how do I normalize the assymetric range of
> the M41T11?

So you normalize it to -32;32 range, and tell application (using
ioctl) that range is -32;32? Or you just -EINVAL if it goes out of
range?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
