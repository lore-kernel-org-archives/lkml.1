Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXCQJis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXCQJis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 05:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCQJis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 05:38:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbXCQJir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 05:38:47 -0400
Message-ID: <45FBB67F.3090205@redhat.com>
Date: Sat, 17 Mar 2007 10:35:59 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_RISS?= <frederic.riss@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	 <200703162134.14265.rjw@sisk.pl>	 <1174078066.13341.279.camel@localhost.localdomain> <1174087552.13341.332.camel@localhost.localdomain>
In-Reply-To: <1174087552.13341.332.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> I finally found a dual core box, which survives suspend/resume without
> crashing in the middle of nowhere. Sigh, I never figured out from the
> code and the bug reports what's going on.
> 
> The observed hangs are caused by a stale state transition of the clock
> event devices, which keeps the RCU synchronization away from completion,
> when the non boot CPU is brought back up.
> 
> The suspend/resume in oneshot mode needs the similar care as the
> periodic mode during suspend to RAM. My assumption that the state
> transitions during the different shutdown/bringups of s2disk would go
> through the periodic boot phase and then switch over to highres resp.
> nohz mode were simply wrong.
> 
> Add the appropriate suspend / resume handling for the non periodic
> modes.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Hi,
I can confirm that this patch fixed the problem on Thinkpad X60s.

Thanks !

Milan
--
mbroz@redhat.com
 
