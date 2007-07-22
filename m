Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbXGVGTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbXGVGTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGVGT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:19:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33358 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXGVGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:19:25 -0400
Date: Sun, 22 Jul 2007 07:19:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
Message-ID: <20070722061924.GP21668@ftp.linux.org.uk>
References: <20070720161154.GA17382@infradead.org> <20070721.192251.122832397.davem@davemloft.net> <20070722054356.GO21668@ftp.linux.org.uk> <20070721.225413.23605608.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721.225413.23605608.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 10:54:13PM -0700, David Miller wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Sun, 22 Jul 2007 06:43:56 +0100
> 
> > seems to imply that CONFIG_RTC has no business whatsoever on sparc64 builds,
> > let alone in defconfig - JavaStation had never gone sparc64.  OTOH, we
> > have explicit scanning ISA bus in addition to EBUS in drivers/char/rtc.c
> > in case of __sparc_v9__, so it looks like help above ought to be changed.
> > OTTH, the isa-scanning code looks odd - for comparison, FreeBSD has
> > the same logics for ebus (looks for node called "rtc"), but the isa probe
> > in the same driver (sys/sparc64/sparc64/rtc.c) is
> 
> It doesn't get built on sparc64 any more.
> 
> If you look at the current tree:
> 1) we handle all of the sparc64 RTC stuff in arch/sparc64/kernel/time

I see...  We probably ought to make drivers/sbus/char/rtc.c sparc32-only,
then - AFAICS it simply won't be able to register misc device and that
will be it.  ACK?

> 2) all the __sparc_v9__ crap is removed from drivers/char/rtc.c
> 3) all the __sparc__ crap is changed to CONFIG_SPARC32 in same
> 4) CONFIG_RTC is not longer allows on sparc64, only sparc32 with PCI

Umm...  OK, that takes care of sparc64 side of things, which is probably
all we realistically care about.  Except that it still leaves broken sparc32
defconfig - we have RTC=m, SUN_MOSTEK_RTC=m and kbuild won't deal with it...
