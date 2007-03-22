Return-Path: <linux-kernel-owner+w=401wt.eu-S965671AbXCVEXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbXCVEXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXCVEXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:23:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52076 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965671AbXCVEXy (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:23:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: PNPACPI probes serial twice, messes up serial console 
In-reply-to: Your message of "Wed, 21 Mar 2007 10:35:38 MDT."
             <200703211035.39340.bjorn.helgaas@hp.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 22 Mar 2007 15:23:51 +1100
Message-ID: <11466.1174537431@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas (on Wed, 21 Mar 2007 10:35:38 -0600) wrote:
>On Tuesday 20 March 2007 08:32, Bjorn Helgaas wrote:
>> On Tuesday 20 March 2007 00:46, Keith Owens wrote:
>> > Booting with 'console=tty console=ttyS0,9600'.  The serial console on
>> > ttyS0 (0x3f8, irq 4) is probed twice, once from serial8250_init() and
>> > again from serial_pnp_probe().
>> 
>> I played with this last summer, but was too timid to finish it
>> and post it.  My plan was to remove the legacy SERIAL_PORT_DFNS,
>> make platform devices for them, and only register the platform
>> devices in the absence of PNP.
>> 
>> My motivation at the time was to prevent 8250 from claiming IRDA
>> devices that happened to live at legacy UART addresses.  I also
>> wanted to make IRDA (smsc-ircc2 in my case) smart enough to use
>> PNP to locate its devices, since 8250 would no longer claim them.
>> 
>> Here's the dusty patch (against 2.6.18-rc1-mm2).  If it seems
>> like a reasonable thing to do, I can update it, polish it up,
>> add a changelog, and post it.
>
>Keith, does this patch help?  Russell didn't complain about it, so
>if it fixes your problem, maybe we could put it in -mm and see if
>it breaks anything else.

The aim of the patch looks sensible, but it will not compile for
2.6.21-rc4.  8250_x86.c tests pnp_platform_devices, which does not
exist.  Also the combination of CONFIG_SERIAL_8250_X86=y and
CONFIG_SERIAL_8250_PNP=m would result in 8250_x86.o being built into
vmlinux but referring to serial8250_nopnp in module 8250_pnp.o, kernel
to module references are tricky.

