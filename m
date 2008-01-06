Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYAFJpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYAFJpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYAFJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:45:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYAFJpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:45:33 -0500
Date: Sun, 6 Jan 2008 10:45:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Message-ID: <20080106094504.GE26291@elte.hu>
References: <200801052042.56042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801052042.56042.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Subject		: soft lockup - CPU#1 stuck for 15s! [swapper:0]
> Submitter	: "Parag Warudkar" <parag.warudkar@gmail.com>
> Date		: 2007-12-07 18:14
> References	: http://lkml.org/lkml/2007/12/7/299
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9525
> Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
> 		  Thomas Gleixner <tglx@linutronix.de>
> 		  Ingo Molnar <mingo@elte.hu>

i think this only occurs with cpuidle, right? drivers/cpuidle/ and 
CPU_IDLE is new in 2.6.24 so this appears to be a bug in that code (or a 
bug elsewhere triggered by that code), not a regression from v2.6.23.

this commit might also have improved things:

 ------------>
 commit 2bacec8c318ca0418c0ee9ac662ee44207765dd4
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Tue Dec 18 15:21:13 2007 +0100

    sched: touch softlockup watchdog after idling

    touch softlockup watchdog after idling.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
 <------------

albeit Parag reported actual real, human-noticeable delays in system 
behavior and those cannot be false positives.

	Ingo
