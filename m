Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbXGVGcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbXGVGcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXGVGbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:31:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXGVGbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:31:50 -0400
Date: Sun, 22 Jul 2007 07:31:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
Message-ID: <20070722063149.GQ21668@ftp.linux.org.uk>
References: <20070722054356.GO21668@ftp.linux.org.uk> <20070721.225413.23605608.davem@davemloft.net> <20070722061924.GP21668@ftp.linux.org.uk> <20070721.232207.26531557.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721.232207.26531557.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 11:22:07PM -0700, David Miller wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Sun, 22 Jul 2007 07:19:24 +0100
> 
> > We probably ought to make drivers/sbus/char/rtc.c sparc32-only,
> > then - AFAICS it simply won't be able to register misc device and that
> > will be it.  ACK?
> 
> ACK.
> 
> > > 2) all the __sparc_v9__ crap is removed from drivers/char/rtc.c
> > > 3) all the __sparc__ crap is changed to CONFIG_SPARC32 in same
> > > 4) CONFIG_RTC is not longer allows on sparc64, only sparc32 with PCI
> > 
> > Umm...  OK, that takes care of sparc64 side of things, which is probably
> > all we realistically care about.  Except that it still leaves broken sparc32
> > defconfig - we have RTC=m, SUN_MOSTEK_RTC=m and kbuild won't deal with it...
> 
> That definitely needs to be fixed and I'm willing to entertain
> any suggestion on how to deal with it.

Crude and simple way would be to add

config JS_RTC
	tristate "JavaStation RTC"
	depends on SPARC32 && PCI
	<copy help from RTC with s/will be called rtc/will be called js-rtc>

in drivers/char/Kconfig, slap plain and simple !SPARC in RTC dependencies
and put
js-rtc-y = rtc.o
obj-$(JS_RTC) += js-rtc.o
in drivers/char/Makefile

Objections?
