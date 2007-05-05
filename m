Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXEEHef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXEEHef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 03:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXEEHef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 03:34:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbXEEHef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 03:34:35 -0400
Date: Sat, 5 May 2007 00:34:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 3/3] clockevents: Fix resume logic
Message-Id: <20070505003421.00ec45ba.akpm@linux-foundation.org>
In-Reply-To: <20070430102852.042964000@linutronix.de>
References: <20070430102837.748238000@linutronix.de>
	<20070430102852.042964000@linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 10:43:34 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> We need to make sure, that the clockevent devices are resumed, before
> the tick is resumed. The current resume logic does not guarantee this.
> 
> Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> event devices before resuming the tick / oneshot functionality.
> 
> Fixup the existing users.

This one makes the Vaio-of-fun hang during suspend to disk.  It gets up to
"swsusp: critical section/: done (%d pages copied)" then it freezes.

I retested only 2.6.21 plus

origin
clocksource-fix-resume-logic
clockevents-fix-resume-logic

and that hung in the same fashion. 
Config at http://userweb.kernel.org/~akpm/config-sony.txt
