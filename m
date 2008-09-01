Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYIALPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYIALPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYIALOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:14:54 -0400
Received: from www.tglx.de ([62.245.132.106]:57993 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYIALOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:14:53 -0400
Date: Mon, 1 Sep 2008 13:14:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BB2116.1060904@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, Larry Finger wrote:

> An ancient laptop of mine started throwing errors from b43legacy when I
> started using 2.6.27 on it. This has been bisected to commit bfc0f59 "x86:
> merge tsc calibration". Incidentally, I was appalled at the number of build
> errors that were found while bisecting in this region. Every commit from
> 2.6.26-rc9-00715 to at least -00719 had include errors that had to be fixed
> before it would compile. Those fixes are the only reason that the builds below
> are "dirty".
> 
> The CPU in this computer is an AMD-K6 at stepping 0c and running at 450 MHz.
> 
> The critical differences in the dmesg output between the "good" and "bad"
> results indicate a factor of 2 difference in the clock speed, and are shown
> below:

> +Clocksource tsc unstable (delta = 500037272 ns)

> -Clocksource tsc unstable (delta = 83950402 ns)

In both cases the TSC is ahead of the pm_timer, which looks like the
pm_timer is behaving strange.

Can you please disable the pm_timer (in the kernel config,
unfortunately there is no command line option for that) for a test and
provide the relevant output of demsg ?

Thanks,

	tglx

