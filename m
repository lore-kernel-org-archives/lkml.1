Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZBXG0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZBXG0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 01:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZBXG02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 01:26:28 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27415
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855AbZBXG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 01:26:27 -0500
X-BigFish: VPS-30(z34a4jz1432R98dR4015M1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KFK4JJ-02-DAQ-01
Date: Tue, 24 Feb 2009 07:25:41 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/3] x86: hpet: stop HPET_COUNTER when programming
	periodic mode
Message-ID: <20090224062541.GO6298@alberich.amd.com>
References: <20090220230729.GK4834@alberich.amd.com> <20090220231635.GK6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090220231635.GK6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Feb 2009 06:26:07.0387 (UTC) FILETIME=[C6CC76B0:01C99648]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 12:16:35AM +0100, Andreas Herrmann wrote:
> 
> Impact: fix system hang on some systems operating with HZ_1000
> 
> On a system that stalled with HZ_1000, the first value written to
> T0_CMP (when the main counter was not stopped) did not trigger an
> interrupt. Instead after the main counter wrapped around (after
> several minutes) an interrupt was triggered and afterwards the
> periodic interrupt took effect.
> 
> This can be fixed by implementing HPET spec recommendation for
> programming the periodic mode (i.e. stopping the main counter).

Hi Ingo,

Please don't push this commit to Linus' tree.
Currently it's in tip:timers/hpet.

The patch didn't fix the problem that Mark Hounshell was reporting.

But first of all the patch might have side-effects as all hpet timers
that are affect when the main counter is stopped and reset. And
furthermore I have learned that there might have been hpet
implementations that require the second write (w/o HPET_TN_SETVAL bit)
to happen.

I am looking for a different solution.


Thanks,

Andreas


