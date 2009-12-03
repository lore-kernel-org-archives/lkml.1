Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZLCJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZLCJaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZLCJaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:30:23 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:36780 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbZLCJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:30:22 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Thu, 3 Dec 2009 10:30:21 +0100
User-Agent: KMail/1.9.10
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912011005140.2983-100000@iolanthe.rowland.org> <200912020952.09354.linux@rainbow-software.org> <200912021042.04557.oliver@neukum.org>
In-Reply-To: <200912021042.04557.oliver@neukum.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2347
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031030.22460.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009, Oliver Neukum wrote:
> Am Mittwoch, 2. Dezember 2009 09:52:08 schrieb Ondrej Zary:
> > It shows "prev is NULL, qh=f6581080, ehci->async=f6581000".
> >
> > The problem is that activating usbmon causes the problem to disappear. No
> >  errors in maybe 15 attempts. It appeared on 2nd attempt after unloading
> >  usbmon.
>
> That suggests a use after free bug, which usbmon prevents holding
> an additional reference.
> Are you using SLAB_DEBUG?

Just tried 2.6.32-rc8-next-20091202 with SLAB_DEBUG enabled and got this:

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<f7c649a3>] qh_completions+0x6c/0x400

Call Trace:
lapic_next_event
ehci_work
tick_dev_program_event
tick_program_event
hrtimer_interrupt
ehci_watchdog+0x0/0x37
ehci_watchdog+0x2b/0x37
run_timer_softirq
__do_softirq
irq_exit
do_IRQ
common_interrupt
acpi_idle_enter_bm
cpuidle_idle_call
cpu_idle
start_kernel

Code: 00 00 00 00 3c 03 88 44 24 1f 0f 94 c0 81 ea ec 00 00 00 0f b6 c0 89 44 
24 14 89 14 24 8b 46 0c 31 db bd 8d ff ff ff c6 46 28 00 <8b> 08 89 4c 24 10 
e9 ec 02 00 00 83 e8 38 85 db 89 44 24 24 8b


-- 
Ondrej Zary
