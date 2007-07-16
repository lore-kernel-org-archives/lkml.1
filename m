Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbXGPJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbXGPJmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXGPJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:42:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbXGPJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:42:01 -0400
Date: Mon, 16 Jul 2007 11:41:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus <lists4me@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070716094158.GA19491@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707141334.45628.lists4me@web.de> <200707141711.25272.lists4me@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707141711.25272.lists4me@web.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus <lists4me@web.de> wrote:

> [...] The mouse is smooth, just when one app is being quit (dont know 
> why...) the mouse will be jerking for a few seconds...

is the mouse jerky on any app quitting? Or is your observation the 
following: _sometimes_ apps quit unexpectedly (their window just 
vanishes?), and _at the same time_, the mouse becomes jerky as well, for 
a few seconds?

the mouse typically only becomes jerky when there's some really high 
load on the system - anything else would be a kernel bug. A jerky mouse 
on an unloaded system is definitely a sign of some sort of kernel bug 
(in or outside of the scheduler). An app vanishing unexpectedly might 
mean an OOM-kill - but that would should up in the syslog as well. 
Pretty weird.

Can you make this regression trigger arbitrarily, so that we could debug 
it better? Apps exiting unexpectedly can be debugged via:

  http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/vdso-print-fatal-signals.patch

you can turn it on via the print-fatal-signals=1 boot option or via:

  echo 1 > /proc/sys/kernel/print-fatal-signals

this feature will produce a small dump to the syslog about every app 
that exits unexpectedly. Note that this might not cover all types of 
"window suddenly vanishes" regressions.

	Ingo
