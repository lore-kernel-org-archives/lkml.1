Return-Path: <linux-kernel-owner+w=401wt.eu-S966239AbXDDBdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966239AbXDDBdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966242AbXDDBdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:33:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58026 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966239AbXDDBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:33:49 -0400
Date: Wed, 4 Apr 2007 02:36:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, dwmw2@infradead.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404023637.65c56227@the-village.bc.nu>
In-Reply-To: <20070403.182125.77058566.davem@davemloft.net>
References: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<20070403.165518.55726194.davem@davemloft.net>
	<20070404021924.71e87580@the-village.bc.nu>
	<20070403.182125.77058566.davem@davemloft.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Using different majors for different instances of the exact same kind
> of device is really not smart.  It's a serial port, and if you try
> to dress it up to be something else you run into all kinds of problems.

Disagree. There are lots of good reasons you need to know which
port/which card/which slot/which multiplexor.

There is a world of a difference between a serious serial port
application and "wtf has my console gone"

> Not the least of which is the user has to scratch his head figuring
> out what kind of chip drives his serial console, he just wants the
> first serial port and he should have a way to say just that even
> on the kernel command line.

Define "first". First by I/O order, by PCI scan order (and which type),
does ACPI come before or after ISA etc...

At the moment we sort of magic this for the PC by having hardcoded probe
order hacks by address, on the sparc by having other driver magic, on the
PPC by hardcoding some rules etc then hack the result to be ttyS0.

I've no fundamental problem with S0->console port 1, S1 -> console port 2
etc, but the general notion that type and positional information doesn't
matter is complete and utter bollocks when you try and apply it to any
serious serial setup.

Alan
