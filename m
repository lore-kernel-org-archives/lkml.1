Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401AbXAXTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbXAXTDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXAXTDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:03:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53672 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXAXTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:03:48 -0500
Subject: Re: One-shot high-resolution POSIX timer periodically late
From: john stultz <johnstul@us.ibm.com>
To: John <me@privacy.net>
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, mingo@elte.hu,
       akpm@osdl.org, shill@free.fr
In-Reply-To: <45B729AF.4030701@privacy.net>
References: <45B729AF.4030701@privacy.net>
Content-Type: text/plain; charset=utf-8
Date: Wed, 24 Jan 2007 11:02:27 -0800
Message-Id: <1169665347.6905.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 10:41 +0100, John wrote:
> I'm using the POSIX timers API. My platform is x86 running Linux
> 2.6.18.6 patched with the high-resolution timer subsystem.
> 
> http://www.tglx.de/hrtimers.html
> 
> I've written a small "de-jittering engine" that receives packets in
> small bursts due to network jitter (typical average rate of 1000 packets
> per second), and re-sends them at a "smooth" rate.
> 
> Just before I re-send a packet, I arm a one-shot timer in order to
> receive a signal when it is time to send the next packet.
> 
> I've noticed a strange phenomenon that I cannot explain.
> 
> Sometimes (rarely) the one-shot timer will expire more than 50 µs later
> than expected. This would seem normal, except that it happens periodically.
> 
> For example, my app had been running normally for 2 minutes when it
> started printing diagnostics (see below).
> 
> The first T_NEXT_POP is the date the timer was supposed to expire,
> 
> NOW is the date the timer was handled after returning from sigwaitinfo
> (I am aware that blocking signals, and handling them at a specific point
> in the code will add some latency)
> 
> The second T_NEXT_POP is the date the next timer is supposed to expire.
> 
> DIFF is the difference between real and expected dates.
> 
> (All dates are CLOCK_MONOTONIC by the way.)
> 
> As you can see, the first diagnostic came at 472.410501014... Then
> another diagnostic almost exactly two seconds apart 9 times in a row!
> 
> My process is the only SCHED_FIFO process on the system. There are no
> user-space processes with a higher priority. AFAICT, only a kernel
> thread could keep the CPU away from my app.
> 
> Is there a periodic kernel thread that runs every 2 seconds, cannot be
> preempted, and runs for over 50 µs??

This sounds like a BIOS SMI issue. Can you reproduce this behavior on
different hardware? 

thanks
-john

