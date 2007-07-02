Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbXGBUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbXGBUN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXGBUNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:13:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:42130 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbXGBUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qL8xOgXJPM5kwgzmhkddewKWqVzsoE5GDj82ke2LIVloyHTJmntqzMTeJhf1/e3XK07F1p18JyfFVgJQJOUPYd2z2pE+hRkie+9BUUcKTYeOtkZn5lGIdXiLV/Rjx4eyHcUb5cYRBH6ZOXaZ9nRKB49WOElKsU7FN/gUE8vgWe8=
Date: Mon, 2 Jul 2007 22:13:54 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: rae l <crquan@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Does the kernel HPET support has problems or the hwclock from util-linux?
Message-ID: <20070702201354.GA13313@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310707020315v54d19338u817d23d4380bde07@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rae l <crquan@gmail.com> ha scritto:
> from this address, I know util-linux-2.12r is the latest:
> http://www.kernel.org/pub/linux/utils/util-linux/util-linux-2.12r.lsm
> 
> My Dell OptiPlex 320 has 4 HPET timers and no RTC, so the execution of
> hwclock has errors:
> 
> gektop@tux ~ $ /sbin/hwclock --show
> select() to /dev/rtc to wait for clock tick timed out
> gektop@tux ~ $ /sbin/hwclock --version
> hwclock from util-linux-2.12r

I think that the problem is that HPET and the CMOS RTC (list in CC)
share the same interrupt line.
I suppose that you should enable CONFIG_HPET_RTC_IRQ (my hardware has
the same "feature"); in this way /dev/rtc correcly reports that it
cannot deliver the interrupt (when HPET is enabled) and hwclock uses
direct ISA access.

Luca
-- 
Windows NT crashed.
I'm the Blue Screen of Death.
No one hears your screams.
