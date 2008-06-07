Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbYFGLwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbYFGLwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 07:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYFGLwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 07:52:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:52348 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYFGLwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 07:52:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18506.30304.646369.956267@alkaid.it.uu.se>
Date: Sat, 7 Jun 2008 13:52:00 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Brownell <david-b@pacbell.net>
Cc: "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
In-Reply-To: <200806060553.48057.david-b@pacbell.net>
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
	<200806060553.48057.david-b@pacbell.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell writes:
 > On Wednesday 04 June 2008, Leon Woestenberg wrote:
 > > include/asm-arm/arch-ixp4xx/platform.h:
 > > static inline void gpio_line_set(u8 line, int value)
 > > {
 > >         if (value == IXP4XX_GPIO_HIGH)
 > >             *IXP4XX_GPIO_GPOUTR |= (1 << line);
 > >         else if (value == IXP4XX_GPIO_LOW)
 > >             *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
 > > }
 > > 
 > > Under a Linux kernel where multiple drivers are accessing GPIO, the
 > > latter does not seem safe against preemption (assuming the memory
 > > read-modify-write is not atomic).
 > > 
 > > Shouldn't GPIO access be protected against concurrent access here?
 > 
 > Well, against an IRQ in the middle of those read/modify/write
 > sequences hidden by the "|=" and "&=" syntax.  Last I knew,
 > no XScale CPUs support on-chip SMP.

The IOP342 has two XScale cores on-chip. However, these cores are
still only ARMv5TE and Linux wants ARMv6 or newer for SMP, so I
don't know to what extent the IOP342 is supported by Linux.
