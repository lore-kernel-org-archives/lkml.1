Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbXGVFyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbXGVFyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXGVFyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:54:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbXGVFyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:54:14 -0400
Date: Sat, 21 Jul 2007 22:54:13 -0700 (PDT)
Message-Id: <20070721.225413.23605608.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722054356.GO21668@ftp.linux.org.uk>
References: <20070720161154.GA17382@infradead.org>
	<20070721.192251.122832397.davem@davemloft.net>
	<20070722054356.GO21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 06:43:56 +0100

> seems to imply that CONFIG_RTC has no business whatsoever on sparc64 builds,
> let alone in defconfig - JavaStation had never gone sparc64.  OTOH, we
> have explicit scanning ISA bus in addition to EBUS in drivers/char/rtc.c
> in case of __sparc_v9__, so it looks like help above ought to be changed.
> OTTH, the isa-scanning code looks odd - for comparison, FreeBSD has
> the same logics for ebus (looks for node called "rtc"), but the isa probe
> in the same driver (sys/sparc64/sparc64/rtc.c) is

It doesn't get built on sparc64 any more.

If you look at the current tree:

1) we handle all of the sparc64 RTC stuff in arch/sparc64/kernel/time
2) all the __sparc_v9__ crap is removed from drivers/char/rtc.c
3) all the __sparc__ crap is changed to CONFIG_SPARC32 in same
4) CONFIG_RTC is not longer allows on sparc64, only sparc32 with PCI
