Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXCCQgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXCCQgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 11:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030679AbXCCQgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 11:36:48 -0500
Received: from tim.rpsys.net ([194.106.48.114]:51016 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030672AbXCCQgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 11:36:47 -0500
Subject: Re: 2.6.21-rc2 radeon backlight
From: Richard Purdie <rpurdie@rpsys.net>
To: James Simmons <jsimmons@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Alex Romosan <romosan@sycorax.lbl.gov>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       "David S. Miller" <davem@davemloft.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <lists@onerussian.com>
In-Reply-To: <Pine.LNX.4.64.0703031557570.2901@pentafluge.infradead.org>
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
	 <20070301184531.b3aeafe3.akpm@linux-foundation.org>
	 <87tzx35zkc.fsf@sycorax.lbl.gov>
	 <20070302122920.a2967ebf.akpm@linux-foundation.org>
	 <1172878338.11149.198.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703031557570.2901@pentafluge.infradead.org>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 16:35:13 +0000
Message-Id: <1172939714.5942.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-03 at 16:06 +0000, James Simmons wrote:
> > > Richard, is this actually a bug, or is it a config error or something like that?
> > > 
> > > And should we track it as a post-2.6.20 regression?
> > 
> > Its a regression IMO. Arguably its a Kconfig error but a nasty one as
> > the defaults cause the problems. Different people seem to have different
> > interpretations but to me it appears that the patch from James causes
> > backlights to fail to turn on for a variety of devices which worked
> > before.
> 
>    It is NOT a Kconfig error. The problem is that for many fbdev drivers 
> the backlight code is broken. For some magic reason it only works on 
> pmacs. Most likely because the firmware properly sets up the backlight. 
> Plus we have the conflict with acpi backlight. 
>    Think about it. Enabling the backlight code breaks the backlight. 
> Without the backlight driver the default behaviour of the backlight works.
> Who sets up the default behavior? I don't have a LCD panel with a 
> backlight othewise I would track the problem down.

I not arguing several fb driver's backlight code isn't broken, it is. We
have a Kconfig problem though since we used to stop users selecting
things that didn't work and now we're allowing them. Worse still, the
defaults break for people. That is a regression.

Anyhow, the patch I proposed should let people enable/disable it at
runtime with defaults known to work which should address the problem
until someone figures out how to fix the backlight drivers themselves
properly.

Cheers,

Richard

