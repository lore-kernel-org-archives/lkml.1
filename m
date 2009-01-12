Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZALFJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZALFJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZALFJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:09:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:43546 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750720AbZALFJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:09:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/OMmktWgrORm5FBHctk9W8F46qx920pwUIZr3EUl
	HVgkydGQzFB608
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4969D0D7.2060401@xyzw.org>
References: <4969D0D7.2060401@xyzw.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 06:09:01 +0100
Message-Id: <1231736941.6003.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 02:58 -0800, Brian Rogers wrote:
> The attached program gives itself idle priority, then forks off two 
> child processes that execute a busy loop. The result is that sometimes 
> all other processes stop and the whole system freezes until this program 
> exits. An affected system will respond to pings, but X freezes, the 
> cursor won't move, SSH sessions won't respond or echo characters back, 
> and not even a text console will budge. Hitting Alt-SysRq-N twice can 
> sometimes unfreeze the system, or you can just wait for the program to exit.
> 
> This bug is in 2.6.29-rc1. I have also observed this bug in 2.6.28 on 
> two dual-core systems, an Athlon X2 desktop and a Core 2 Duo laptop. 
> Both are running a 64-bit system. Using i386 and amd64 Ubuntu Jaunty 
> daily builds with a 2.6.28 kernel, I found I could reproduce the problem 
> with the 64-bit kernel, but not the 32-bit kernel. Since that might just 
> be due to a difference in the kernel configurations, I'm attaching the 
> kernel configuration on which I know this problem can be triggered.
> 
> It may take a couple-dozen runs of this program for the freeze to occur. 
> Just hit control-C and re-run the program until it happens. When it does 
> freeze, the effect is immediate, so there's no chance you'll interrupt 
> the program too soon.

Hi,

I haven't been able to reproduce complete hangs, but with your proggy
adapted to my quad, _and_ the addition of a SCHED_NORMAL hog, I can
reproduce some very bad interactivity, including massive character
repeats while attempting to type, and general "lurchiness" (_bad_ wakeup
latency).  I'll poke it with a sharp stick or two.

	-Mike

