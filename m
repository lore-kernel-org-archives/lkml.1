Return-Path: <linux-kernel-owner+w=401wt.eu-S937582AbYEUWEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937582AbYEUWEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbYEUWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:04:18 -0400
Received: from mail.macqel.be ([194.78.208.39]:6476 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747AbYEUWER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:04:17 -0400
Date: Wed, 21 May 2008 23:57:51 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.or
Subject: RTC subsystem and 11 min rtc update
Message-ID: <20080521215751.GA12343@frolo.macqel>
References: <20080520105844.GA694@frolo.macqel> <18482.45473.866954.385654@cargo.ozlabs.ibm.com> <20080520140744.GA6427@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520140744.GA6427@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I have linux-2.6.25-rc6 running on a board with an i2c rtc chip,
and synchronized to a ntp server.  When my board starts, the current
time is correctly read from the rtc chip, but ...

I noticed that my rtc chip does not get updated by the kernel every 11 min,
on my powerpc board, just like it would be on all other architectures.

Paul Mackerras told me that that is now supposed to be done by the code
inside #ifdef CONFIG_GENERIC_CMOS_UPDATE in kernel/time/ntp.c.

I agree that is a good place.

But, here CONFIG_GENERIC_CMOS_UPDATE is well defined and an i2c clock also,
and my rtc clock is not updated.  I see kernel/time/ntp.c::sync_cmos_clock
calling arch/powerpc/kernel/time.c::update_persistent_clock, where
ppc_md.set_rtc_time is NULL. ppc_md.get_rtc_time is NULL as well, but
that does not prevent the initial reading of the rtc clock during the startup
of the kernel.

Should update_persistent_clock not be directly part of the rtc subsystem,
instead of falling in a detour or a dead-end in the arch subsystem ?

Philippe
