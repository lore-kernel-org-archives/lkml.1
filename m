Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbXL3LSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbXL3LSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 06:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXL3LSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 06:18:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXL3LSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 06:18:46 -0500
Date: Sun, 30 Dec 2007 12:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071230111552.GA8578@elte.hu>
References: <20071225230731.GA29030@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071225230731.GA29030@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Todays hardware is mostly capable of doing better: with correctly set 
> up wakeups, machine can sleep and successfully pretend it is not 
> sleeping -- by waking up whenever something interesting happens. Of 
> course, it is easier on machines not connected to the network, and on 
> notebook computers.
> 
> Requirements:
> 
> 0) Working suspend-to-RAM, with kernel being able to bring video back.
> 
> 1) RTC clock that can wake up system

very nice approach! It might require smarter hardware to be really 
efficient, but the generic ability for Linux to utilize S3 automatically 
would _quickly_ drive the creation of smarter hardware i'm sure - so i'd 
propose to include this even if it wastes power in some cases.

a quick feature request: could you please make the wake-on-RTC 
capability generic and add a CONFIG_DEBUG_SUSPEND_ON_RAM=y config option 
(disabled by default) that does a short 1-second suspend-to-RAM sequence 
upon bootup? That way we could test s2ram automatically (which is a MUCH 
needed feature for automated regression testing and automatic 
bisection). In addition, some sort of 'suspend for N seconds' /sys or 
/dev/rtc capability would be nice as well.

btw., how far are you from having a working prototype?

	Ingo
