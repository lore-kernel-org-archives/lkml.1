Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYJNVFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYJNVFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYJNVEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:04:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbYJNVEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:04:51 -0400
Date: Tue, 14 Oct 2008 23:04:04 +0200
From: Karel Zak <kzak@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081014210404.GJ10429@nb.net.home>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home> <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org> <20081013105559.15ccb67f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013105559.15ccb67f@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 10:55:59AM -0400, Arjan van de Ven wrote:
> Karel: Can you describe what it WANTS to do so we can see if we can

 It wants to "atomically" (without context switch) read/write time
 from CMOS. This is unrealistic of course.

> just extend the linux kernel to do that the right way?

 The kernel is already extended and hwclock uses the extension :-)
 The solution is /dev/rtc.

 The code that directly works with CMOS is fallback solution for
 people who don't want or can not use the standard RTC device. I guess
 people use this functionally for experiments only. Today the RTC
 framework should work everywhere.

 I'll simply remove the "cli" / "sti" code -- eventually I can try
 to optimize it by mlockall() and SCHED_FIFO (as suggested by Linus).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
