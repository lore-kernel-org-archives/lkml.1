Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYFFIw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYFFIw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYFFIwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:52:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYFFIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:52:11 -0400
Date: Fri, 6 Jun 2008 09:52:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
Message-ID: <20080606085200.GC2765@flint.arm.linux.org.uk>
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:00:19PM +0200, Leon Woestenberg wrote:
> include/asm-arm/arch-ixp4xx/platform.h:
> static inline void gpio_line_set(u8 line, int value)
> {
> 	if (value == IXP4XX_GPIO_HIGH)
> 	    *IXP4XX_GPIO_GPOUTR |= (1 << line);
> 	else if (value == IXP4XX_GPIO_LOW)
> 	    *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
> }
> 
> Under a Linux kernel where multiple drivers are accessing GPIO, the
> latter does not seem safe against preemption (assuming the memory
> read-modify-write is not atomic).

or even interrupts.

> Shouldn't GPIO access be protected against concurrent access here?

Definitely.  It's certainly buggy as currently stands.
