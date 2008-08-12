Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYHLSbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYHLSbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYHLSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:31:32 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:10550 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYHLSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:31:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALFyoUhQyAwK/2dsb2JhbACBYK8/gSk
Date: Tue, 12 Aug 2008 20:31:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
Message-ID: <20080812183128.GC26249@infomag.infomag.iguana.be>
References: <489E0F5A.8010404@keyaccess.nl> <489F612E.7070400@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489F612E.7070400@keyaccess.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

> >I'm going over a list of drivers that break the boot of randconfig 
> >kernels by keeping resources busy:
> >
> >http://lkml.org/lkml/2008/8/1/96
> >
> >and eurotechwdt and plain wdt are in that list. Below is an eurotechwdt 
> >that makes passing in io and irq values mandatory as to keep that from 
> >happening.
> >
> >I saw pcwd was already isafied and followed that -- due to the comment 
> >in eurwdt_release() though, I'm not sure about a .shutdown() method.

The Berkshire PC-Watchdog card is indeed allready isafied. This is (just
like the mixcom and the ICS WDT50x watchdog cards) an ISA card that can
be inserted into an ISA slot. (The other two will be isafied also).
The shutdown notifier does the same thing then the reboot_notifier.

Most of the other drivers (except the 2 PCI cards and 1 USB card)
are however directly attached to the motherboard of the system. These
are thus in my opinion more platform devices then isa device drivers.

The problem with a lott of these devices (however) is that they can not
be probed. You either have the hardware or you don't. Some can't even be
stopped once started, some are allready active on boot.
My feeling: If you have the hardware, you will compile and load the driver
of these "platform" watchdog devices, if not you won't.

What we do best, however, to avoid problems at boot with random kernels
looks to be another issue to me.

Kind regards,
Wim.

