Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbYJaLea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbYJaLea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYJaLeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:34:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55387 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041AbYJaLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:34:21 -0400
Date: Fri, 31 Oct 2008 11:34:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add support for the WM8350 watchdog
Message-ID: <20081031113419.GA3982@rakim.wolfsonmicro.main>
References: <1225121516-23667-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081030151804.bc8bd02a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030151804.bc8bd02a.akpm@linux-foundation.org>
X-Cookie: Available while quantities last.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:18:04PM -0700, Andrew Morton wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > +	wm8350_reg_lock(wm8350);

> I was curious about this wm8350_reg_lock/wm8350_reg_unlock thing, so I
> went to have a look at it.  Nothing.  Obviously its authors felt there
> was no benefit in having anyone else understand what it does.

Well, there's really not that much more to it than what the function
names say - some of the registers can be locked in hardware, meaning
that the lock needs to be unlocked when writing to them.  I'll come up
with some sort of blurb and send a patch to Samuel but I'm not sure how
much it'll actually help.

This is mostly for things particularly likely to cause damage to the
system - in this case the hardware supports extremely short timeouts
which might be too short to be able to kick the watchdog again if it
fires and reboots (the lowest option is 0.125s IIRC).  The only way
to recover from that is to remove all power from the system.

> > +	if (test_and_set_bit(1, &wm8350_wdt_users))

> It's odd that the driver uses bit 1 rather than bit 0.

Hrm, yeah.  No idea why, the driver was like that when I first looked at
it and I can't see any history explaining the choice.
