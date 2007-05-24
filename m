Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXEXPM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXEXPM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXEXPMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:12:52 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:27982 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbXEXPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fLoCPCkz2/rmVPTasB6skOk8nkKloQeHTOi9yLUpsOsKLw9haTZu5iIFzUPLROvPL4HxUSbmlECD9Ihd7823Yl9hTjiWDZRrLbkxQp5PbRP1gfmf/BRWo/EYkjYlZQcfCx/HOpqGOEtCgFkfwMpzB+SeeN56Orf/hYjT1mnDnhQ=
Message-ID: <8bd0f97a0705240812s27925cads9b2f50dbeb67b9ff@mail.gmail.com>
Date: Thu, 24 May 2007 11:12:46 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <Bryan.Wu@analog.com>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
In-Reply-To: <20070524052312.GA2447@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
	 <20070524052312.GA2447@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, May 24, 2007 at 12:21:47AM -0400, Mike Frysinger wrote:
> > is this completely bad mojo ?  is there some other mechanism that
> > provides what i want and i just dont know about it ?  or do i just
> > make people change the driver to fit their application, thus throwing
> > out the idea of keeping all board-specific details in just the boards
> > file ...
>
> It sounds like your constraining your driver based on terminology.
> Watchdogs on most embedded platforms support either a 'reset' mode or
> otherwise act as periodic timers, trying to push both of these
> functionalities in to a watchdog driver is rather pointless.
> CONFIG_WATCHDOG implies 'reset' mode by definition.

my constraint was trying to keep all of the code that deals with the
watchdog in one file ... those were the blinders i had on from the get
go so the idea of having different drivers that work with the watchdog
hardware hadnt even occurred to me

> If you wish to use your watchdog timer as a periodic timer, simply have a
> clocksource/clockevents established for it, leave the watchdog driver as
> a reset-only thing, and let the user decide which one they want either
> via Kconfig or the kernel command line. (The watchdog driver can just
> -ENODEV or -EBUSY if the clocksource is active).

hmm, i'll poke the clocksource/clockevents stuff as well as the
notifier idea from Alan

thanks
-mike
