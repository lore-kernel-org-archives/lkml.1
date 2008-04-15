Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbYDOOnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbYDOOnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbYDOOnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:43:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1501 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYDOOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:43:01 -0400
Date: Tue, 15 Apr 2008 15:42:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wm97xx-core: Only schedule interrupt handler if not already scheduled
Message-ID: <20080415144250.GB5203@sirena.org.uk>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080414140832.ZZRA012@mailhub.coreip.homeip.net> <20080415084819.GA24498@rakim.wolfsonmicro.main> <20080415085946.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415085946.ZZRA012@mailhub.coreip.homeip.net>
X-Cookie: Bus error -- driver executed.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 09:02:35AM -0400, Dmitry Torokhov wrote:
> On Tue, Apr 15, 2008 at 09:48:19AM +0100, Mark Brown wrote:

> > As well as not queuing the work it ensures that the calls to
> > irq_enable() are balanced which helps with implementing that operation.

> Hmm... another question then - what would fire up wm97xx_pen_interrupt()
> again, before wm97xx_pen_irq_worker had a chance to run, if the very
> first thing we do after getting interrupt is irq_enable(wm, 0)?

Normally nothing - in most systems the interrupt will not be shared
and/or the board irq_enable() operation will completely disable the IRQ
line.  The main use case would be if the interrupt is shared and the
board irq_enable() operation doesn't affect other sources, though boards
may also decide that they can do without disabling the interrupt.
