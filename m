Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYIBDUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYIBDUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 23:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYIBDT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 23:19:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYIBDT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 23:19:57 -0400
Date: Mon, 1 Sep 2008 20:18:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> 
> We had the same problem versus the local APIC timer calibration, which
> had basically the same algorithm as the TSC one and we changed it to
> look at the PMTimer as well in the days where we debugged the initial
> wreckage caused by the nohz/highres changes.

Hmm.

So then how would you discover when it's reliable and when it's not? Just 
hardcode it for certain machines?

One alternative might be to do the same "detect if it's SMM code by seeing 
how long the read takes" for the PIT reads themselves. Right now the code 
does it for the HPET timer read and for the PM_TIMER reads, but _not_ for 
the PIT status register reads.

> How do you prevent the SMM brain damage, when it hits 3 times in a row ? 

Well, the biggest problem is actually _detection_.

We have three different timers, and they all have their own problems. How 
do you reliably detect which one to use? The PM_TIMER clearly is _not_ 
always the answer here, but the code just assumes it is!

			Linus
