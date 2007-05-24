Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbXEXFYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbXEXFYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXEXFYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:24:12 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40696 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbXEXFYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:24:11 -0400
Date: Thu, 24 May 2007 14:23:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <Bryan.Wu@analog.com>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Message-ID: <20070524052312.GA2447@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Bryan Wu <Bryan.Wu@analog.com>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 12:21:47AM -0400, Mike Frysinger wrote:
> is this completely bad mojo ?  is there some other mechanism that
> provides what i want and i just dont know about it ?  or do i just
> make people change the driver to fit their application, thus throwing
> out the idea of keeping all board-specific details in just the boards
> file ...

It sounds like your constraining your driver based on terminology.
Watchdogs on most embedded platforms support either a 'reset' mode or
otherwise act as periodic timers, trying to push both of these
functionalities in to a watchdog driver is rather pointless.
CONFIG_WATCHDOG implies 'reset' mode by definition.

If you wish to use your watchdog timer as a periodic timer, simply have a
clocksource/clockevents established for it, leave the watchdog driver as
a reset-only thing, and let the user decide which one they want either
via Kconfig or the kernel command line. (The watchdog driver can just
-ENODEV or -EBUSY if the clocksource is active).
