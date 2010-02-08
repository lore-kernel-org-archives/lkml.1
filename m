Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0BHJNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:13:37 -0500
Received: from www.tglx.de ([62.245.132.106]:50333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0BHJNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:13:36 -0500
Date: Mon, 8 Feb 2010 10:13:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6/7)
In-Reply-To: <20100208053830.GA7128@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Andreas Mohr wrote:
> 
> And then a cat current_clocksource managed to hang again.

Well, that's not surprising at all. If one task is stuck on clocksource_mutex,
then the next one will be stuck as well.

> (NOTE that the - now complete! - SysRq-T list does NOT show any backtraces
> of kwatchdog any more, only many other processes)
> Could it be that the (rather disruptive) NMI watchdog confuses the current state at
> change_clocksource and causes that stuff to get left with
> clocksource_mutex remaining taken?

Nope, the NMI watchdog is not involved. It merily tells us that the
task is stuck.

      tglx

