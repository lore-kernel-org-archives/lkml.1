Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbYBLRpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbYBLRpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbYBLRo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:44:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYBLRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:44:59 -0500
Date: Tue, 12 Feb 2008 19:20:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212182024.GA4940@one.firstfloor.org>
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - the kgdb commands should always act on the *current* CPU only
>  - add one command that says "switch over to CPU #n" which just releases 
>    the current CPU and sends an IPI to that CPU #n (no timeouts, no 
>    synchronous waiting, no nothing - it's like a "continue", but with a 
>    "try to get the other CPU to stop"

The problem I see here is that the kernel tends to get badly confused
if one CPU just stops responding. At some point someone does an global
IPI and that then hangs.  You would need to hotunplug the CPU which
is theoretically possible, but quite intrusive. Or maybe the "isolate CPUs 
in cpusets" frame work someone posted recently on l-k could be used.  Still 
would probably have all kinds of tricky issues and races.

-Andi

