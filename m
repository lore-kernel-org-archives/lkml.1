Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751Ab0BZLUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:20:18 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:59392 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934303Ab0BZLUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:20:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19335.44648.623680.272844@pilspetsen.it.uu.se>
Date: Fri, 26 Feb 2010 12:20:08 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dynticks on Vortex86SX ? (Cx486SLC + just the standard i8254 PC timer)
In-Reply-To: <4B86EF85.12688.440738@Frantisek.Rysanek.post.cz>
References: <4B86EF85.12688.440738@Frantisek.Rysanek.post.cz>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frantisek Rysanek writes:
 > Dear Gentlemen,
 > 
 > I'm having fun with a Vortex-based motherboard, under 2.6.33.
 > Linux reports the CPU as a Cx486SLC :-)
 > A complete PC-compatible motherboard (without VGA) running at ~ 2 
 > Watts.
 > I'm wondering how to decrease the power consumption even further,
 > and "tickless" operation comes to mind.
 > And that's where I have a problem. Even if I enable 
 > "Tickless System (Dynamic Ticks)" in the menuconfig,
 > there's no apparent change in consumption, and I still get 
 > around 200-300 timer interrupts per second...
 > 
 > These are some entries from my .config that might be relevant:
 > 
 > CONFIG_TICK_ONESHOT=y
 > CONFIG_NO_HZ=y
 > # CONFIG_HIGH_RES_TIMERS is not set
 > CONFIG_M486=y
 > CONFIG_HZ_250=y
 > CONFIG_HZ=250

Select HZ=100.

 > The only timer that this platform contains (known to Linux)
 > is the generic i8254-compatible PC timer.
 > 
 > Makes me wonder if this platform is capable of "tickless" operation
 > at all. Or maybe my particular combination of features in the .config
 > effectively prevents the long idle periods from occurring?
 > 
 > Apart from a standard init and getty's, there's a dhclient and sshd 
 > running on the machine... it's a fairly minimal text-mode system.
 > 
 > Any ideas are welcome :-)

Enable CONFIG_DEBUG_KERNEL and CONFIG_TIMER_STATS, rebuild and reboot.
cat /proc/interrupts, echo 1 > /proc/timer_stats, sleep for 10 seconds,
cat /proc/timer_stats and /proc/interrupts.
That'll tell you which timers are firing the most, which translates into
requiring frequent timer interrupts.
