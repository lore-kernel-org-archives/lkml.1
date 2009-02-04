Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZBDEmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZBDEmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbZBDEm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:42:26 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:33404 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZBDEmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:42:24 -0500
Date: Tue, 03 Feb 2009 23:42:12 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
In-reply-to: <49890B46.8020308@intertwingly.net>
X-X-Sender: lenb@localhost.localdomain
To: Sam Ruby <rubys@intertwingly.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       x86@kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Message-id: <alpine.LFD.2.00.0902032336000.5607@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <4978767D.4060700@intertwingly.net>
 <20090130000758.1dff0113.akpm@linux-foundation.org>
 <498885CC.4060509@intertwingly.net>
 <20090203114849.b661f1ce.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
 <49890B46.8020308@intertwingly.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you have a second computer around with a serial port ? If yes, then
> > please add the following to the kernel command line:
> > 
> >        earlyprintk=serial,ttyS0,115200 apic=debug
> > 
> > and connect the serial ports with a null modem cable. Fire up a
> > terminal program on the second machine and capture the output.
> 
> I do have a second computer, and went out and bought a null modem adapter for
> my serial cable and connected the two machines.  I've tried installing minicom
> and also connecting it to ttyS0 at 115200 baud on the second machine, but when
> I boot the first machine I don't see any output on the terminal.

/boot/grub/menu.lst:

serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
terminal --timeout=300 serial console

is what I use.

this will give you a prompt from grub even before the kernel boots
so you can select (and edit) your kernel via menu over the serial line
if you wish.

If this doesn't work, then the kernel earlyprintk is unlikely to work 
also.

Note that there may be some BIOS SETUP options related to the serial port 
-- worth checking.

Also, in minicom, be sure to turn off HW flow control

there is a fancy serial console document someplace on this,
probably at http://tldp.org/

good luck,
-Len

